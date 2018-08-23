
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.SearchResultsDemo" %>
<%@ page import="org.json.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.Time" %>
 
<%
	JSONObject demoData = new JSONObject();
 
	if (request.getParameter("depart_iata") != null && request.getParameter("arrv_iata") != null && request.getParameter("depart_date") != null) {
		demoData = SearchResultsDemo.getDemoData(request.getParameter("depart_iata"), request.getParameter("arrv_iata"), LocalDate.parse(request.getParameter("depart_date"), DateTimeFormatter.ISO_DATE_TIME));
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Suchen – FESTIVAL Aviation</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/search.built.css">
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
					</div><a href="#" class="link-home"></a><a href="user-cp.jsp" class="link-user-cp"></a>
				</div>
				<ul class="nav-list">
					<li><a href="/" class="link-home"></a></li>
					<li><a href="search.jsp">Flüge</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="sc-index.html">Support</a></li>
					<li><a href="dashboard.jsp" class="link-user-cp"></a></li>
				</ul>
			</div>
		</nav>
		<section class="search-results">
			<div class="section-content">
				<div class="search-results-container">
					<div class="search-results-header">
						<div class="row">
							<div class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-departure.svg">
									<p>Von</p>
								</div>
								<input value="<%= demoData.get("departureName") != null ? demoData.get("departureName") : "" %>" placeholder="Abreiseort eingeben" required class="column-content">
							</div>
							<div class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-arrival.svg">
									<p>Nach</p>
								</div>
								<input value="<%= demoData.get("arrivalName") != null ? demoData.get("arrivalName") : "" %>" placeholder="Ankunftsort eingeben" required class="column-content">
							</div>
						</div>
						<div class="row">
							<div class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-date.svg">
									<p>Abflugdatum</p>
								</div>
								<input type="date" value="<%= demoData.get("departureDate") != null ? ((LocalDate)demoData.get("departureDate")).format(DateTimeFormatter.ofPattern("EEEE, dd. MMMM yyyy")) : "" %>" placeholder="Abflugdatum auswählen" required class="column-content">
							</div>
							<div class="column column-12 medium-2">
								<div class="column-title"><img src="img/icon-passenger.svg">
									<p>Passagiere</p>
								</div>
								<input type="number" value="1" min="1" max="10" class="column-content">
							</div>
							<div class="column column-12 medium-4">
								<div class="column-title"><img src="img/icon-class.svg">
									<p>Klassen</p>
								</div>
								<p class="column-content">Alle Klassen</p>
							</div>
						</div>
					</div> 
					<%
						if (demoData.get("items") != null) {
						 	for (int i=0; i<((JSONArray)demoData.get("items")).length(); i++) {
								JSONObject resultObj = ((JSONArray)demoData.get("items")).getJSONObject(i);
					%>
					<div class="scroll-container"> 
						<div class="result-header">
							<h4 class="date"><span>Abflug</span> – <%= ((LocalDate)resultObj.get("departureDate")).format(DateTimeFormatter.ofPattern("dd MMM")) %></h4>
							<div class="table-header row">
								<div class="column column-2">
									<p><%= demoData.get("departureMunicipality") %></p>
								</div>
								<div class="column column-2 align-right">
									<p><%= demoData.get("arrivalMunicipality") %></p>
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
								<div class="column column-1 align-right">
									<p>Preis</p>
								</div>
							</div>
						</div> 
						<%
								for (int j=0; j<((JSONArray)resultObj.get("items")).length(); j++) {
									JSONObject flightObj = ((JSONArray)resultObj.get("items")).getJSONObject(j);
						%>
						<div class="results">
							<div class="result-cell row">
								<div class="column column-2">
									<p><%= ((Time)flightObj.get("departureTime")).toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm")) %></p>
								</div>
								<div class="column column-2 align-right">
									<p><%= ((Time)flightObj.get("arrivalTime")).toLocalTime().format(DateTimeFormatter.ofPattern("HH:mm")) %></p>
								</div>
								<div class="column column-2 column-offset-1">
									<p>13h 10min</p>
								</div>
								<div class="column column-1">
									<p><%= flightObj.get("stops") %></p>
								</div>
								<div class="column column-auto">
									<p><%= flightObj.get("flightNumber") %></p>
								</div>
								<div class="column column-1 align-right">
									<p>ab <%= flightObj.get("price") %>€</p>
								</div>
							</div>
						</div> 
						<%	} %>
					</div> 
					<%
							}
						} 
					%>
					<div class="fill-background"></div>
					<div class="results-footer"></div>
				</div>
			</div>
		</section>
	</body>
</html>