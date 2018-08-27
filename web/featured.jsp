
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.*" %>
<%@ page import="java.sql.ResultSet" %>
 
<%
	ResultSet location = null;
	ResultSet category = null;
	PromoManager promoManager = new PromoManager();
 
	if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
		location = promoManager.getLocationForId(request.getParameter("id"));
 
		if (location != null && location.next()) {
			category = promoManager.getCategoryForId(location.getString("categoryId"));
 
			location.beforeFirst();
		}
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no"> 
		<% if (location != null) { %>
		<title><%= location.next() ? location.getString("location").split(",")[0] : "Fehler" %> – FESTIVAL Aviation</title> 
		<% } else { %>
		<title>Unsere Empfehlungen – FESTIVAL Aviation</title> 
		<% } %>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/featured.built.css">
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
					<li><a href="featured.jsp">Reiseziele</a></li>
					<li><a href="sc-contact.jsp">Kontakt</a></li>
					<li><a href="sc-index.jsp">Support</a></li>
					<li><a href="dashboard.jsp" class="link-user-cp"></a></li>
				</ul>
			</div>
		</nav> 
		<%
			if (location != null) {
				location.beforeFirst();
				if (location.next() && category.next()) {
		%>
		<section class="featured-item">
			<div style="background-image: url(<%= location.getString("headerImage") %>)" class="item-header"></div>
			<div class="section-content">
				<h4 class="eyebrow"><%= category.getString("title") %></h4>
				<h2 class="headline"><%= location.getString("location") %></h2> 
				<%= location.getString("content") %>
			</div>
		</section> 
		<%
				} else if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
		%>
		<section class="featured-item">
			<div class="section-content">
				<div class="item-header"></div>
				<h2 class="headline">Hier funktioniert etwas nicht...</h2>
				<p class="error">Der Server kann die angebenenen Parameter nicht interpretieren. Bitte überprüfe, ob du einem gültigen Link gefolgt bist und versuche es erneut.</p>
			</div>
		</section> 
		<%
				}
			} else {
		%>
		<section>
			<div class="section-content">
				<h2 class="headline">Unsere Empfehlungen</h2>
				<p class="body">Brauchst du eine Inspiration, wo du deinen nächsten Urlaub verbringen willst? Jede Woche stellen wir neue Reiseziele in den Kategorien "Sonne &amp; Strand", "Stadt &amp; Leben" und "Topen &amp; Abenteuer" vor, inklusive besondere Highlights und was man dort unternehmen kann. Sieh dir einfach unsere Empfehlungen an und entscheide dich, was du in deinem nächsten Urlaub machen möchtest.</p>
			</div>
		</section> 
		<%
				ResultSet categories = promoManager.getPromoCategories();
				while (categories.next()) {
		%>
		<section class="no-padding">
			<div class="section-content">
				<h4 class="eyebrow"><%= categories.getString("title") %></h4>
			</div>
		</section>
		<section class="promo-articles">
			<div class="section-content">
				 
				<%
					ResultSet locations = promoManager.getLocationsForCategory(categories.getString("id"));
					while (locations.next()) {
				%>
				 
				 <a href="featured.jsp?id=<%= locations.getString("id") %>">
					<div class="promo-article">
						<div style="background-image: url(<%= locations.getString("headerImage") %>)" class="header dark">
							<p class="header-heading"><%= categories.getString("title") %></p>
							<p class="header-title"><%= locations.getString("location") %></p>
						</div>
					</div></a> 
				<%
					}
				%>
			</div>
		</section> 
		<%
				}
			}
		%>
		<footer>
			<div class="footer-content">
				<div class="footer-directory">
					<div class="footer-directory-column">
						<h3 class="footer-directory-column-title">Aviation</h3>
						<ul class="footer-directory-column-list">
							<li><a href="booking-search.jsp">Flüge</a></li>
							<li><a href="featured.jsp">Reiseziele</a></li>
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
</html> 
<%
	promoManager.closeConnection();
%>