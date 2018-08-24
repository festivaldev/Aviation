package ml.festival.aviation;

import org.json.JSONArray;
import org.json.JSONObject;

import java.time.format.DateTimeFormatter;
import java.util.*;
import java.time.LocalDate;
import java.sql.*;
import javax.sql.*;
import javax.naming.*;

public class SearchResultsDemo {
	private static String[] flightCompanies = {"NZ", "EK", "EY", "AY", "LH", "MH", "QF", "QR", "SK", "SQ", "TK", "UA", "VS"};

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
					dateObj.put("departureDate", departureDate); /// TODO: add days to departure date
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
}
