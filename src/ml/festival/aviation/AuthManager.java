/**
 * FESTIVAL Aviation
 * AuthManager.java
 *
 * @description This class handles everything regarding authentication and sessions
 * @author Janik Schmidt (jani.schmidt@ostfalia.de)
 * @version 1.0
 */

package ml.festival.aviation;

import javax.naming.*;
import javax.sql.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;

public class AuthManager {
	/**
	 * Create some private field we need for an instance
	 */
	private InitialContext initialContext;
	private Context environmentContext;
	private DataSource dataSource;
	private Connection conn;

	/**
	 * Create an enum with error codes and somewhat descriptive names
	 */
	public static enum ErrorCode {
		OK,
		USER_NOT_FOUND,
		PASSWORD_INCORRECT,
		USER_ALREADY_EXISTS,
		PASSWORD_VERIFICATION_FAILED,
		SERVER_ERROR
	}

	/**
	 * Initializer
	 */
	public AuthManager() {
		/**
		 * Using anything regarding SQL connections is required
		 * to be wrapped inside try/catch. Else IntelliJ refuses
		 * to compile anything.
		 */
		try {
			openConnection();
		} catch (Exception e) {
			// If something bad happens during the connection init,
			// print it to stdout
			e.printStackTrace();
		}
	}

	/**
	 * Here we create a new connection. Connection details
	 * are found in META-INF/context.xml and WEB-INF/web.xml
	 */
	public void openConnection() {
		try {
			initialContext = new InitialContext();
			environmentContext = (Context) initialContext.lookup("java:/comp/env");
			dataSource = (DataSource) environmentContext.lookup("jdbc/aviation");
			conn = dataSource.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * If we are done authenticating or verifying, we NEED
	 * to close the connection, because Tomcat doesn't do it
	 * on its own. And if we don't close it, Tomcat will
	 * eventually freeze. (We had to restart Tomcat at least
	 * hundreds of times because of this issue)
	 */
	public void closeConnection() {
		try {
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * A method to convert byte data returned from
	 * MessageDigest.digest() into a usable string
	 *
	 * @param bytes Byte data from MessageDigest.digest(), or any other byte data
	 * @return A usable string
	 */
	private String bytesToHex(byte[] bytes) {
		StringBuffer result = new StringBuffer();
		for (byte byt : bytes) result.append(Integer.toString((byt & 0xff) + 0x100, 16).substring(1));
		return result.toString();
	}

	/**
	 * This method registers a new user inside the database
	 *
	 * @param firstName A user's first name
	 * @param lastName A user's last name
	 * @param email A user's email address
	 * @param password A user's password, encoded in Base64 (Plain text transmissions? We don't do that here)
	 * @return An error code indicating if the registration was successful or not
	 */
	public ErrorCode register(String firstName, String lastName, String email, String password) {
		try {
			// First, we need to check if this user already exists.
			// We do that by querying the database if the entered email address already exists.
			PreparedStatement statement = conn.prepareStatement("SELECT * FROM accounts WHERE email = ?");
			statement.setString(1, email);
			ResultSet existingAccount = statement.executeQuery();

			if (!existingAccount.next()) {
				// If the database returned an empty result, we can continue
				// to add the user to the database.
				statement = conn.prepareStatement("INSERT INTO `accounts` VALUES (?, ?, ?, ?, ?, FALSE, default, default)");

				// Here we generate a unique identifier for the new account.
				// The identifier is a 32 character Base64 encoded SHA256 hash of the following items:
				// First name, Last name, Email Address, the already hashed password and the current Unix timestamp
				statement.setString(1, bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%s%s%s%s%d", firstName, lastName, email, password, System.currentTimeMillis() / 1000L).getBytes(StandardCharsets.UTF_8))).substring(0, 32));
				statement.setString(2, firstName);
				statement.setString(3, lastName);
				statement.setString(4, email);
				statement.setString(5, password);

				// If the statement executed, return code 0
				statement.execute();
				return ErrorCode.OK;
			} else {
				// If the user already exists, return code 3
				return ErrorCode.USER_ALREADY_EXISTS;
			}
		} catch (Exception e) {
			// If something bad happened, print to stdout and return code 5
			e.printStackTrace();
			return ErrorCode.SERVER_ERROR;
		}
	}

	/**
	 * This method validates an existing session id
	 * @param sessionId The "sid" attribute that is stored inside Tomcat's Session object
	 * @return true if the session is valid and hasn't expired, otherwise false
	 */
	public Boolean validate(String sessionId) {
		try {
			// Actually, we just check if the session specified still exists.
			// If it exists, JSP takes care about extending the remaining
			// session duration (usually 2 hours)
			PreparedStatement statement = conn.prepareStatement("SELECT accountId FROM sessions WHERE id = ?");
			statement.setString(1, sessionId);

			return statement.executeQuery().next();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	/**
	 * This method takes care about logging users in
	 * @param email The E-Mail address of a user that wants to log in
	 * @param password The password of a user that wants to log in, encoded in Base64.
	 * @return An error code indicating if the login was successful or not
	 */
	public ErrorCode login(String email, String password) {
		try {
			// Let's check if the specified user exists at all
			PreparedStatement statement = conn.prepareStatement("SELECT * FROM accounts WHERE email = ?");
			statement.setString(1, email);
			ResultSet existingAccount = statement.executeQuery();

			if (existingAccount.next()) {
				// The user exists, now let's compare passwords
				// This would probably have been a lot more secure
				// if we could have used Node.js as a server instead
				// of Tomcat
				if (password.equals(existingAccount.getString("password"))) {
					// Passwords are equal, return code 0
					return ErrorCode.OK;
				} else {
					// Passwords are not equal, return code 2
					return ErrorCode.PASSWORD_INCORRECT;
				}
			} else {
				// The user does not exist, return code 1
				return ErrorCode.USER_NOT_FOUND;
			}
		} catch (Exception e) {
			// Business as usual
			e.printStackTrace();
			return ErrorCode.SERVER_ERROR;
		}
	}

	/**
	 * This method generates a session for a specified email
	 * @param email A user's email address
	 * @return An error code indicating if generating a session was successful or not
	 */
	public ErrorCode generateSession(String email) {
		try {
			// Check user existence
			PreparedStatement statement = conn.prepareStatement("SELECT id, password FROM accounts WHERE email = ?");
			statement.setString(1, email);
			ResultSet user = statement.executeQuery();

			if (user.next()) {
				// User exists, delete any previous session (if existing)
				statement = conn.prepareStatement("DELETE FROM `sessions` where `accountId`= ?");
				statement.setString(1, user.getString("id"));
				statement.execute();

				// Create a new session
				statement = conn.prepareStatement("INSERT INTO `sessions` VALUES (?, ?, default, default)");

				// A session id generated similar to a user id, but with the following data:
				// User ID, email, the stored password (hashed) and the current UNIX timestamp
				statement.setString(1, bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%s%s%s%d", user.getString("id"), email, user.getString("password"), System.currentTimeMillis() / 1000L).getBytes(StandardCharsets.UTF_8))).substring(0, 32));
				statement.setString(2, user.getString("id"));
				statement.execute();

				return ErrorCode.OK;
			} else {
				return ErrorCode.USER_NOT_FOUND;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ErrorCode.SERVER_ERROR;
		}
	}

	/**
	 * This method destroys a session by its id
	 * @param sessionId The ID of a session to destroy
	 * @return An error code indicating if destroying the session was successful or not
	 */
	public ErrorCode destroySession(String sessionId) {
		try {
			PreparedStatement statement = conn.prepareStatement("DELETE FROM sessions WHERE id = ?");
			statement.setString(1, sessionId);
			statement.execute();

			return ErrorCode.OK;
		} catch (Exception e) {
			e.printStackTrace();
			return ErrorCode.SERVER_ERROR;
		}
	}

	/**
	 * This method returns the current session ID of a logged in user
	 * @param email  A user's email address
	 * @return The user's session ID if existing, otherwise null
	 */

	public String getCurrentSessionId(String email) {
		try {
			// Check if the user exists
			PreparedStatement statement = conn.prepareStatement("SELECT id, password FROM accounts WHERE email = ?");
			statement.setString(1, email);
			ResultSet user = statement.executeQuery();

			if (user.next()) {
				// User exists, check if he has an ongoing session
				statement = conn.prepareStatement("SELECT id FROM sessions WHERE accountID = ?");
				statement.setString(1, user.getString("id"));

				ResultSet session = statement.executeQuery();

				if (session.next()) {
					// User has a current session, return its ID
					return session.getString("id");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * This method is used inside the dashboard and returns a users profile details
	 * @param sessionId A user's valid session ID
	 * @return A ResultSet object containing a users "public" details
	 */
	public ResultSet getProfileDetails(String sessionId) {
		try {
			// Check if the session exists, return corresponding account ID
			PreparedStatement statement = conn.prepareStatement("SELECT accountID FROM sessions WHERE id = ?");
			statement.setString(1, sessionId);
			ResultSet session = statement.executeQuery();

			if (session.next()) {
				// RETURN ALL THE DETAILS!
				statement = conn.prepareStatement("SELECT firstName, lastName, email, isAdmin FROM accounts WHERE id = ?");
				statement.setString(1, session.getString("accountId"));

				return statement.executeQuery();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * This method gets a user's current billing address, and is
	 * used inside the dashboard and when booking a flight
	 * @param sessionId A user's valid session ID
	 * @return A ResultSet object containing a user's billing address information (if existing)
	 */
	public ResultSet getBillingAddress(String sessionId) {
		try {
			// Check if the session exists, return corresponding account ID
			PreparedStatement statement = conn.prepareStatement("SELECT accountID FROM sessions WHERE id = ?");
			statement.setString(1, sessionId);
			ResultSet session = statement.executeQuery();

			if (session.next()) {
				// Get a user's billing address details if existing
				statement = conn.prepareStatement("SELECT * FROM billing_addresses WHERE accountId = ?");
				statement.setString(1, session.getString("accountId"));

				ResultSet billingAddress = statement.executeQuery();

				if (billingAddress.next()) {
					// RETURN ALL THE DETAILS!
					return billingAddress;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
}
