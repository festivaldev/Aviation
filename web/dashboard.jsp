
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.AuthManager" %>
<%!
	private String defaultPage = "profile";
	public Boolean isCurrentPage(String requestedPage, String pageName) {
		if (requestedPage != null) {
			return pageName.equals(requestedPage);
		} else {
			return pageName.equals(defaultPage);
		}
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
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Benutzer – FESTIVAL Aviation</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/user-cp.built.css">
	</head>
	<body>
		<nav class="global-nav">
			<div class="nav-content">
				<div class="nav-svg-header">
					<div class="nav-svg-wrapper">
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
					<li><a href="#" class="link-home"></a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="dashboard.jsp" class="link-user-cp"></a></li>
				</ul>
			</div>
		</nav>
		<div class="content-wrapper">
			<section class="user-cp">
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
							<li class="heading">Buchungen</li>
							<li>Vorherige Buchungen</li>
							<li>Tickets</li>
						</ul>
					</div>
					<div class="column column-8 offset-1">
						 
						<% if (isCurrentPage(request.getParameter("p"), "profile")) { %>
						<p>Profil</p> 
						<% } %>
						 
						<% if (isCurrentPage(request.getParameter("p"), "billing")) { %>
						<p>Rechnungsadresse</p> 
						<% } %>
						 
						<% if (isCurrentPage(request.getParameter("p"), "complaints")) { %>
						<p>Beschwerden</p> 
						<% } %>
					</div>
				</div>
			</section>
		</div>
	</body>
</html>