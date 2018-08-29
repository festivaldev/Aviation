
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.AuthManager" %>
<%@ page import="java.util.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.security.MessageDigest" %>
<%
	Boolean invalidForm = false;
	Boolean userNotFound = false;
	Boolean incorrectPassword = false;
	AuthManager authManager = new AuthManager();
 
	if (authManager.validate(String.valueOf(session.getAttribute("sid")))) {
	    response.sendRedirect("dashboard.jsp");
	    return;
	}
 
	if (request.getParameter("email") != null &&
		request.getParameter("password") != null) {
		if (!request.getParameter("email").isEmpty() &&
			!request.getParameter("password").isEmpty()) {
			String email = request.getParameter("email");
			String hashedPassword = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(request.getParameter("password").getBytes(StandardCharsets.UTF_8))));
 
			if (authManager.login(email, hashedPassword) == AuthManager.ErrorCode.OK) {
				if (authManager.generateSession(email) == AuthManager.ErrorCode.OK) {
					session.setAttribute("sid", authManager.getCurrentSessionId(email)); 
 
					response.sendRedirect("dashboard.jsp");
				}
			} else {
				incorrectPassword = true;
			}
		} else {
			invalidForm = true;
		}
	}
 
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
			<% if (invalidForm || incorrectPassword || userNotFound) { %>
			<section class="form-error">
				<div class="section-content row centered">
					<div class="column column-12 medium-4">
						 
						<% if (invalidForm) { %>
						<p>Bitte fülle das komplette Formular aus, um dich zu anzumelden.</p> 
						<% } else if (incorrectPassword) { %>
						<p>Das von dir angegebene Passwort ist nicht korrekt. Bitte versuche es erneut.</p> 
						<% } else if (userNotFound) { %>
						<p>Das von dir angegebene Konto wurde nicht gefunden.</p> 
						<% } %>
						 
					</div>
				</div>
			</section> 
			<% } %>
			 
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