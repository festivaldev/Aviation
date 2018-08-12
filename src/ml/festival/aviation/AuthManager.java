package ml.festival.aviation;

import javax.naming.*;
import javax.sql.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;
import java.util.Base64;

public class AuthManager {
	private InitialContext initialContext;
	private Context environmentContext;
	private DataSource dataSource;
	private Connection conn;

	public static enum ErrorCode {
		OK,
		USER_NOT_FOUND,
		PASSWORD_INCORRECT,
		USER_ALREADY_EXISTS,
		PASSWORD_VERIFICATION_FAILED,
		SERVER_ERROR
	}

	public AuthManager() {
		try {
			initialContext = new InitialContext();
			environmentContext = (Context)initialContext.lookup("java:/comp/env");
			dataSource = (DataSource)environmentContext.lookup("jdbc/iae_test");
			conn = dataSource.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private String bytesToHex(byte[] bytes) {
		StringBuffer result = new StringBuffer();
		for (byte byt : bytes) result.append(Integer.toString((byt & 0xff) + 0x100, 16).substring(1));
		return result.toString();
	}

	public ErrorCode register(String firstName, String lastName, String email, String password) {
		try {
			PreparedStatement statement = conn.prepareStatement("SELECT * FROM accounts WHERE email = ?");
			statement.setString(1, email);
			ResultSet existingAccount = statement.executeQuery();

			if (!existingAccount.next()) {
				String hashedPassword = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(password.getBytes(StandardCharsets.UTF_8))));

				statement = conn.prepareStatement("INSERT INTO `accounts` VALUES (?, ?, ?, ?, ?, default, default)");

				statement.setString(1, bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%s%s%s%s%d", firstName, lastName, email, hashedPassword, System.currentTimeMillis() / 1000L).getBytes(StandardCharsets.UTF_8))).substring(0, 32));
				statement.setString(2, firstName);
				statement.setString(3, lastName);
				statement.setString(4, email);
				statement.setString(5, hashedPassword);

				statement.execute();
				return ErrorCode.OK;
			} else {
				return ErrorCode.USER_ALREADY_EXISTS;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ErrorCode.SERVER_ERROR;
		}
	}

	public ErrorCode login() {
		return ErrorCode.SERVER_ERROR;
	}

	public ErrorCode generateSession(String email) {
		try {
			PreparedStatement statement = conn.prepareStatement("SELECT id, password FROM accounts WHERE email = ?");
			statement.setString(1, email);
			ResultSet user = statement.executeQuery();

			if (user.next()) {
				statement = conn.prepareStatement("DELETE FROM `sessions` where `accountId`= ?");
				statement.setString(1, user.getString("id"));
				statement.execute();

				statement = conn.prepareStatement("INSERT INTO `sessions` VALUES (?, ?, default, default)");
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

	public String getCurrentSessionId(String email) {
		try {
			PreparedStatement statement = conn.prepareStatement("SELECT id, password FROM accounts WHERE email = ?");
			statement.setString(1, email);
			ResultSet user = statement.executeQuery();

			if (user.next()) {
				statement = conn.prepareStatement("SELECT id FROM sessions WHERE accountID = ?");
				statement.setString(1, user.getString("id"));

				ResultSet session = statement.executeQuery();

				if (session.next()) {
					return session.getString("id");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
}