package ml.festival.aviation;

import javax.naming.*;
import javax.sql.*;
import java.sql.*;

public class PromoManager {
	private InitialContext initialContext;
	private Context environmentContext;
	private DataSource dataSource;
	private Connection conn;

	public PromoManager() {
		try {
			initialContext = new InitialContext();
			environmentContext = (Context)initialContext.lookup("java:/comp/env");
			dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
			conn = dataSource.getConnection();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void closeConnection() {
		try {
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public ResultSet getPromoCategories() {
		try {
			Statement statement = conn.createStatement();
			return statement.executeQuery("SELECT * FROM promo_categories ORDER BY RAND()");
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

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

	public ResultSet getLocationsForCategory(String categoryId) {
		try {
			PreparedStatement statement =conn.prepareStatement("SELECT * FROM promo_texts WHERE promo_texts.categoryId = ?");
			statement.setString(1, categoryId);

			return statement.executeQuery();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

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
