
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
 
<% 
    InitialContext initialContext;
    Context environmentContext;
    DataSource dataSource;
    Connection conn = null;
 
    ResultSet payment = null;
 
    String invoice = "";
    String flightId = "";
    String fromIATA = "";
    String toIATA = "";
    String flightClass = "";
    String extras = "";
    float price = 0F;
 
    String holder = "";
    String number = "";
    String expiration = "";
    String cvv = "";
 
    boolean invalidInvoice = false;
    boolean alreadyPaid = false;
    boolean invalidData = false;
    boolean paymentError = false;
    boolean paymentOk = false;
    boolean error = false;
 
    try {
        initialContext = new InitialContext();
        environmentContext = (Context)initialContext.lookup("java:/comp/env");
        dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
        conn = dataSource.getConnection();
 
        request.setCharacterEncoding("UTF-8");
 
        try {
            invoice = request.getParameter("invoice");
		} catch (Exception e) {
            e.printStackTrace();
		}
 
		if (invoice == null || invoice.isEmpty()) {
            // Keine RechungsId angegeben
			invalidInvoice = true;
		}
 
		PreparedStatement statement = conn.prepareStatement("SELECT * FROM bookings WHERE id = ?");
        statement.setString(1, invoice);
 
		ResultSet invoiceData = statement.executeQuery();
 
		if (invoiceData.next()) {
		    if (invoiceData.getBoolean("paid")) {
		        // Schon bezahlt
				alreadyPaid = true;
			} else {
 
		        flightId = invoiceData.getString("flightId");
		        fromIATA = invoiceData.getString("fromIATA");
		        toIATA = invoiceData.getString("toIATA");
		        flightClass = invoiceData.getString("class");
		        extras = invoiceData.getString("extras");
		        price = invoiceData.getFloat("price");
 
				if (request.getMethod().equals("POST")) {
				    // Bezahlung durchführen
 
					holder = request.getParameter("holder");
					number = request.getParameter("number");
					expiration = request.getParameter("expiration");
					cvv = request.getParameter("cvv");
 
					if (holder == null || holder.isEmpty() || number == null || number.isEmpty() || expiration == null || expiration.isEmpty() || cvv == null || cvv.isEmpty()) {
					    // Nicht alles ausgefüllt
						invalidData = true;
					} else {
					    if (number.equals("4000 0027 6000 0016")) {
					        // Fail
							paymentError = true;
						} else {
					        // Ok
 
					        statement = conn.prepareStatement("UPDATE bookings SET paid = TRUE WHERE id = ?");
					        statement.setString(1, invoice);
 
					        statement.execute();
 
					        paymentOk = true;
						}
					}
				}
 
			}
		} else {
		    // Rechnung existiert nicht
			invalidInvoice = true;
		}
    } catch (Exception e) {
        // MySQL Error
		error = true;
        e.printStackTrace();
    }
