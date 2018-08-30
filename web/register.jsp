
<!--
	register.jsp
	FESTIVAL Aviation
	
	This page deals with the registration of users
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
	Boolean passwordNotEqual = false;
	Boolean userAlreadyExists = false;
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
 
	// Check if we got POST paramers
	if (request.getParameter("firstName") != null &&
		request.getParameter("lastName") != null &&
		request.getParameter("email") != null &&
		request.getParameter("password") != null &&
		request.getParameter("passwordConfirm") != null) {
 
		// Check if the POST parameters are not empty
		if (!request.getParameter("firstName").isEmpty() &&
			!request.getParameter("lastName").isEmpty() &&
			!request.getParameter("email").isEmpty() &&
			!request.getParameter("password").isEmpty() &&
			!request.getParameter("passwordConfirm").isEmpty()) {
 
			// Check if the same password has been entered twice
			if (request.getParameter("password").equals(request.getParameter("passwordConfirm"))) {
				String firstName = request.getParameter("firstName");
				String lastName = request.getParameter("lastName");
				String email = request.getParameter("email");
 
				// Hash the password, so we don't store it in plain text on the server
				String hashedPassword = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(request.getParameter("password").getBytes(StandardCharsets.UTF_8))));
 
				// Store the error code returned by AuthManager
				AuthManager.ErrorCode errorCode = authManager.register(firstName, lastName, email, hashedPassword);
				
				switch (errorCode) {
					case OK:
						// User registration was successful, generate a session and redirect to dashboard.jsp
						if (authManager.generateSession(email) == AuthManager.ErrorCode.OK) {
							session.setAttribute("sid", authManager.getCurrentSessionId(email));
							response.sendRedirect("dashboard.jsp");
						}
						break;
					case USER_ALREADY_EXISTS:
						// User specified an E-Mail address that is already in use
						userAlreadyExists = true;
						break;
					case SERVER_ERROR:
						// Something happened on the server, clearly not our fault
						serverError = true;
						break;
					default:
						break;
				}
			} else {
				// User password validation failed
				passwordNotEqual = true;
			}
		} else {
			// Not every required field was filled
			invalidForm = true;
		}
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Registrieren – FESTIVAL Aviation</title>
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
				if (invalidForm || passwordNotEqual || userAlreadyExists || serverError) {
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
							} else if (passwordNotEqual) {
								// User password validation failed
						%>
						<p>Die von dir eigegebenen Passwörter stimmen nicht überein. Bitte versuche es erneut.</p> 
						<%
							} else if (userAlreadyExists) {
								// The E-Mail address specified is already in use
						%>
						<p>Die von dir angegebene E-Mail Adresse wird bereits wird bereits genutzt.</p> 
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
							<form method="POST" action="register.jsp" novalidate class="signin-form">
								<div class="form-textbox-wrapper">
									<input type="text" name="firstName" id="firstName" placeholder=" " required class="form-textbox"><span class="form-textbox-placeholder">Vorname</span>
								</div>
								<div class="form-textbox-wrapper">
									<input type="text" name="lastName" id="lastName" placeholder=" " required class="form-textbox"><span class="form-textbox-placeholder">Nachname</span>
								</div>
								<div class="form-textbox-wrapper">
									<input type="email" name="email" id="email" placeholder=" " required class="form-textbox"><span class="form-textbox-placeholder">E-Mail-Adresse</span>
								</div>
								<div class="form-textbox-wrapper">
									<input type="password" name="password" id="password" placeholder=" " required class="form-textbox"><span class="form-textbox-placeholder">Passwort</span>
								</div>
								<div class="form-textbox-wrapper">
									<input type="password" name="passwordConfirm" id="passwordConfirm" placeholder=" " required class="form-textbox"><span class="form-textbox-placeholder">Passwort bestätigen</span>
								</div>
								<button class="fill blue call">Registrieren</button>
							</form><a href="login.jsp">Schon registriert?</a>
						</div>
					</div>
				</div>
			</section>
		</div>
	</body>
</html>