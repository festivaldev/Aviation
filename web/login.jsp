
<!--
	login.jsp
	FESTIVAL Aviation
	
	This page deals with the login of users
	We use a single-page concept here to keep
	the page count at a minimum
	(Early development used a multi-page concept)
	
	@author Janik Schmidt (jani.schmidt@ostfalia.de)
	@version 1.0
-->
 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.AuthManager" %>
<%@ page import="java.util.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.security.MessageDigest" %>
<%
	// Create some variables that we need later to display error messages
	Boolean invalidForm = false;
	Boolean userNotFound = false;
	Boolean incorrectPassword = false;
	Boolean serverError = false;
 
	// Our authentication manager manages authentication
	AuthManager authManager = new AuthManager();
 
	// Since we're dealing with text in a database, we need to set the character encoding to UTF-8
	request.setCharacterEncoding("UTF-8");
 
	// If we're already logged in, redirect to dashboard.jsp
	if (authManager.validate(String.valueOf(session.getAttribute("sid")))) {
	    response.sendRedirect("dashboard.jsp");
	    return;
	}
 
	// If this page is part of a POST request, we can verify the login details
	if (request.getParameter("email") != null &&
		request.getParameter("password") != null) {
		if (!request.getParameter("email").isEmpty() &&
			!request.getParameter("password").isEmpty()) {
			String email = request.getParameter("email");
			String hashedPassword = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(request.getParameter("password").getBytes(StandardCharsets.UTF_8))));
 
			// Store the error code returned by AuthManager
			AuthManager.ErrorCode errorCode = authManager.login(email, hashedPassword);
 
			// Now check the error code
			switch (errorCode) {
				case OK:
					// User credentials are correct, generate a session and redirect to dashboard.jsp
					if (authManager.generateSession(email) == AuthManager.ErrorCode.OK) {
						session.setAttribute("sid", authManager.getCurrentSessionId(email));
 
						response.sendRedirect("dashboard.jsp");
					}
					break;
				case USER_NOT_FOUND:
					// The E-Mail address specified isn't registered with Aviation
					userNotFound = true;
					break;
				case PASSWORD_INCORRECT:
					// User submitted an incorrect password
					incorrectPassword = true;
					break;
				case SERVER_ERROR:
					// Something happened on the server, clearly not our fault
					serverError = true;
					break;
				default:
					break;
			}
		} else {
			// Not every required field was filled
			invalidForm = true;
		}
	}
 
	// Close the database connection because we need to
	authManager.closeConnection();
 
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Anmelden – FESTIVAL Aviation</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/login.built.css">
	</head>
	<body>
		<div class="content-wrapper">
			<section class="logo-container">
				<div class="section-content row centered">
					<div class="column column-12 medium-4"><img src="img/logo-dark.svg"></div>
				</div>
			</section> 
			<%
				// This is only displayed if we have an error condition
				if (invalidForm || incorrectPassword || userNotFound || serverError) {
			%>
			<section class="form-error">
				<div class="section-content row centered">
					<div class="column column-12 medium-4">
						 
						<%
							if (invalidForm) {
							 	// Not every required field was filled
						%>
						<p>Bitte fülle das komplette Formular aus, um dich zu anzumelden.</p> 
						<%
							} else if (incorrectPassword) {
								// User submitted an incorrect password
						%>
						<p>Das von dir angegebene Passwort ist nicht korrekt. Bitte versuche es erneut.</p> 
						<%
							} else if (userNotFound) {
								// The E-Mail address specified isn't registered with Aviation
						%>
						<p>Das von dir angegebene Konto wurde nicht gefunden.</p> 
						<% 
							} else if (serverError) {
								// The server returned an error code we can't handle
						%>
						<p>Da hat etwas nicht geklappt. Bitte versuche es erneut.</p> 
						<%
							}
						%>
						 
					</div>
				</div>
			</section> 
			<%
				}
			%>
			 
			<section class="login">
				<div class="section-content row centered">
					<div class="column column-12 medium-4">
						<div class="login-container">
							<form method="POST" action="login.jsp" novalidate class="signin-form">
								<div class="form-textbox-wrapper">
									<input type="email" name="email" id="email" placeholder=" " class="form-textbox"><span class="form-textbox-placeholder">E-Mail-Adresse</span>
								</div>
								<div class="form-textbox-wrapper">
									<input type="password" name="password" id="password" placeholder=" " class="form-textbox"><span class="form-textbox-placeholder">Passwort</span>
								</div>
								<button class="fill blue call">Anmelden</button>
							</form><a href="register.jsp">Noch nicht registriert?</a>
						</div>
					</div>
				</div>
			</section>
		</div>
	</body>
</html>