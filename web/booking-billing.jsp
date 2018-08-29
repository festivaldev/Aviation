
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.SearchResultsDemo" %>
<%@ page import="ml.festival.aviation.AuthManager" %>
<%@ page import="org.json.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Map" %>
 
<%
	AuthManager authManager = new AuthManager();
	JSONObject requestData = new JSONObject();
	JSONObject demoData = new JSONObject();
 
	try {
		Map<String, String[]> parameters = request.getParameterMap();
		for(String parameter : parameters.keySet()) {
			requestData.put(parameter, request.getParameter(parameter));
		}
 
		demoData = SearchResultsDemo.getJSONData(requestData);
	} catch (Exception e) {
		e.printStackTrace();
	}
 
	ResultSet billingAddress = null;
	if (authManager.validate(String.valueOf(session.getAttribute("sid")))) {
		billingAddress = authManager.getBillingAddress(String.valueOf(session.getAttribute("sid")));
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Rechnungsadresse – FESTIVAL Aviation</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/booking.built.css">
		<link rel="stylesheet" href="css/modal.built.css">
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
		<section class="modal">
			<div class="modal-inner">
				<div class="content">
					<div id="modal-title-bar" class="title-bar"><span class="icon error"><span class="ai ai-error"></span></span><span class="icon info"><span class="ai ai-info"></span></span><span class="icon question"><span class="ai ai-question"></span></span><span class="icon success"><span class="ai ai-success"></span></span><span class="icon warning"><span class="ai ai-warning"></span></span>
						<p id="modal-title" class="title"></p>
					</div>
					<p id="modal-text"></p>
				</div>
				<div class="buttons">
					<button id="modal-primary"></button>
					<button id="modal-close">Schließen</button>
				</div>
			</div>
		</section>
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
						<li data-progress-made="true" class="current">
							 
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
					<div class="scroll-container billing-address">
						<div class="result-header">
							<h4 class="date"><span>Rechnungsadresse</span></h4>
							<p>Um die Buchung abzuschließen, benötigen wir eine gültige Rechnungsadresse. Solltest du gerade angemeldet sein, wird das Formular für dich automatisch ausgefüllt. Wenn nicht, kannst du hier deine Rechnungsadresse eintragen. Bitte stelle sicher, dass alle Daten korrekt eingetragen sind, da es sonst später zu Problemen bei der Rückerstattung kommen kann.</p>
						</div>
						<form name="billingAddress">
							<div class="row no-justify">
								<div class="column column-3">
									<label for="title">Anrede</label>
								</div>
								<div class="column column-6">
									<select name="title" id="title" required>
										<option value=""></option> 
										<%
											if (billingAddress != null) {
												if (billingAddress.getString("prefix").equals("male")) {
										%>
										<option value="male" selected>Herr</option>
										<option value="female">Frau</option> 
										<%
											 	} else if (billingAddress.getString("prefix").equals("female")) {
										%>
										<option value="male">Herr</option>
										<option value="female" selected>Frau</option> 
										<%
												}
											} else {
										%>
										<option value="male">Herr</option>
										<option value="female">Frau</option> 
										<%
											}
										%>
									</select>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="firstName">Vorname</label>
								</div>
								<div class="column column-6">
									<input type="text" name="firstName" id="firstName" value="<%= billingAddress != null ? billingAddress.getString("firstName") : "" %>" required>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="lastName">Nachname</label>
								</div>
								<div class="column column-6">
									<input type="text" name="lastName" id="lastName" value="<%= billingAddress != null ? billingAddress.getString("lastName") : "" %>" required>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="lastName">Straße</label>
								</div>
								<div class="column column-6">
									<input type="text" name="street" id="street" value="<%= billingAddress != null ? billingAddress.getString("street") : "" %>" required>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="lastName">PLZ/Ort</label>
								</div>
								<div class="column column-2">
									<input type="text" name="zip" id="zip" value="<%= billingAddress != null ? billingAddress.getString("postalCode") : "" %>" required>
								</div>
								<div class="column column-4">
									<input type="text" name="city" id="city" value="<%= billingAddress != null ? billingAddress.getString("postalCity") : "" %>" required>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="country">Land</label>
								</div>
								<div class="column column-6">
									<select name="country" id="country" required>
										 
										<%
											if (billingAddress != null) {
												if (billingAddress.getString("country").equals("de")) {
										%>
										<option value="de" selected>Deutschland</option>
										<option value="at">Österreich</option>
										<option value="ch">Schweiz</option> 
										<%
											 	} else if (billingAddress.getString("country").equals("at")) {
										%>
										<option value="de">Deutschland</option>
										<option value="at" selected>Österreich</option>
										<option value="ch">Schweiz</option><%
											 	} else if (billingAddress.getString("country").equals("ch")) {
										%>
										<option value="de">Deutschland</option>
										<option value="at">Österreich</option>
										<option value="ch" selected>Schweiz</option> 
										<%
												}
											} else {
										%>
										<option value="de">Deutschland</option>
										<option value="at">Österreich</option>
										<option value="ch">Schweiz</option> 
										<%
											}
										%>
									</select>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="email">E-Mail</label>
								</div>
								<div class="column column-6">
									<input type="email" name="email" id="email" value="<%= billingAddress != null ? billingAddress.getString("email") : "" %>" required>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="phone">Telefon</label>
								</div>
								<div class="column column-6">
									<input type="phone" name="phone" id="phone" value="<%= billingAddress != null ? billingAddress.getString("phoneNumber") : "" %>" required>
								</div>
							</div>
						</form>
					</div>
					<div class="fill-background"></div>
					<div class="results-footer">
						<button onclick="window.history.back()" class="outline blue">Zurück</button>
						<button class="fill blue continue-button">Buchung abschließen</button>
					</div>
				</div>
			</div>
		</section>
		<form action="booking-complete.jsp" method="POST" name="selectedItem" class="hidden">
			<%
				Map<String, String[]> parameters = request.getParameterMap();
				for(String parameter : parameters.keySet()) {
			%>
			<input name="<%= parameter %>" value="<%= request.getParameter(parameter) %>"> 
			<%
				}
			%>
			<input name="billingId">
		</form>
		<script src="js/icons.js"></script>
		<script src="js/modal.js"></script>
		<script type="text/javascript" src="js/flight-search.js"></script>
	</body>
</html> 
<% authManager.closeConnection(); %>