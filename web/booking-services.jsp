
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.SearchResultsDemo" %>
<%@ page import="org.json.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.Time" %>
 
<%
	JSONObject requestData = new JSONObject();
	JSONObject demoData = new JSONObject();
 
	try {
		requestData.put("depart_iata", request.getParameter("depart_iata"));
		requestData.put("arrv_iata", request.getParameter("arrv_iata"));
		requestData.put("depart_date", request.getParameter("depart_date"));
		requestData.put("arrv_date", request.getParameter("arrv_date"));
		requestData.put("flight_number", request.getParameter("flight_number"));
		requestData.put("passengers", request.getParameter("passengers"));
		requestData.put("flight_class", request.getParameter("flight_class"));
 
		requestData.put("duration", request.getParameter("duration"));
		requestData.put("stops", request.getParameter("stops"));
		requestData.put("price", request.getParameter("price"));
 
		demoData = SearchResultsDemo.getServiceData(requestData);
	} catch (Exception e) {
 
	}
	out.println(requestData);
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Dienste – FESTIVAL Aviation</title>
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
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
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
						<li data-progress-made="true">
							 
							 <span>Flug wählen</span>
							<div class="pipe"></div>
						</li>
						<li data-progress-made="true" class="current">
							 
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
							 
							 <span>Bestellung abschließen</span>
						</li>
					</ul>
				</div>
				<div class="search-results-container column column-12 medium-8">
					<div class="search-results-header">
						<div class="row">
							<div class="column column-12 medium-6">
								<div class="column-title"><img src="img/icon-departure.svg">
									<p>Von</p>
								</div>
								<p class="column-content"><%= demoData.getString("departureName") %></p>
							</div>
							<div class="column column-12 medium-6">
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
								<p class="column-content"><%= requestData.getString("passengers") %></p>
							</div>
							<div class="column column-12 medium-4">
								<div class="column-title"><img src="img/icon-class.svg">
									<p>Klasse</p>
								</div>
								<p class="column-content"><%= requestData.getString("flight_class") %></p>
							</div>
						</div>
						<div class="row selected-flight">
							<div class="column column-2">
								<div class="column-title">
									<p><%= demoData.getString("departureName") %></p>
								</div>
								<p class="column-content"><%= LocalDateTime.parse(requestData.getString("depart_date"), DateTimeFormatter.ISO_DATE_TIME).format(DateTimeFormatter.ofPattern("HH:mm")) %></p>
							</div>
							<div class="column column-2 align-right">
								<div class="column-title"> 
									<p><%= demoData.getString("arrivalName") %></p>
								</div>
								<p class="column-content"><%= LocalDateTime.parse(requestData.getString("arrv_date"), DateTimeFormatter.ISO_DATE_TIME).format(DateTimeFormatter.ofPattern("HH:mm")) %></p>
							</div>
							<div class="column column-2 column-offset-1">
								<div class="column-title">
									<p>Dauer</p>
								</div> 
								<%
									Duration duration = Duration.ofMillis(requestData.getInt("duration"));
								%>
								<p class="column-content"><%= String.format("%02dh %02dmin", duration.getSeconds() / 3600, (duration.getSeconds() % 3600) / 60) %></p>
							</div>
							<div class="column column-1">
								<div class="column-title">
									<p>Stopps</p>
								</div>
								<p class="column-content"><%= requestData.getString("stops") %></p>
							</div>
							<div class="column column-auto">
								<div class="column-title">
									<p>Flugnummer</p>
								</div>
								<p class="column-content"><%= requestData.getString("flight_number") %></p>
							</div>
							<div class="column column-2 align-right">
								<div class="column-title">
									<p>Preis</p>
								</div>
								<p class="column-content">ab <%= requestData.getString("price") %>€</p>
							</div>
						</div>
					</div>
					<div class="scroll-container">
						<div class="result-header">
							<h4 class="date"><span>Dienste</span></h4>
							<p>Im Ticketpreis bereits enthalten ist eine Beteiligung an den Betriebskosten des jeweiligen Fluges. Um Tickets so günstig anbieten zu können, werden zusätzliche Dienste, wie etwa die Mitnahme von Gepäck, extra angeboten. So zahlst du wirklich nur für das, was du brauchst. Solltest du unerwartet einen Dienst in Anspruch nehmen müssen, mach dir keine Sorgen. Gebühren können auch nach der Reise bezahlt werden.</p>
						</div>
					</div>
				</div>
			</div>
		</section>
	</body>
</html>