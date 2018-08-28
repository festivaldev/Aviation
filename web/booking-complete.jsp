
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.SearchResultsDemo" %>
<%@ page import="org.json.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Map" %>
 
<%
	JSONObject requestData = new JSONObject();
	JSONObject demoData = new JSONObject();
 
	Boolean didCompleteBooking = false;
	try {
		Map<String, String[]> parameters = request.getParameterMap();
		for(String parameter : parameters.keySet()) {
			requestData.put(parameter, request.getParameter(parameter));
		}
 
		didCompleteBooking = SearchResultsDemo.completeBooking(requestData);
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Buchung abschließen – FESTIVAL Aviation</title>
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
						<li data-progress-made="true">
							 
							 <span>Dienste wählen</span>
							<div class="pipe"></div>
						</li>
					</ul>
					<p class="progress-section-title">Bezahlung</p>
					<ul>
						<li data-progress-made="true">
							 
							 <span>Rechnungsadresse</span>
							<div class="pipe"></div>
						</li>
						<li data-progress-made="true" class="current">
							 
							 <span>Buchung abschließen</span>
							<div class="pipe"></div>
						</li>
					</ul>
				</div>
				<div class="search-results-container column column-12 medium-8">
					<div class="scroll-container billing-address">
						<div class="result-header">
							 
							<%
								if (didCompleteBooking) {
							%>
							<h4 class="date"><span>Buchung abschließen</span></h4>
							<p>Deine Buchung ist jetzt getätigt! Da wäre nur noch eine Sache: das Finanzielle. Bitte zahle innerhalb der nächsten 24 Stunden über unseren Bezahldienst VirtuaMonetenPay, damit du dich ganz ohne Sorgen auf deinen Urlaub freuen kannst!</p><!-- HIER WIDGET EINFÜGEN -->
							 
							<%
								} else {
							%>
							<h4 class="date"><span>Da hat etwas nicht geklappt.</span></h4>
							<p>Bei der Buchung ist leider etwas schief gelaufen. Das Problem liegt entweder auf unserer Seite ('tschuldigung) oder auf deiner Seite. Probiere es doch in wenigen Minuten erneut. Auf keinen Fall solltest du die Seite konstant neu laden, das kann unsere Katze nicht so gut ab.</p> 
							<%
								}
							%>
						</div>
					</div>
					<div class="fill-background"></div>
					<div class="results-footer">
						<button onclick="location.href = &quot;index.jsp&quot;" class="outline blue">Zur Startseite</button>
						<button onclick="location.href = &quot;dashboard.jsp&quot;" class="fill blue continue-button">Zum Dashboard</button>
					</div>
				</div>
			</div>
		</section>
	</body>
</html>