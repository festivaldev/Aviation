/**
 * FESTIVAL Aviation
 * SearchResultsDemo.java
 *
 * @description This class serves as a replacement for real world data
 * @author Janik Schmidt (jani.schmidt@ostfalia.de)
 * @version 1.0
 */

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
	/**
	 * Store some real world Airlines because why not?
	 */
	private static String[] flightCompanies = {"NZ", "EK", "EY", "AY", "LH", "MH", "QF", "QR", "SK", "SQ", "TK", "UA", "VS"};

	/**
	 * A method to convert byte data returned from
	 * MessageDigest.digest() into a usable string
	 *
	 * @param bytes Byte data from MessageDigest.digest(), or any other byte data
	 * @return A usable string
	 */
	private static String bytesToHex(byte[] bytes) {
		StringBuffer result = new StringBuffer();
		for (byte byt : bytes) result.append(Integer.toString((byt & 0xff) + 0x100, 16).substring(1));
		return result.toString();
	}

	/**
	 * This method generates random flight data that is shown while searching for a flight
	 * @param departure The IATA code for the origin airport
	 * @param arrival The IATA code for the destination airport
	 * @param departureDate The requested departure date
	 * @return a JSONObject containing random flight data
	 */
	public static JSONObject getDemoData(String departure, String arrival, LocalDate departureDate) {
		try {
			// Create a new database connection (we know that already)
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context)initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();

			// Get all the information about the origin airport
			PreparedStatement statement = conn.prepareStatement("SELECT * FROM airports WHERE iata_code = ?");
			statement.setString(1, departure);
			ResultSet departureSet = statement.executeQuery();

			// Get all the information about the destination airport
			statement = conn.prepareStatement("SELECT * FROM airports WHERE iata_code = ?");
			statement.setString(1, arrival);
			ResultSet arrivalSet = statement.executeQuery();

			// Check if we have both an origin airport object and a destination airport object
			if (departureSet.next() && arrivalSet.next()) {
				// Create a new JSON object that will be returned later
				JSONObject returnObj = new JSONObject();

				// There are no Easter Eggs up here
				if (departureSet.getString("gps_code").equals("OSTF")) {
					returnObj.put("redirect", String.format("secret.jsp?key=%s", Base64.getEncoder().encodeToString(departureSet.getString("home_link").getBytes())));
					return returnObj;
				}
				if (arrivalSet.getString("gps_code").equals("OSTF")) {
					returnObj.put("redirect", String.format("secret.jsp?key=%s", Base64.getEncoder().encodeToString(arrivalSet.getString("home_link").getBytes())));
					return returnObj;
				}

				// Fill the return object with data from the airport objects
				returnObj.put("departureDate", departureDate);
				returnObj.put("departureName", departureSet.getString("name"));
				returnObj.put("departureMunicipality", departureSet.getString("municipality"));
				returnObj.put("departureIATA", departureSet.getString("iata_code"));
				returnObj.put("arrivalName", arrivalSet.getString("name"));
				returnObj.put("arrivalMunicipality", arrivalSet.getString("municipality"));
				returnObj.put("arrivalIATA", arrivalSet.getString("iata_code"));

				// Here we generate a random amount of extra departure dates
				// Extra departure dates exist in case the original date
				// doesn't contain any suitable flights
				JSONArray objArray = new JSONArray();
				// Generate at least 3, at max 9 dates
				for (int i = 0; i < new Random().nextInt(7) + 3; i++) {
					// Create a JSON Object that will contain date information
					JSONObject dateObj = new JSONObject();
					dateObj.put("departureDate", departureDate);	// Add the current date to the date object
					departureDate = departureDate.plusDays(1); 		// Prepare the date for the next date object


					JSONArray dateObjArray = new JSONArray();
					// Generate at least 5, at max 10 random flights
					for (int j = 0; j < new Random().nextInt(6) + 5; j++) {
						JSONObject obj = new JSONObject();
						obj.put("departureTime", new Time((long)new Random().nextInt(24*60*60*1000)));	// Generate random departure time
						obj.put("arrivalTime", new Time((long)new Random().nextInt(24*60*60*1000)));		// Generate random arrival time
						// If the arrival time is before the departure time, it's assumed the flight arrives the next day

						obj.put("stops", new Random().nextInt(3));	// Generate random amount of stops (change of planes)
						obj.put("flightNumber", flightCompanies[new Random().nextInt(flightCompanies.length)] + new Random().nextInt(9999));		// Pick a random airline code from above, add a random flight number
						obj.put("price", new Random().nextInt(300) + 99);	// Add a random price (at least 99€, at max 398€)

						// Put the object inside the date array
						dateObjArray.put(obj);
					}

					// Put all the Objects! (in their respective places)
					dateObj.put("items", dateObjArray);
					objArray.put(dateObj);
				}
				returnObj.put("items", objArray);

				// Close the database connection. Else Tomcat strikes
				conn.close();

				// Return the flight data
				return returnObj;
			}
		} catch (Exception e) {
			// Business as usual
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * This method was originally designed to parse POST request data
	 * into a JSON object. However, with continued development, this
	 * changed into getting DB data again (like getDemoData),
	 * but this time using a JSONObject instead
	 * @param requestData A JSON object containing parsed POST request data
	 * @return A JSON object containing airport details as seen in getDemoData
	 */
	public static JSONObject getJSONData(JSONObject requestData) {
		try {
			// Create a new database connection (we know that already)
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource) environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();

			// Get all the information about the origin airport
			PreparedStatement statement = conn.prepareStatement("SELECT * FROM airports WHERE iata_code = ?");
			statement.setString(1, requestData.getString("depart_iata"));
			ResultSet departureSet = statement.executeQuery();

			// Get all the information about the destination airport
			statement = conn.prepareStatement("SELECT * FROM airports WHERE iata_code = ?");
			statement.setString(1, requestData.getString("arrv_iata"));
			ResultSet arrivalSet = statement.executeQuery();

			// Check if we have both an origin airport object and a destination airport object
			if (departureSet.next() && arrivalSet.next()) {
				// Create a new JSON object that will be returned later
				JSONObject returnObj = new JSONObject();

				// Fill the return object with data from the airport objects
				returnObj.put("departureDate", LocalDate.parse(requestData.getString("depart_date"), DateTimeFormatter.ISO_DATE_TIME));
				returnObj.put("departureName", departureSet.getString("name"));
				returnObj.put("departureMunicipality", departureSet.getString("municipality"));
				returnObj.put("departureIATA", departureSet.getString("iata_code"));
				returnObj.put("arrivalName", arrivalSet.getString("name"));
				returnObj.put("arrivalMunicipality", arrivalSet.getString("municipality"));
				returnObj.put("arrivalIATA", arrivalSet.getString("iata_code"));

				// Close the database connection. Else Tomcat strikes
				conn.close();

				// Return the airport data
				return returnObj;
			}
		} catch (Exception e) {
			// Business as usual
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * This method returns service data that is required during booking a flight
	 * @return A JSON array containing service details
	 */
	public static JSONArray getServiceData() {
		try {
			// Create a new database connection (we know that already)
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource) environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();

			// Get all the information about existing services
			PreparedStatement statement = conn.prepareStatement("SELECT * FROM services ORDER BY price ASC");
			ResultSet obj = statement.executeQuery();

			JSONArray returnArray = new JSONArray();
			while (obj.next()) {
				JSONObject jsonObject = new JSONObject();

				// Put the information into a usable JSON Object
				jsonObject.put("id", obj.getString("id"));
				jsonObject.put("serviceId", obj.getString("serviceId"));
				jsonObject.put("title", obj.getString("title"));
				jsonObject.put("price", obj.getString("price"));

				returnArray.put(jsonObject);
			}

			// Close the database connection. Else Tomcat strikes
			conn.close();

			// Return the service data
			return returnArray;
		} catch (Exception e) {
			// Business as usual
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * This method completes a booking process
	 * It's located inside SearchResultsDemo.java because
	 * it uses data in a way that shouldn't be done in production
	 * @param requestData A JSON object containing parsed POST request data
	 * @return The booking ID that is used to display a button to redirect to checkout, if unsuccessful null
	 */
	public static String completeBooking(JSONObject requestData) {
		try {
			// Create a new database connection (we know that already)
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource) environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();

			// Check if we  have a billing address with the specified E-Mail address
			PreparedStatement statement = conn.prepareStatement("SELECT firstName, lastName, accountId FROM billing_addresses WHERE id = ?");
			statement.setString(1, requestData.getString("billingId"));
			ResultSet holder = statement.executeQuery();

			if (holder.next()) {
				// We've got a billing address, let's create a new booking entry

				// The booking id is created just like a user ID, but with the current UNIX timestamp
				String bookingId = bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%d", System.currentTimeMillis() / 1000L).getBytes(StandardCharsets.UTF_8))).substring(0, 32);

				statement = conn.prepareStatement("INSERT INTO bookings VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, DEFAULT, DEFAULT)");
				statement.setString(1, bookingId);

				// The "Cancellation Verification ID" is a 8 character ID also using the current UNIX timestamp, but is also adding a random Int between 0 and 100.000.000
				statement.setString(2, bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%d", System.currentTimeMillis() / 1000L + new Random().nextInt((int) 1e8)).getBytes(StandardCharsets.UTF_8))).substring(0, 13));

				if (!holder.getString("accountId").isEmpty()) {
					// If we have an accountId in the billing address, we're using that as the holder.
					/// TODO: Account verification
					/// NOTE: Probably already did this just by getting the accountId from sessions
					statement.setString(3, holder.getString("accountId"));
				} else {
					// Otherwise we just use first name and last name from the billing address
					statement.setString(3, holder.getString("firstName") + " " + holder.getString("lastName"));
				}

				statement.setString(4, requestData.getString("flight_number"));
				statement.setString(5, requestData.getString("depart_iata"));
				statement.setString(6, requestData.getString("arrv_iata"));

				// Format the departure date again because Java doesn't like handling timezones at all.
				LocalDateTime dateTime = LocalDateTime.parse(requestData.getString("depart_date"), DateTimeFormatter.ISO_DATE_TIME);
				statement.setString(7, dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS")));
				statement.setString(8, requestData.getString("flight_class"));
				statement.setString(9, requestData.getString("passengers"));
				statement.setString(10, requestData.getString("services"));
				statement.setString(11, requestData.getString("price"));

				if (statement.executeUpdate() > 0) {
					// Return the booking ID ONLY if inserting the booking was successful
					return bookingId;
				}
			}
		} catch (Exception e) {
			// Business as usual
			e.printStackTrace();
		}
		return null;
	}
}
