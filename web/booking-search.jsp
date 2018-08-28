
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Flugsuche – FESTIVAL Aviation</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/booking.built.css">
		<link rel="stylesheet" href="css/components/calendar.css">
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
					<li><a href="index.jsp" class="link-home"></a></li>
					<li><a href="booking-search.jsp">Flüge</a></li>
					<li><a href="featured.jsp">Reiseziele</a></li>
					<li><a href="sc-contact.jsp">Kontakt</a></li>
					<li><a href="sc-index.jsp">Support</a></li>
					<li><a href="dashboard.jsp" class="link-user-cp"></a></li>
				</ul>
			</div>
		</nav>
		<section class="search-results">
			<div class="section-content row">
				<div class="progress-overview column medium-3">
					<p class="progress-title">Flug buchen</p>
					<p class="progress-section-title">Vorbereitung</p>
					<ul>
						<li data-progress-made="true" class="current">
							 
							 <span>Reiseziel wählen</span>
							<div class="pipe"></div>
						</li>
						<li data-progress-made="false">
							 
							 <span>Flug wählen</span>
							<div class="pipe"></div>
						</li>
						<li data-progress-made="false">
							 
							 <span>Dienste wählen</span>
							<div class="pipe"></div>
						</li>
					</ul>
					<p class="progress-section-title">Bezahlung</p>
					<ul>
						<li data-progress-made="false">
							 
							 <span>Rechnungsadresse</span>
							<div class="pipe"></div>
						</li>
						<li data-progress-made="false">
							 
							 <span>Buchung abschließen</span>
							<div class="pipe"></div>
						</li>
					</ul>
				</div>
				<div class="search-results-container column column-12 medium-8">
					<div class="search-results-header">
						<form method="post" action="booking-results.jsp">
							<div class="row">
								<div data-key="departure" class="column column-12 medium-6">
									<div class="column-title"><img src="img/icon-departure.svg">
										<p>Von</p>
									</div>
									<input placeholder="Abreiseort eingeben" required class="column-content">
									<input type="text" id="depart_iata" name="depart_iata" required class="hidden">
									<div class="suggestions">
										<div class="suggestions-header">
											<div class="header-eyebrow">Startflughafen</div>
											<div class="header-title">Ergebnisse</div>
										</div>
										<ul class="suggestions-list"></ul>
									</div>
								</div>
								<div data-key="arrival" class="column column-12 medium-6">
									<div class="column-title"><img src="img/icon-arrival.svg">
										<p>Nach</p>
									</div>
									<input placeholder="Ankunftsort eingeben" required class="column-content">
									<input type="text" id="arrv_iata" name="arrv_iata" required class="hidden">
									<div class="suggestions">
										<div class="suggestions-header">
											<div class="header-eyebrow">Zielflughafen</div>
											<div class="header-title">Ergebnisse</div>
										</div>
										<ul class="suggestions-list"></ul>
									</div>
								</div>
							</div>
							<div class="row">
								<div data-key="date" class="column column-12 medium-6">
									<div class="column-title"><img src="img/icon-date.svg">
										<p>Abflugdatum</p>
									</div>
									<input type="text" placeholder="Abflugdatum auswählen" required class="column-content">
									<input type="text" id="depart_date" name="depart_date" required class="hidden">
									<div class="calendar"></div>
								</div>
								<div class="column column-12 medium-2">
									<div class="column-title"><img src="img/icon-passenger.svg">
										<p>Passagiere</p>
									</div>
									<input type="number" name="passengers" value="1" min="1" max="10" oninput="passengerCountChanged(this)" class="column-content">
								</div>
								<div class="column column-12 medium-4">
									<div class="column-title"><img src="img/icon-class.svg">
										<p>Klasse</p>
									</div>
									<p class="column-content">
										<select name="flight_class" onchange="classChanged(this)">
											<option value="economy">Economy</option>
											<option value="premium_economy">Premium Economy</option>
											<option value="business">Business</option>
											<option value="first">First Class</option>
										</select>
									</p>
								</div>
							</div>
						</form>
					</div>
					<div class="fill-background">
						<p class="placeholder-text">Klicke auf "Suchen", um mit der Suche zu beginnen.</p>
					</div>
					<div class="results-footer">
						<button onclick="if (confirm(&quot;Möchtest du wirklich abbrechen?&quot;)) history.back()" class="outline red">Abbrechen</button>
						<button onclick="document.forms[&quot;selectedItem&quot;].submit()" class="fill blue continue-button">Suchen</button>
					</div>
				</div>
			</div>
		</section>
		<script type="text/javascript" src="lib/calendar.js"></script>
		<script type="text/javascript" src="js/flight-search.js"></script>
	</body>
</html>