
<!--
	booking-results.jsp
	FESTIVAL Aviation
	
	This page shows flight data returned from the server
	The query must contain the following: depart_iata, arrv_iata, depart_date
	Optional data: passengers, flight_class
	
	@author Janik Schmidt (jani.schmidt@ostfalia.de)
	@version 1.0
-->
 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.SearchResultsDemo" %>
<%@ page import="org.json.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.Time" %>
<%@ page import="java.util.Map" %>
 
<%
	JSONObject demoData = new JSONObject();
 
	// Do stuff only if we have the minimum required data
	if (request.getParameter("depart_iata") != null && request.getParameter("arrv_iata") != null && request.getParameter("depart_date") != null) {
		// Fix Java's shitty UTC handling when using ISO date strings
		ZonedDateTime zonedDateTime = Instant.parse(request.getParameter("depart_date")).atZone(ZoneId.of("Europe/Berlin"));
		demoData = SearchResultsDemo.getDemoData(request.getParameter("depart_iata"), request.getParameter("arrv_iata"), zonedDateTime.toLocalDate());
 
		// There are no Easter Eggs up here
		if (demoData.has("redirect")) {
			response.sendRedirect(demoData.getString("redirect"));
			return;
		}
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Ergebnisse – FESTIVAL Aviation</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/booking.built.css">
	</head>
	<body>
		<nav class="global-nav">
			<div class="nav-content">
				<div class="nav-svg-header">
					<div onclick="document.querySelector('nav').classList.toggle('extended'); document.body.classList.toggle('no-scroll')" class="nav-svg-wrapper">
						<svg width="24" height="24" viewBox="0 0 96 96" class="nav-svg nav-svg-top">
							<rect x="0" y="44" width="96" height="8" fill="#FFFFFF" class="nav-svg-rect nav-svg-rect-top"></rect>
						</svg>
						<svg width="24" height="24" viewBox="0 0 96 96" class="nav-svg nav-svg-mid">
							<rect x="0" y="44" width="96" height="8" fill="#FFFFFF" class="nav-svg-rect nav-svg-rect-mid"></rect>
						</svg>
						<svg width="24" height="24" viewBox="0 0 96 96" class="nav-svg nav-svg-bottom">
							<rect x="0" y="44" width="96" height="8" fill="#FFFFFF" class="nav-svg-rect nav-svg-rect-bottom"></rect>
						</svg>
					</div><a href="#" class="link-home"></a><a href="dashboard.jsp" class="link-user-cp"></a>
				</div>
				<ul class="nav-list">
					<li><a href="index.jsp" class="link-home"></a></li>
					<li><a href="booking-search.jsp">Flüge</a></li>
					<li><a href="featured.jsp">Reiseziele</a></li>
					<li><a href="sc-contact.jsp">Kontakt</a></li>
					<li><a href="sc-index.jsp">Support</a></li>
					<li><a href="dashboard.jsp" class="link-user-cp"></a></li>
				</ul>
			</div>
		</nav>
		<section class="search-results">
			<div class="section-content row">
				<aside class="progress-overview column medium-3">
					<p class="progress-title">Flug buchen</p>
					<p class="progress-section-title">Vorbereitung</p>
					<ul>
						<li data-progress-made="true">
							 
							 <span>Reiseziel wählen</span>
							<div class="pipe"></div>
						</li>
						<li data-progress-made="true" class="current">
							 
							 <span>Flug wählen</span>
							<div class="pipe"></div>
						</li>
						<li data-progress-made="false">
							 
							 <span>Dienste wählen</span>
							<div class="pipe"></div>
						</li>
					</ul>
					<p class="progress-section-title">Bezahlung</p>
					<ul>
						<li data-progress-made="false">
							 
							 <span>Rechnungsadresse</span>
							<div class="pipe"></div>
						</li>
						<li data-progress-made="false">
							 
							 <span>Buchung abschließen</span>
							<div class="pipe"></div>
						</li>
					</ul>
				</aside>
				<div class="search-results-container column column-12 medium-8">
					<div class="search-results-header">
						<div class="row">
							<div data-key="departure" class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-departure.svg">
									<p>Von</p>
								</div>
								<p class="column-content"><%= demoData.getString("departureName") %></p>
							</div>
							<div data-key="arrival" class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-arrival.svg">
									<p>Nach</p>
								</div>
								<p class="column-content"><%= demoData.getString("arrivalName") %></p>
							</div>
						</div>
						<div class="row">
							<div data-key="date" class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-date.svg">
									<p>Abflugdatum</p>
								</div>
								<p class="column-content"><%= ((LocalDate)demoData.get("departureDate")).format(DateTimeFormatter.ofPattern("EEEE, dd. MMMM yyyy")) %></p>
							</div>
							<div class="column column-12 medium-2">
								<div class="column-title"><img src="img/icon-passenger.svg">
									<p>Passagiere</p>
								</div>
								<input type="number" name="passengers" value="<%= request.getParameter("passengers") != null ? request.getParameter("passengers") : 1 %>" min="1" max="10" oninput="passengerCountChanged(this)" class="column-content">
							</div>
							<div class="column column-12 medium-4">
								<div class="column-title"><img src="img/icon-class.svg">
									<p>Klasse</p>
								</div> 
								<%
									// If we got flight_class data, don't display that <select>
									if (request.getParameter("flight_class") != null) {
								%>
								<p class="column-content"><%= request.getParameter("flight_class") %></p> 
								<%
									} else {
								%>
								<p class="column-content">
									<select name="flight_class" onchange="classChanged(this)">
										<option value="economy">Economy</option>
										<option value="premium_economy">Premium Economy</option>
										<option value="business">Business</option>
										<option value="first">First Class</option>
									</select>
								</p> 
								<%
									}
								%>
							</div>
						</div>
					</div>
					<div class="scroll-container">
						 
						<%
							// Check if we have got data from the server
							if (demoData.has("items")) {
								// Iterate through the available data
							 	for (int i=0; i<((JSONArray)demoData.get("items")).length(); i++) {
									JSONObject resultObj = ((JSONArray)demoData.get("items")).getJSONObject(i);
									LocalDate departureDate = (LocalDate)resultObj.get("departureDate");
						%> 
						<div class="result-header">
							<h4 class="date"><span>Abflug</span> – <%= departureDate.format(DateTimeFormatter.ofPattern("dd MMM")) %></h4>
							<div class="table-header row">
								<div class="column column-2">
									<p><%= !((String)demoData.get("departureMunicipality")).isEmpty() ? demoData.get("departureMunicipality") : demoData.get("departureName") %></p>
								</div>
								<div class="column column-2 align-right">
									<p><%= !((String)demoData.get("arrivalMunicipality")).isEmpty() ? demoData.get("arrivalMunicipality") : demoData.get("arrivalName") %></p>
								</div>
								<div class="column column-2 column-offset-1">
									<p>Dauer</p>
								</div>
								<div class="column column-1">
									<p>Stopps</p>
								</div>
								<div class="column column-auto">
									<p>Flugnummer</p>
								</div>
								<div class="column column-2 align-right">
									<p>Preis</p>
								</div>
							</div>
						</div>
						<div class="results">
							 
							<%
									// Iterate through every flight in a single date object
									for (int j=0; j<((JSONArray)resultObj.get("items")).length(); j++) {
										JSONObject flightObj = ((JSONArray)resultObj.get("items")).getJSONObject(j);
										
										// Parse departure and arrival times
										LocalTime departureTime = ((Time)flightObj.get("departureTime")).toLocalTime().withSecond(0);
										LocalTime arrivalTime = ((Time)flightObj.get("arrivalTime")).toLocalTime().withSecond(0);
							 
										// Calculate the duration between departure and arrival
										Duration duration = Duration.between(departureTime, arrivalTime);
										if (duration.isNegative()) {
											// If the arrival time is before departure, add 24 hours	
											duration = duration.plusDays(1);
										}
							%>
							<div data-departure="<%= demoData.get("departureIATA") %>" data-arrival="<%= demoData.get("arrivalIATA") %>" data-departure-date="<%= departureDate.format(DateTimeFormatter.ISO_DATE) %>" data-departure-time="<%= departureTime.format(DateTimeFormatter.ISO_TIME) %>" data-arrival-time="<%= arrivalTime.format(DateTimeFormatter.ISO_TIME) %>" data-stops="<%= flightObj.get("stops") %>" data-flight-number="<%= flightObj.get("flightNumber") %>" data-price="<%= flightObj.get("price") %>" class="result-cell row">
								<div class="column column-2">
									<p><%= departureTime.format(DateTimeFormatter.ofPattern("HH:mm")) %></p>
								</div>
								<div class="column column-2 align-right">
									<p><%= arrivalTime.format(DateTimeFormatter.ofPattern("HH:mm")) %></p>
								</div>
								<div class="column column-2 column-offset-1">
									<p><%= String.format("%02dh %02dmin", duration.getSeconds() / 3600, (duration.getSeconds() % 3600) / 60) %></p>
								</div>
								<div class="column column-1">
									<p><%= flightObj.get("stops") %></p>
								</div>
								<div class="column column-auto">
									<p><%= flightObj.get("flightNumber") %></p>
								</div>
								<div class="column column-2 align-right">
									<p>ab <%= flightObj.get("price") %>€</p>
								</div>
							</div> 
							<%
									}
							%>
						</div> 
						<%
								}
							} 
						%>
					</div>
					<div class="fill-background"></div>
					<div class="results-footer">
						<button onclick="history.back()" class="outline blue">Zurück</button>
						<button disabled onclick="document.forms[&quot;selectedItem&quot;].submit()" class="fill blue continue-button">Fortfahren</button>
					</div>
				</div>
			</div>
		</section>
		<form action="booking-services.jsp" method="POST" name="selectedItem" class="hidden">
			<%
				// Create input fields for every request parameter
				Map<String, String[]> parameters = request.getParameterMap();
				for(String parameter : parameters.keySet()) {
			%>
			<input name="<%= parameter %>" value="<%= request.getParameter(parameter) %>"> 
			<%
				}
			 
				// Create an input field for passengers only if we dont have any passenger data
				if (request.getParameter("passengers") == null) {
			%>
			<input name="passengers"> 
			<%
			 	}
			 
				// Create an input field for flight_class only if we dont have any flight class data
				if (request.getParameter("flight_class") == null) {
			%>
			<input name="flight_class"> 
			<%
				}
			%>
			<input name="arrv_date">
			<input name="flight_number"> 
			 
			<!-- DO NOT USE THIS IN PRODUCTION!!! -->
			<!-- This is for demonstration purposes only! -->
			<input name="duration">
			<input name="stops">
			<input name="price">
		</form>
		<script type="text/javascript" src="js/flight-search.js"></script>
	</body>
</html>