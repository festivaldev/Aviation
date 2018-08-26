
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
 
 
<%
	InitialContext initialContext;
	Context environmentContext;
	DataSource dataSource;
	Connection conn = null;
 
	ResultSet questions = null;
 
	try {
		initialContext = new InitialContext();
		environmentContext = (Context)initialContext.lookup("java:/comp/env");
		dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
		conn = dataSource.getConnection();
		Statement statement = conn.createStatement();
		questions = statement.executeQuery("SELECT * FROM questions ORDER BY questionText ASC");
	} catch (Exception e) {
		e.printStackTrace();
	}
%><!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>FAQ – FESTIVAL Aviation Support</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/support-center.built.css">
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
					<li><a href="#">Reiseziele</a></li>
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
		<div class="content-wrapper">
			<section class="support">
				<div class="section-content row reversed">
					<div class="column column-3">
									
						<%
						  if (questions != null) {
						%>
						<ul class="sc-menu contents">
							<li class="menu-item heading">FAQ <span class="expand-button"></span></li> 
							<%
								while (questions.next()) {
							%>
							 <a data-q-link="<%= questions.getString("linkId") %>" class="menu-item">
								<li><%= questions.getString("questionText") %></li></a> 
							<%
								}
								questions.beforeFirst();
							%>
						</ul> 
						<%
							}
						%>
						<ul class="sc-menu">
							<li class="menu-item heading">Support</li><a href="sc-index.jsp" class="menu-item selected">
								<li>FAQ</li></a><a href="sc-contact.jsp" class="menu-item">
								<li>Kontakt</li></a><a href="sc-cancellations.jsp" class="menu-item">
								<li>Stornierungen</li></a><a href="sc-complaints.jsp" class="menu-item">
								<li>Beschwerden</li></a><a href="sc-rights.html" class="menu-item">
								<li>Fluggastrechte</li></a>
						</ul>
					</div>
					<div class="column column-8 offset-1">
						<h2>FAQ</h2> 
						<%
							if (questions != null) {
								while (questions.next()) {
						%>
						<div data-q="<%= questions.getString("linkId") %>" class="faq-card">
							<p class="faq-card-header"><%= questions.getString("questionText") %><span class="expand-button"></span></p>
							<div class="faq-card-content"><%= questions.getString("answerText") %></div>
						</div> 
						<%
								}
							} else {
						%>
						<article class="flag error">
							<div class="header">
								<div class="icon"><span><span class="ai ai-error"></span></span></div><span class="title">Hier funktioniert etwas nicht...</span>
							</div>
							<div class="content">
								<p>Es scheint als hätten wir Probleme im Hintergrund, sodass aktuell keine Fragen geladen werden können. Bitte versuch es später noch einmal.</p>
							</div>
						</article> 
						<%
							}
						%>
						<article class="flag question">
							<div class="header">
								<div class="icon"><span><span class="ai ai-question"></span></span></div><span class="title">Die richtige Antwort war nicht dabei?</span>
							</div>
							<div class="content">
								<p>Stell uns deine Frage direkt: <a href="sc-contact.html">Kontakt</a></p>
							</div>
						</article>
					</div>
				</div>
			</section>
		</div>
		<footer>
			<div class="footer-content">
				<div class="footer-directory">
					<div class="footer-directory-column">
						<h3 class="footer-directory-column-title">Aviation</h3>
						<ul class="footer-directory-column-list">
							<li><a href="booking-search.jsp">Flüge</a></li>
							<li><a href="#">Link</a></li>
							<li><a href="#">Link</a></li>
							<li><a href="#">Link</a></li>
							<li><a href="#">Link</a></li>
							<li><a href="sc-index.jsp">Support</a></li>
							<li><a href="dashboard.jsp">Benutzerkontrollzentrum</a></li>
							<li><a href="imprint.html">Impressum</a></li>
							<li><a href="privacy.html">Datenschutzerklärung</a></li>
						</ul>
					</div>
					<div class="footer-directory-column"></div>
					<div class="footer-directory-column"></div>
					<div class="footer-directory-column">
						<h3 class="footer-directory-column-title">Team FESTIVAL</h3>
						<ul class="footer-directory-column-list">
							<li><a href="#">Über uns</a></li>
						</ul>
					</div>
					<div class="footer-directory-column">
						<h3 class="footer-directory-column-title">Social</h3>
						<ul class="footer-directory-column-list">
							<li><a href="https://twitter.com/festivaldev" target="_blank">Twitter</a></li>
							<li><a href="https://github.com/festivaldev" target="_blank">GitHub</a></li>
						</ul>
					</div>
				</div>
				<section class="footer">
					<p class="legal">Copyright &copy; 2018 Team FESTIVAL. Alle Rechte vorbehalten.</p>
					<p class="custom-footer">Made with <span class="weird-text"></span> by Team FESTIVAL.</p>
					<script src="js/custom-footer.js"></script>
				</section>
			</div>
		</footer>
	</body>
	<script src="js/support-center.js"></script>
	<script src="js/modal.js"></script>
	<script src="js/icons.js"></script>
</html> 
<%
	if (conn != null)
	    conn.close();
%>