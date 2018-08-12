
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.security.MessageDigest" %>
<%!
	public String bytesToHex(byte[] bytes) {
		StringBuffer result = new StringBuffer();
		for (byte byt : bytes) result.append(Integer.toString((byt & 0xff) + 0x100, 16).substring(1));
		return result.toString();
	}
%>
<%
	Context initialContext = new InitialContext();
	Context environmentContext = (Context)initialContext.lookup("java:/comp/env");
	DataSource dataSource = (DataSource)environmentContext.lookup("jdbc/iae_test");
	Connection conn = dataSource.getConnection();
	
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	if (email != null && !email.isEmpty() &&
		password != null && !password.isEmpty()) {
		String hashedPassword = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(password.getBytes(StandardCharsets.UTF_8))));
		
		PreparedStatement statement = conn.prepareStatement("SELECT id, password FROM `accounts` WHERE email = ?");
		statement.setString(1, email);
		
		ResultSet users = statement.executeQuery();
		
		if (users.next() && users.getString("password").equals(hashedPassword)) {
			PreparedStatement sessionStatement = conn.prepareStatement("DELETE FROM `sessions` where `userId`= ?");
			sessionStatement.setString(1, users.getString("id"));
			sessionStatement.execute();
			
			sessionStatement = conn.prepareStatement("INSERT INTO `sessions` VALUES (?, ?, default, default)");
			sessionStatement.setString(1, bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%s%s%s%d", users.getString("id"), email, hashedPassword, System.currentTimeMillis() / 1000L).getBytes(StandardCharsets.UTF_8))).substring(0, 32));
			sessionStatement.setString(2, users.getString("id"));
			sessionStatement.execute();
			
			conn.close();
			response.sendRedirect("user-cp.html");
		} else {
			out.println("username or password incorrect");
		}
	} else {
		out.println("form invalid");
	}
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
								<button class="call">Anmelden</button>
							</form><a href="register.jsp">Noch nicht registriert?</a>
						</div>
					</div>
				</div>
			</section>
		</div>
	</body>
</html>