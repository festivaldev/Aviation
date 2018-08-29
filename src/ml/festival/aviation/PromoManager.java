/**
 * FESTIVAL Aviation
 * PromoManager.java
 *
 * @description This class handles everything regarding featured travel places
 * @author Janik Schmidt (jani.schmidt@ostfalia.de)
 * @author Jonas Zadach (j.zadach@ostfalia.de)
 * @version 1.0
 */

package ml.festival.aviation;

import javax.naming.*;
import javax.sql.*;
import java.sql.*;

public class PromoManager {
	/**
	 * Create some private field we need for an instance
	 */
	private InitialContext initialContext;
	private Context environmentContext;
	private DataSource dataSource;
	private Connection conn;

	/**
	 * Initializer
	 */
	public PromoManager() {
		/**
		 * Using anything regarding SQL connections is required
		 * to be wrapped inside try/catch. Else IntelliJ refuses
		 * to compile anything.
		 *
		 * Since we don't need to reopen the connection,
		 * we can keep this inside the initializer
		 */
		try {
			initialContext = new InitialContext();
			environmentContext = (Context)initialContext.lookup("java:/comp/env");
			dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
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
	 * This method returns all the categories for featured travel places in a random order
	 * @return A ResultSet containing the categories, including ID and title
	 */
	public ResultSet getPromoCategories() {
		try {
			Statement statement = conn.createStatement();
			return statement.executeQuery("SELECT * FROM promo_categories ORDER BY RAND()");
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * This method returns details for a specific category
	 * @param categoryId The ID of a category we need the details for
	 * @return A ResultSet containing the category, including ID and title
	 */
	public ResultSet getCategoryForId(String categoryId) {
		try {
			PreparedStatement statement =conn.prepareStatement("SELECT * FROM promo_categories WHERE promo_categories.id = ?");
			statement.setString(1, categoryId);

			return statement.executeQuery();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * This method returns all the locations for a specific category in a random order
	 * @param categoryId The ID of a category we want the locations from
	 * @return A ResultSet containing the locations of a category, including (but not limited to) ID, title, location, text content and header image
	 */
	public ResultSet getLocationsForCategory(String categoryId) {
		try {
			PreparedStatement statement =conn.prepareStatement("SELECT * FROM promo_texts WHERE promo_texts.categoryId = ? ORDER BY RAND()");
			statement.setString(1, categoryId);

			return statement.executeQuery();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * This method returns a random location for a specific category
	 * @param categoryId The ID of a category we want the locations from
	 * @return A ResultSet containing a single location of a category, including (but not limited to) ID, title, location, text content and header image
	 */
	public ResultSet getLocationForCategory(String categoryId) {
		try {
			PreparedStatement statement =conn.prepareStatement("SELECT * FROM promo_texts WHERE promo_texts.categoryId = ? ORDER BY RAND() LIMIT 1");
			statement.setString(1, categoryId);

			return statement.executeQuery();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * This method returns a specific location
	 * @param locationId The ID of a location we need the details for
	 * @return A ResultSet containing the details of a single location, including (but not limited to) ID, title, location, text content and header image
	 */
	public ResultSet getLocationForId(String locationId) {
		try {
			PreparedStatement statement =conn.prepareStatement("SELECT * FROM promo_texts WHERE promo_texts.id = ?");
			statement.setString(1, locationId);

			return statement.executeQuery();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
