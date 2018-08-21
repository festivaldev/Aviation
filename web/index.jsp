
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="ml.festival.aviation.*" %>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>FESTIVAL Aviation</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/landing.built.css">
		<script src="lib/spring-animatable.js"></script>
		<script src="lib/scroll-retractor.js"></script>
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
					</div><a href="#" class="link-home"></a><a href="user-cp.jsp" class="link-user-cp"></a>
				</div>
				<ul class="nav-list">
					<li><a href="#" class="link-home"></a></li>
					<li><a href="search.html">Flüge</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="#">Link</a></li>
					<li><a href="sc-index.html">Support</a></li>
					<li><a href="dashboard.jsp" class="link-user-cp"></a></li>
				</ul>
			</div>
		</nav>
		<section class="landing-hero">
			<div class="hero-content"><img src="img/logo-light.svg" class="hero-logo">
				<h2 class="hero-title">Die günstigsten Flugreisen aller Zeiten</h2>
				<h4 class="hero-subtitle">Einfach nur das buchen, was du wirklich brauchst – das ist aviation.</h4>
				<div class="hero-search-bar">
					<form method="post" action="search.html">
						<div data-key="departure" class="input-wrapper">
							<div class="column-title"><img src="img/icon-departure.svg">
								<p>Von (Ort oder Flughafen)</p>
							</div>
							<input type="text" id="depart" placeholder="Abreiseort eingeben">
							<input type="text" id="depart_iata" name="depart_iata" class="hidden">
							<ul class="suggestions"></ul>
						</div>
						<div data-key="arrival" class="input-wrapper">
							<div class="column-title"><img src="img/icon-arrival.svg">
								<p>Nach (Ort oder Flughafen)</p>
							</div>
							<input type="text" placeholder="Ankunftsort eingeben">
							<input type="text" id="arrv_iata" name="arrv_iata" class="hidden">
							<ul class="suggestions"></ul>
						</div>
						<div class="input-wrapper">
							<div class="column-title"><img src="img/icon-date.svg" class="icon">
								<p>Abflugdatum</p>
							</div>
							<input type="date" placeholder="Abflugdatum auswählen">
						</div>
						<button class="search-button">Suchen</button>
					</form>
				</div>
			</div>
		</section>
		<section class="promo-articles">
			<div class="section-content"> 
				<%
					PromoManager promoManager = new PromoManager();
					ResultSet categories = promoManager.getPromoCategories();
					int index = 0;
					String[] locations = new String[3];
					while (categories.next()) {
						index++;
						ResultSet location = promoManager.getLocationForCategory(categories.getString("id"));
						
						while (location.next()) {
							locations[index - 1] = location.getString("id");
				%>
				 
				<div data-spring-animatable="promo_<%= index %>" class="promo-article">
					<div style="background-image: url(<%= location.getString("headerImage") %>)" class="header dark">
						<p class="header-heading">Unsere Empfehlung</p>
						<p class="header-title"><%= categories.getString("title") %></p>
						<p class="header-subtitle"><%= location.getString("location") %></p>
					</div>
				</div> 
				<%
						}
						location.beforeFirst();
					}
					categories.beforeFirst();
					index = 0;
				%>
			</div>
		</section>
		<section class="promo-text">
			<div class="section-content row">
				<div class="column column-12 medium-6">
					<h4 class="eyebrow">Das FESTIVAL Prinzip</h4>
					<h2 class="headline">Flugreisen – so wie du sie brauchst</h2>
					<p class="body">Flugreisen sind meist sehr teuer. Das liegt vor allem daran, dass oft Dienste im Preis enthalten sind, die vielleicht gar nicht benötigt werden. Dein Flug geht nur von Hamburg nach Berlin und du hast bereits gut gefrühstückt? Warum solltest du extra für Essen bezahlen, wenn du es doch sowieso nicht essen wirst?<br><br>Genau das will aviation ändern. Du buchst einfach nur deinen Platz im Flugzeug, und das drückt den Preis. Und wenn du einen zusätzlichen Dienst benötigst, buchst du ihn einfach dazu. Besser kann es gar nicht sein.</p>
				</div>
				<div class="column column-12 medium-5 medium-offset-1">
					<p class="body">Test</p>
				</div>
			</div>
		</section>
		<section class="promo-text">
			<div class="section-content row">
				<div class="column column-12 medium-5 medium-offset-1">
					<p class="body">Test</p>
				</div>
				<div class="column column-12 medium-6">
					<h4 class="eyebrow">Gestalte deine Flugreise</h4>
					<h2 class="headline">Ein Platz – viele Möglichkeiten</h2>
					<p class="body">Wenn du eine Flugreise über aviation buchst, bekommst du grundsätzlich die Erlaubnis, das Flugzeug betreten zu dürfen. Im Grundpreis enthalten ist eine Beteiligung an den Flugkosten, wie etwa Treibstoff oder Parkgebühren. Das ist in etwa vergleichbar mit Car Sharing, wo sich die Passagiere auch an den Fahrtkosten beteiligen. Willst du zum Beispiel Gepäck mitnehmen, kostet dies nur eine geringe Gebühr statt einer festen Pauschale, die bereits im Ticketpreis enthalten ist. So können wir Flugreisen um bis zu 50% günstiger anbieten als die etablierte Konkurrenz.</p>
				</div>
			</div>
		</section>
		<section class="promo-text">
			<div class="section-content row">
				<div class="column column-12 medium-6">
					<h4 class="eyebrow">Immer für dich da</h4>
					<h2 class="headline">Nicht zufrieden? Dann sag's uns!</h2>
					<p class="body">Sollte mal etwas nicht zu deiner Zufriedenheit sein, dann freuen wir uns, von dir zu hören! Nimm einfach Kontakt mit uns auf und wir helfen dir, dein Problem zu lösen. Außerdem arbeiten wir mit immer mehr Fluggesellschaften zusammen, um noch günstigere Reisen anbieten zu können. Damit kannst du dich bald auf eine noch größere Auswahl der bisher günstigsten Flüge freuen!</p>
				</div>
				<div class="column column-12 medium-5 medium-offset-1">
					<p class="body">Test</p>
				</div>
			</div>
		</section>
		<footer>
			<div class="footer-content">
				<div class="footer-directory">
					<div class="footer-directory-column">
						<h3 class="footer-directory-column-title">Aviation</h3>
						<ul class="footer-directory-column-list">
							<li><a href="search.html">Flüge</a></li>
							<li><a href="#">Link</a></li>
							<li><a href="#">Link</a></li>
							<li><a href="#">Link</a></li>
							<li><a href="#">Link</a></li>
							<li><a href="sc-index.html">Support</a></li>
							<li><a href="dashboard.jsp">Benutzerkontrollzentrum</a></li>
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
		<%
			while (categories.next()) {
				index++;
		 
				ResultSet location = promoManager.getLocationForId(locations[index - 1]);
		 
				while(location.next()) {
		%>
		 
		<div data-spring-animatable-target="promo_<%= index %>" class="promo-article-details">
			<div style="background-image: url(<%= location.getString("headerImage") %>)" class="header dark">
				<div class="close-button"></div>
				<p class="header-heading">Unsere Empfehlung</p>
				<p class="header-title"><%= categories.getString("title") %></p>
				<p class="header-subtitle"><%= location.getString("location") %></p>
			</div>
			<div class="content-scroll-wrapper">
				<div class="content">
					 
					<%= location.getString("content") %>
					 
					<p>Sehen Sie sich auch unsere weiteren Empfehlungen in der Kategorie "<%= categories.getString("title") %>" an.</p>
				</div>
			</div>
		</div> 
		<%
				}
			}
			promoManager.closeConnection();
		%>
		 
		<div class="spring-background"></div>
		<script type="text/javascript" src="js/landing.js"></script>
	</body>
</html>