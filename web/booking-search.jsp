
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.SearchResultsDemo" %>
<%@ page import="org.json.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.Time" %>
 
<%
	JSONObject demoData = new JSONObject();
 
	if (request.getParameter("depart_iata") != null && request.getParameter("arrv_iata") != null && request.getParameter("depart_date") != null) {
		ZonedDateTime zonedDateTime = Instant.parse(request.getParameter("depart_date")).atZone(ZoneId.of("Europe/Berlin"));
		demoData = SearchResultsDemo.getDemoData(request.getParameter("depart_iata"), request.getParameter("arrv_iata"), zonedDateTime.toLocalDate());
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Flugsuche – FESTIVAL Aviation</title>
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
					<li><a href="/" class="link-home"></a></li>
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
				<div class="progress-overview column medium-3">
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
				</div>
				<div class="search-results-container column column-12 medium-8">
					<div class="search-results-header">
						<div class="row">
							<div data-key="departure" class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-departure.svg">
									<p>Von</p>
								</div>
								<input value="<%= demoData.has("departureName") ? demoData.get("departureName") : "" %>" placeholder="Abreiseort eingeben" required class="column-content">
							</div>
							<div data-key="arrival" class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-arrival.svg">
									<p>Nach</p>
								</div>
								<input value="<%= demoData.has("arrivalName") ? demoData.get("arrivalName") : "" %>" placeholder="Ankunftsort eingeben" required class="column-content">
							</div>
						</div>
						<div class="row">
							<div data-key="date" class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-date.svg">
									<p>Abflugdatum</p>
								</div>
								<input type="date" value="<%= demoData.has("departureDate") ? ((LocalDate)demoData.get("departureDate")).format(DateTimeFormatter.ofPattern("EEEE, dd. MMMM yyyy")) : "" %>" placeholder="Abflugdatum auswählen" required class="column-content">
							</div>
							<div class="column column-12 medium-2">
								<div class="column-title"><img src="img/icon-passenger.svg">
									<p>Passagiere</p>
								</div>
								<input type="number" name="passengers" value="1" min="1" max="10" oninput="passengerCountChanged(this)" class="column-content">
							</div>
							<div class="column column-12 medium-4">
								<div class="column-title"><img src="img/icon-class.svg">
									<p>Klasse</p>
								</div>
								<p class="column-content">
									<select name="flight_class" onchange="classChanged(this)">
										<option value="economy">Economy</option>
										<option value="premium_economy">Premium Economy</option>
										<option value="business">Business</option>
										<option value="first">First Class</option>
									</select>
								</p>
							</div>
						</div>
					</div>
					<div class="scroll-container">
						 
						<%
							if (demoData.has("items")) {
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
									for (int j=0; j<((JSONArray)resultObj.get("items")).length(); j++) {
										JSONObject flightObj = ((JSONArray)resultObj.get("items")).getJSONObject(j);
										
										LocalTime departureTime = ((Time)flightObj.get("departureTime")).toLocalTime().withSecond(0);
										LocalTime arrivalTime = ((Time)flightObj.get("arrivalTime")).toLocalTime().withSecond(0);
							 
										Duration duration = Duration.between(departureTime, arrivalTime);
										if (duration.isNegative()) {
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
						<button class="outline red">Abbrechen</button>
						<button disabled onclick="document.forms[0].submit()" class="fill blue continue-button">Fortfahren</button>
					</div>
				</div>
			</div>
		</section>
		<form action="booking-services.jsp" method="POST" name="selectedItem" class="hidden">
			<input name="depart_iata" value="<%= demoData.get("departureIATA") %>">
			<input name="arrv_iata" , value="<%= demoData.get("arrivalIATA") %>">
			<input name="depart_date">
			<input name="arrv_date">
			<input name="flight_number">
			<input name="passengers">
			<input name="flight_class"> 
			 
			<!-- DO NOT USE THIS IN PRODUCTION!!! -->
			<!-- This is for demonstration purposes only! -->
			<input name="duration">
			<input name="stops">
			<input name="price">
		</form>
		<script type="text/javascript" src="js/flight-search.js"></script>
	</body>
</html>