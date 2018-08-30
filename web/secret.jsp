
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Base64" %>
 
<%
	try {
		if (request.getParameter("key") != null && !request.getParameter("key").isEmpty()) {
			String decodedKey = new String(Base64.getMimeDecoder().decode(request.getParameter("key")));
 
			InitialContext initialContext = new InitialContext();
			Context environmentContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
			Connection conn = dataSource.getConnection();
 
			PreparedStatement statement = conn.prepareStatement("SELECT * FROM airports WHERE home_link = ?");
			statement.setString(1, decodedKey);
 
			ResultSet ostf = statement.executeQuery();
			if (!ostf.next()) {
				throw new Exception();
			}
		} else {
			throw new Exception();
		}
	} catch (Exception e) {
		response.sendRedirect("index.jsp");
	}
%>
 <!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Tesst</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/components/tables.css">
		<style>
			img.shizznit {
				display: block;
				height: 300px;
				margin: 20px auto;
			}
			
			table.flex td {
				display: flex;
			}
			
			table.flex td label {
				line-height: 12px;
				flex: 1;
				margin-left: 5px;
			}
			
			input[type="range"] {
				width: 100%;
			}
		</style>
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
		<% if (request.getParameter("type") == null || !request.getParameter("type").equals("results")) { %>
		<section class="promo-text">
			<div class="section-content">
				<h2 class="headline">Tesst dess Allahgemeinwissens D-A-CH vong Ingtehlignäns her</h2>
				<div class="row centered">
					<div class="column column-12 medium-6 align-center">
						<p class="body">Dieser Tesd tested das getestete Algem1wiseng der testendeng Tester. Die Bewertung erfolgd ing Punkteng unt wirt nit gespeiert. Das Ergebnis had k1erlei 1flus auf die Benudsung vong FESTIVAL Aviation unt spiegeld NICHT die politischeng Ansiteng der Redaktiong wieder.</p>
					</div>
				</div>
			</div>
		</section>
		<section class="promo-text">
			<div class="section-content">
				<h4 class="eyebrow">1: Ein Beispiel für Hunde und Katzen</h4><img src="https://www.nutricanis.de/media/blog/250x250_hund-katze_500.jpg" class="shizznit shizznit">
				<p class="body"><strong>Aufgabe 1)</strong> Ordnen Sie die nachfolgenden Namen den Charakteren im Bild zu.</p>
				<div class="row centered">
					<table class="column column-12 medium-6">
						<tr>
							<td>Name</td>
							<td>Kadse</td>
							<td>Hound</td>
						</tr>
						<tr>
							<td>Fabian</td>
							<td>
								<input type="checkbox">
							</td>
							<td>
								<input type="checkbox">
							</td>
						</tr>
						<tr>
							<td>Janik</td>
							<td>
								<input type="checkbox">
							</td>
							<td>
								<input type="checkbox">
							</td>
						</tr>
						<tr>
							<td>Nicht Jonas</td>
							<td>
								<input type="checkbox">
							</td>
							<td>
								<input type="checkbox">
							</td>
						</tr>
						<tr>
							<td>Frikandel Otte</td>
							<td>
								<input type="checkbox">
							</td>
							<td>
								<input type="checkbox">
							</td>
						</tr>
						<tr>
							<td>Per Windaler aus Lampukistan</td>
							<td>
								<input type="checkbox">
							</td>
							<td>
								<input type="checkbox">
							</td>
						</tr>
						<tr>
							<td>Hidolf Atler</td>
							<td>
								<input type="checkbox">
							</td>
							<td>
								<input type="checkbox">
							</td>
						</tr>
					</table>
				</div>
			</div>
		</section>
		<section class="promo-text">
			<div style="position: relative;" class="section-content">
				<h4 class="eyebrow">2: Die Schönheit der Glühlampe</h4><img src="https://www.mega-kunde.de/media/catalog/product/cache/2/image/553x/9df78eab33525d08d6e5fb8d27136e95/4/0/40014__ncc_700x700.jpg" class="shizznit">
				<p class="body"><strong>Aufgabe 2)</strong> Schätzen Sie die Nennleistung der abgebildeten Glühlampe in WAT.</p><img src="http://i0.kym-cdn.com/photos/images/newsfeed/000/173/576/Wat8.jpg?1315930535" class="shizznit">
				<div style="position: absolute; left: 50%; bottom: 230px; transform: translate3d(-50%, 0, 0)" class="movable-container">
					<select style="font-size: 40px">
						<option>0</option>
						<option>1</option>
						<option>2</option>
						<option>3</option>
						<option>4</option>
						<option>5</option>
						<option>6</option>
						<option>7</option>
						<option>8</option>
						<option>9</option>
					</select>
					<select style="font-size: 40px">
						<option>0</option>
						<option>1</option>
						<option>2</option>
						<option>3</option>
						<option>4</option>
						<option>5</option>
						<option>6</option>
						<option>7</option>
						<option>8</option>
						<option>9</option>
					</select>
					<select style="font-size: 40px">
						<option>0</option>
						<option>1</option>
						<option>2</option>
						<option>3</option>
						<option>4</option>
						<option>5</option>
						<option>6</option>
						<option>7</option>
						<option>8</option>
						<option>9</option>
					</select>
				</div>
			</div>
		</section>
		<section class="promo-text">
			<div class="section-content">
				<h4 class="eyebrow">3: Eishockey-Abend in der Savanne</h4><img src="http://www.lol.de/sport/das-tut-weh-die-17-lustigsten-sportpannen-177/das-gilt-wohl-auch-fuer-eishockey-o02nx2kyrk-20.jpg" class="shizznit">
				<p class="body"><strong>Aufgabe 3)</strong> [Kreuzen Sie an] Wie viele Zähne werden durschschnittlich pro Tag beim Eishockey in Deutschland verloren?</p>
				<div class="row centered">
					<table class="column column-12 medium-6 flex">
						<tr>
							<td>
								<input type="radio" name="A3" id="A3_0">
								<label for="A3_0">3</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A3" id="A3_1">
								<label for="A3_1">Drölf</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A3" id="A3_2">
								<label for="A3_2">Zwünf</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A3" id="A3_3">
								<label for="A3_3">42</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A3" id="A3_4">
								<label for="A3_4">π</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A3" id="A3_5">
								<label for="A3_5">©</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A3" id="A3_6">
								<label for="A3_6">Weißbrot</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A3" id="A3_7">
								<label for="A3_7">Ralph</label>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</section>
		<section class="promo-text">
			<div class="section-content">
				<h4 class="eyebrow">4: Vorsicht, zerbrechlich!</h4><img src="https://ae01.alicdn.com/kf/HTB1pNdZir5YBuNjSspoq6zeNFXan/Antique-Vintage-Home-Decoration-Ceramic-Vase-Hexagon-Blue-and-White-Porcelain-Flower-Chinese-Ming-Vase.jpg_640x640.jpg" class="shizznit huehuehue">
				<p class="body"><strong>Aufgabe 4)</strong> Bestimmen Sie den HSL-Farbwert der in diesem Bild abgebildeten Ming-Vase, die wir zufällig auf AliExpress gefundeb haben.</p>
				<div class="row centered">
					<div class="column column-12 medium-4">
						<input type="range" name="h" value="0" min="0" max="360" oninput="huehuehue()">
						<input type="range" name="s" value="1" min="0" max="100" oninput="huehuehue()">
						<input type="range" name="b" value="100" min="0" max="500" oninput="huehuehue()">
						<script type="text/javascript">
							const huehuehue = () => {
								const h = document.querySelector("input[type=\"range\"][name=\"h\"]").value;
								const s = document.querySelector("input[type=\"range\"][name=\"s\"]").value;
								const b = document.querySelector("input[type=\"range\"][name=\"b\"]").value;
								
								const filter = 'filter: hue-rotate('+h+'deg) saturate('+s+') brightness('+b+'%)';
								document.querySelector("img.huehuehue").setAttribute("style", filter);
							}
							
						</script>
					</div>
				</div>
			</div>
		</section>
		<section class="promo-text">
			<div class="section-content">
				<h4 class="eyebrow">5: Politirilik in Schlandtton</h4><img src="https://www.ndr.de/fernsehen/sendungen/extra_3/extra8188_v-original.jpg" class="shizznit">
				<p class="body"><strong>Aufgabe 5)</strong> Erörtern Sie die Relationen zwischen den GUS-Staaten bzw. deren Ministerpräsidenten und deutscher soziologischer Demographien der letzten 605 Jahre in über 2000 Wörtern.</p>
				<div class="row centered">
					<table class="column column-12 medium-6 flex">
						<tr>
							<td>
								<input type="radio" name="A5" id="A5_0">
								<label for="A5_0">Ja</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A5" id="A5_1">
								<label for="A5_1">Nein</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A5" id="A5_2">
								<label for="A5_2">Vielleicht</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A5" id="A5_3">
								<label for="A5_3">Definitiv Nein</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" name="A5" id="A5_4">
								<label for="A5_4">Weiß nicht/keine Angabe</label>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</section>
		<section class="row centered">
			<div class="column column-12 medium-6 align-center"><a href="secret.jsp?key=<%= request.getParameter("key") %>&type=results">
					<button class="call fill blue">Zur Auswertung</button></a></div>
		</section> 
		<% } else { %>
		<div class="content-wrapper">
			<section class="promo-text">
				<div class="section-content">
					<h2 class="headline align-center">Auswertung:tton</h2>
					<div class="row centered">
						<div class="column column-12 medium-6 align-center">
							<p class="body">Sie haben Drölf Pungte von 42 Möhklichen erreicht.</p>
							<p class="body"><span style="font-size: 12px">There are no Easter Eggs up here.</span></p>
						</div>
					</div>
				</div>
			</section>
			<section class="row centered">
				<div class="column column-12 medium-6 align-center"><a href="index.jsp">
						<button class="call fill blue">Zurück zur Startseite</button></a></div>
			</section>
		</div> 
		<% } %>
		<footer>
			<div class="footer-content">
				<div class="footer-directory">
					<div class="footer-directory-column">
						<h3 class="footer-directory-column-title">Aviation</h3>
						<ul class="footer-directory-column-list">
							<li><a href="booking-search.jsp">Flüge</a></li>
							<li><a href="featured.jsp">Reiseziele</a></li>
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
							<li><a href="about.html">Über uns</a></li>
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