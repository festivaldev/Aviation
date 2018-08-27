
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.AuthManager" %>
<%@ page import="java.util.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.security.MessageDigest" %>
<%
	Boolean invalidForm = false;
	Boolean passwordNotEqual = false;
	Boolean serverError = false;
	AuthManager authManager = new AuthManager();
 
	Cookie[] cookies = request.getCookies();
	for (int i=0; i<cookies.length; i++) {
		if (cookies[i].getName().equals("sid")) {
			if (authManager.validate(cookies[i].getValue())) {
				response.sendRedirect("dashboard.jsp");
				return;
			}
		}
	}
 
	if (request.getParameter("firstName") != null &&
		request.getParameter("lastName") != null &&
		request.getParameter("email") != null &&
		request.getParameter("password") != null &&
		request.getParameter("passwordConfirm") != null) {
 
		if (!request.getParameter("firstName").isEmpty() &&
			!request.getParameter("lastName").isEmpty() &&
			!request.getParameter("email").isEmpty() &&
			!request.getParameter("password").isEmpty() &&
			!request.getParameter("passwordConfirm").isEmpty()) {
 
			if (request.getParameter("password").equals(request.getParameter("passwordConfirm"))) {
				String firstName = request.getParameter("firstName");
				String lastName = request.getParameter("lastName");
				String email = request.getParameter("email");
				String hashedPassword = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(request.getParameter("password").getBytes(StandardCharsets.UTF_8))));
 
				if (authManager.register(firstName, lastName, email, hashedPassword) == AuthManager.ErrorCode.OK) {
					if (authManager.generateSession(email) == AuthManager.ErrorCode.OK) {
						Cookie sessionCookie = new Cookie("sid", authManager.getCurrentSessionId(email));
						sessionCookie.setMaxAge(7200);
						response.addCookie(sessionCookie);
 
						response.sendRedirect("dashboard.jsp");
					}
				} else {
					serverError = true;
				}
			} else {
				passwordNotEqual = true;
			}
		} else {
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
			<% if (invalidForm || passwordNotEqual || serverError) { %>
			<section class="form-error">
				<div class="section-content row centered">
					<div class="column column-12 medium-4">
						 
						<% if (invalidForm) { %>
						<p>Bitte fülle das komplette Formular aus, um dich zu registrieren.</p> 
						<% } else if (passwordNotEqual) { %>
						<p>Die von dir eigegebenen Passwörter stimmen nicht überein. Bitte versuche es erneut.</p> 
						<% } else if (serverError) { %>
						<p>Da hat etwas nicht geklappt. Bitte versuche es erneut.</p> 
						<% } %>
						 
					</div>
				</div>
			</section> 
			<% } %>
			 
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