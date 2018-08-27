package ml.festival.aviation;

import org.json.JSONArray;
import org.json.JSONObject;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.time.LocalDate;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

public class SearchResultsDemo {
	private static String[] flightCompanies = {"NZ", "EK", "EY", "AY", "LH", "MH", "QF", "QR", "SK", "SQ", "TK", "UA", "VS"};

	private static String bytesToHex(byte[] bytes) {
		StringBuffer result = new StringBuffer();
		for (byte byt : bytes) result.append(Integer.toString((byt & 0xff) + 0x100, 16).substring(1));
		return result.toString();
	}

	public static JSONObject getDemoData(String departure, String arrival, LocalDate departureDate) {
		try {
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context)initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();

			PreparedStatement statement = conn.prepareStatement("SELECT * FROM airports WHERE iata_code = ?");
			statement.setString(1, departure);
			ResultSet departureSet = statement.executeQuery();

			statement = conn.prepareStatement("SELECT * FROM airports WHERE iata_code = ?");
			statement.setString(1, arrival);
			ResultSet arrivalSet = statement.executeQuery();

			if (departureSet.next() && arrivalSet.next()) {
				JSONObject returnObj = new JSONObject();

				returnObj.put("departureDate", departureDate);
				returnObj.put("departureName", departureSet.getString("name"));
				returnObj.put("departureMunicipality", departureSet.getString("municipality"));
				returnObj.put("departureIATA", departureSet.getString("iata_code"));
				returnObj.put("arrivalName", arrivalSet.getString("name"));
				returnObj.put("arrivalMunicipality", arrivalSet.getString("municipality"));
				returnObj.put("arrivalIATA", arrivalSet.getString("iata_code"));

				JSONArray objArray = new JSONArray();
				for (int i = 0; i < new Random().nextInt(7) + 3; i++) {
					JSONObject dateObj = new JSONObject();
					dateObj.put("departureDate", departureDate);
					departureDate = departureDate.plusDays(1);


					JSONArray dateObjArray = new JSONArray();
					for (int j = 0; j < new Random().nextInt(6) + 5; j++) {
						JSONObject obj = new JSONObject();
						obj.put("departureTime", new Time((long)new Random().nextInt(24*60*60*1000)));
						obj.put("arrivalTime", new Time((long)new Random().nextInt(24*60*60*1000)));
						obj.put("stops", new Random().nextInt(3));
						obj.put("flightNumber", flightCompanies[new Random().nextInt(flightCompanies.length)] + new Random().nextInt(9999));
						obj.put("price", new Random().nextInt(300) + 99);

						dateObjArray.put(obj);
					}

					dateObj.put("items", dateObjArray);
					objArray.put(dateObj);
				}
				returnObj.put("items", objArray);

				conn.close();
				return returnObj;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static JSONObject getJSONData(JSONObject requestData) {
		try {
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource) environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();

			PreparedStatement statement = conn.prepareStatement("SELECT * FROM airports WHERE iata_code = ?");
			statement.setString(1, requestData.getString("depart_iata"));
			ResultSet departureSet = statement.executeQuery();

			statement = conn.prepareStatement("SELECT * FROM airports WHERE iata_code = ?");
			statement.setString(1, requestData.getString("arrv_iata"));
			ResultSet arrivalSet = statement.executeQuery();

			if (departureSet.next() && arrivalSet.next()) {
				JSONObject returnObj = new JSONObject();

				returnObj.put("departureDate", LocalDate.parse(requestData.getString("depart_date"), DateTimeFormatter.ISO_DATE_TIME));
				returnObj.put("departureName", departureSet.getString("name"));
				returnObj.put("departureMunicipality", departureSet.getString("municipality"));
				returnObj.put("departureIATA", departureSet.getString("iata_code"));
				returnObj.put("arrivalName", arrivalSet.getString("name"));
				returnObj.put("arrivalMunicipality", arrivalSet.getString("municipality"));
				returnObj.put("arrivalIATA", arrivalSet.getString("iata_code"));

				conn.close();
				return returnObj;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static JSONArray getServiceData() {
		try {
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource) environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();

			PreparedStatement statement = conn.prepareStatement("SELECT * FROM services ORDER BY price ASC");
			ResultSet obj = statement.executeQuery();

			JSONArray returnArray = new JSONArray();
			while (obj.next()) {
				JSONObject jsonObject = new JSONObject();

				jsonObject.put("id", obj.getString("id"));
				jsonObject.put("serviceId", obj.getString("serviceId"));
				jsonObject.put("title", obj.getString("title"));
				jsonObject.put("price", obj.getString("price"));

				returnArray.put(jsonObject);
			}

			conn.close();
			return returnArray;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	public static void completeBooking(JSONObject requestData) {
		try {
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource) environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();

			PreparedStatement statement = conn.prepareStatement("INSERT INTO bookings VALUES(?, 'SVID', '', ?, ?, ?, ?, ?, ?, ?, 0, DEFAULT, DEFAULT)");
			statement.setString(1, bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%d", System.currentTimeMillis() / 1000L).getBytes(StandardCharsets.UTF_8))).substring(0, 32));
			statement.setString(2, requestData.getString("flight_number"));
			statement.setString(3, requestData.getString("depart_iata"));
			statement.setString(4, requestData.getString("arrv_iata"));

			LocalDateTime dateTime = LocalDateTime.parse(requestData.getString("depart_date"), DateTimeFormatter.ISO_DATE_TIME);
			statement.setString(5, dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")));
			statement.setString(6, requestData.getString("flight_class"));
			statement.setString(7, requestData.getString("passengers"));
			statement.setString(8, requestData.getString("services"));
			statement.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
