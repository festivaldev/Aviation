
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.AuthManager" %>
<%!
	public Boolean isCurrentPage(String requestedPage, String pageName) {
		if (requestedPage != null) {
			return pageName.equals(requestedPage);
		}
		return false;
	}
%>
<%
	Boolean validAuth = false;
	AuthManager authManager = new AuthManager();
 
	Cookie[] cookies = request.getCookies();
	for (int i=0; i<cookies.length; i++) {
		if (cookies[i].getName().equals("sid")) {
			if (authManager.validate(cookies[i].getValue())) {
				validAuth = true;
				break;
			}
		}
	}
 
	if (!validAuth) {
		response.sendRedirect("login.jsp");
	} else if (request.getParameter("p") == null || request.getParameter("p").isEmpty()) {
		response.sendRedirect("dashboard.jsp?p=profile");
	}
 
	authManager.closeConnection();
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Dashboard – FESTIVAL Aviation</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/dashboard.built.css">
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
					<li><a href="search.jsp">Flüge</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="sc-index.jsp">Support</a></li>
					<li><a href="dashboard.jsp" class="link-user-cp"></a></li>
				</ul>
			</div>
		</nav>
		<div class="content-wrapper">
			<section class="dashboard">
				<div class="section-content row">
					<div class="column column-3">
						<ul class="user-cp-menu">
							<li class="menu-item heading">Allgemein</li> 
							 <a href="?p=profile" class="menu-item <%= isCurrentPage(request.getParameter("p"), "profile") ? "selected" : "" %>">
								<li>Profil</li></a> 
							 <a href="?p=billing" class="menu-item <%= isCurrentPage(request.getParameter("p"), "billing") ? "selected" : "" %>">
								<li>Rechnungsadresse</li></a> 
							 <a href="?p=complaints" class="menu-item <%= isCurrentPage(request.getParameter("p"), "complaints") ? "selected" : "" %>">
								<li>Beschwerden</li></a>
						</ul>
						<ul class="user-cp-menu">
							<li class="menu-item heading">Buchungen</li> 
							 <a href="?p=bookings" class="menu-item <%= isCurrentPage(request.getParameter("p"), "bookings") ? "selected" : "" %>">
								<li>Alle Buchungen</li></a> 
							 <a href="?p=tickets" class="menu-item <%= isCurrentPage(request.getParameter("p"), "tickets") ? "selected" : "" %>">
								<li>Tickets</li></a>
						</ul>
					</div> 
					<% if (isCurrentPage(request.getParameter("p"), "profile")) { %>
					<div class="column column-8 offset-1">
						<h2>Profil</h2>
						<p>Hier kannst du die Details deines Profils anpassen.</p>
						<form action="#">
							<label for="firstName">Vorname</label>
							<input type="text" name="firstName" id="firstName">
							<label for="lastName">Nachname</label>
							<input type="text" name="lastName" id="lastName">
							<label for="email">E-Mail-Adresse</label>
							<input type="email" name="email" id="email">
							<button class="fill blue">Profil speichern</button>
						</form>
						<h3>Passwort ändern</h3>
						<form action="#">
							<label for="oldPassword">Altes Passwort</label>
							<input type="password" name="oldPassword" id="oldPassword">
							<label for="oldPassword">Neues Passwort</label>
							<input type="password" name="newPassword" id="newPassword">
							<label for="oldPassword">Neues Passwort bestätigen</label>
							<input type="password" name="newPasswordConfirm" id="newPasswordConfirm">
							<button class="fill blue">Passwort ändern </button>
						</form>
					</div> 
					<% } %>
					 
					<% if (isCurrentPage(request.getParameter("p"), "billing")) { %>
					<div class="column column-8 offset-1">
						<h2>Rechnungsadresse</h2>
						<p>Zum Buchen von Flügen benötigst du eine gültige Rechnungsadresse. Diese kannst du hier jederzeit ändern.</p>
						<form action="#">
							<div class="row no-justify">
								<div class="column column-3">
									<label for="title">Anrede</label>
								</div>
								<div class="column column-6">
									<select name="title" id="title">
										<option value="none" selected></option>
										<option value="male">Herr</option>
										<option value="female">Frau</option>
									</select>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="firstName">Vorname</label>
								</div>
								<div class="column column-6">
									<input type="text" name="firstName" id="firstName">
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="lastName">Nachname</label>
								</div>
								<div class="column column-6">
									<input type="text" name="lastName" id="lastName">
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="lastName">Straße</label>
								</div>
								<div class="column column-6">
									<input type="text" name="street" id="street">
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="lastName">PLZ/Ort</label>
								</div>
								<div class="column column-2">
									<input type="text" name="zip" id="zip">
								</div>
								<div class="column column-4">
									<input type="text" name="city" id="city">
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="country">Land</label>
								</div>
								<div class="column column-6">
									<select name="country" id="country">
										<option value="de">Deutschland</option>
										<option value="at">Österreich</option>
										<option value="ch">Schweiz</option>
									</select>
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="email">E-Mail</label>
								</div>
								<div class="column column-6">
									<input type="email" name="email" id="email">
								</div>
							</div>
							<div class="row no-justify">
								<div class="column column-3">
									<label for="phone">Telefon</label>
								</div>
								<div class="column column-6">
									<input type="phone" name="phone" id="phone">
								</div>
							</div>
						</form>
					</div> 
					<% } %>
				</div>
			</section>
		</div>
	</body>
</html>