%><!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Checkout – FESTIVAL Aviation Support</title>
		<link rel="stylesheet" href="css/aviation.css">
		<link rel="stylesheet" href="css/modal.built.css">
		<link rel="stylesheet" href="css/flag.built.css">
		<link rel="stylesheet" href="css/checkout.built.css">
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
			<section class="checkout">
				<div class="section-content">
					 
					<%
						if (invalidInvoice) {
					%>
					<article class="flag error">
						<div class="header">
							<div class="icon"><span><span class="ai ai-error"></span></span></div><span class="title">Rechnung existiert nicht</span>
						</div>
						<div class="content">
							<p>Die angegebene Rechnung konnte nicht gefunden werden.</p>
						</div>
					</article> 
					<%
						} else if (alreadyPaid) {
					%>
					<article class="flag error">
						<div class="header">
							<div class="icon"><span><span class="ai ai-error"></span></span></div><span class="title">Rechnung bereits bezahlt</span>
						</div>
						<div class="content">
							<p>Die angegebene Rechnung wurde bereits bezahlt.</p>
						</div>
					</article> 
					<%
						} else if (invalidData) {
					%>
					<article class="flag error">
						<div class="header">
							<div class="icon"><span><span class="ai ai-error"></span></span></div><span class="title">Ungültige Eingabe</span>
						</div>
						<div class="content">
							<p>Du musst alle Felder, die nicht als optional gekennzeichnet sind, ausfüllen.</p>
						</div>
					</article> 
					<%
						} else if (error) {
					%>
					<article class="flag error">
						<div class="header">
							<div class="icon"><span><span class="ai ai-error"></span></span></div><span class="title">Hier funktioniert etwas nicht</span>
						</div>
						<div class="content">
							<p>Beim Bezahlen der Rechnung ist ein Fehler aufgetreten. Bitte versuch es später noch einmal.</p>
						</div>
					</article> 
					<%
						}
					 
						if (!invalidInvoice && !alreadyPaid) {
					%>
					<div class="container">
						<article class="invoice">
							<h2>Rechnung #<%= invoice %></h2>
							<table>
								<tr>
									<td>Flugticket für <%= flightId %><br><%= fromIATA %> &rarr; <%= toIATA %><br><%= flightClass.toUpperCase().replace("_", " ") %></td>
									<td><%= String.format("%.2f", price) %>€</td>
								</tr> 
								<%
									for (int i = 0; i < extras.split(",").length; i++) {
									    PreparedStatement stm = conn.prepareStatement("SELECT * FROM services WHERE serviceId = ?");
									    stm.setString(1, extras.split(",")[i]);
								 
									    ResultSet extra = stm.executeQuery();
								 
									    if (extra.next()) {
									        price += extra.getFloat("price");
								%>
								<tr>
									<td><%= extra.getString("title") %></td>
									<td><%= String.format("%.2f", extra.getFloat("price")) %>€</td>
								</tr> 
								<%
										}
									}
								%>
							</table>
							<h3>Total: <%= String.format("%.2f", price) %>€</h3>
						</article>
						<article class="card-input">
							<form method="POST" action="checkout.jsp" novalidate>
								<div class="card <% if (paymentError) { %>error<% } else if (paymentOk) { %>success<% } %>"><img src="img/visa-logo-black-and-white.png">
									<div class="chip"></div>
									<div id="card-number" class="number"><span>••••</span><span>••••</span><span>••••</span><span>••••</span></div><span id="card-holder" class="holder"></span><span id="card-expiration" class="expiration"></span>
								</div> 
								<%
									if (!paymentError && !paymentOk) {
								%>
								<input type="hidden" id="invoice" name="invoice" value="<%= invoice %>">
								<div class="input-wrapper">
									<input type="text" data-corresponds="holder" id="holder" name="holder" placeholder=" " value="<%= holder %>"><span>Karteninhaber</span>
								</div>
								<div class="input-wrapper">
									<input type="text" data-corresponds="number" id="number" name="number" maxlength="19" placeholder=" " value="<%= number %>"><span>Kartennummer</span>
								</div>
								<div class="input-wrapper">
									<input type="text" data-corresponds="expiration" id="expiration" name="expiration" maxlength="5" placeholder=" " value="<%= expiration %>"><span>Gültig bis</span>
								</div>
								<div class="input-wrapper">
									<input type="password" maxlength="3" id="cvv" name="cvv" placeholder=" "><span>CVV</span>
								</div> 
								<%
									}
								%>
								<div class="button-wrapper">
									 
									<%
										if (paymentError) {
									%>
									<button disabled class="error"><span class="ai ai-error"></span><span>Zahlung fehlgeschlagen</span></button> 
									<%
										} else if (paymentOk) {
									%>
									<button disabled class="success"><span class="ai ai-success"></span><span>Zahlung erfolgreich</span></button> 
									<%
										} else {
									%>
									<button data-modal-type="warning" data-modal-title="Kauf bestätigen" data-modal-text="Bitte bestätige, dass du den Kauf wirklich tätigen willst." data-modal-primary="Kostenpflichtig kaufen" data-modal-primary-action="submit" data-modal-primary-action-timeout="3000" data-modal-secondary="Kauf abbrechen" class="modal-trigger"><%= String.format("%.2f", price) %>€ Bezahlen</button> 
									<%
										}
									%>
									<div class="sk-folding-cube">
										<div class="sk-cube1 sk-cube"></div>
										<div class="sk-cube2 sk-cube"></div>
										<div class="sk-cube4 sk-cube"></div>
										<div class="sk-cube3 sk-cube"></div>
									</div>
								</div> 
								<%
									if (paymentError) {
								%><a href="checkout.jsp?invoice=<%= invoice %>">Zahlung wiederholen</a> 
								<%
									} else if (paymentOk) {
								%><a href="dashboard.jsp">Zurück zum Dashboard</a> 
								<%
									}
								%>
								<p>Powered by <span>VirtuaMonetenPay</span></p>
							</form>
						</article>
					</div> 
					<%
						}
					%>
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
	<script src="js/checkout.js"></script>
	<script src="js/modal.js"></script>
	<script src="js/icons.js"></script>
</html> 
<%
	if (conn != null)
	    conn.close();
%>