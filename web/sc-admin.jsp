
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="ml.festival.aviation.AuthManager" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
 
<%
    AuthManager authManager = new AuthManager();
 
    if (!authManager.validate(String.valueOf(session.getAttribute("sid")))) {
        response.sendRedirect("login.jsp");
    } else {
        ResultSet profile = authManager.getProfileDetails(String.valueOf(session.getAttribute("sid")));
 
        if (!profile.next() || !profile.getBoolean("isAdmin")) {
            response.sendRedirect("login.jsp");
            return;
        }
    }
 
    authManager.closeConnection();
 
    InitialContext initialContext;
    Context environmentContext;
    DataSource dataSource;
    Connection conn = null;
 
    ResultSet questions = null;
 
    boolean success = false;
    boolean dataError = false;
    boolean error = false;
 
    try {
        initialContext = new InitialContext();
        environmentContext = (Context)initialContext.lookup("java:/comp/env");
        dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
        conn = dataSource.getConnection();
 
        request.setCharacterEncoding("UTF-8");
 
        if ("POST".equals(request.getMethod())) {
            String method = request.getParameter("method");
            String id = request.getParameter("id");
 
            if ("update".equals(method)) {
                PreparedStatement p = conn.prepareStatement("UPDATE questions SET questionText = ?, answerText = ? WHERE linkId = ?");
 
                p.setString(1, request.getParameter("question"));
                p.setString(2, request.getParameter("answer"));
                p.setString(3, id);
 
                p.execute();
            } else if ("delete".equals(method)) {
                PreparedStatement p = conn.prepareStatement("DELETE FROM questions WHERE linkId = ?");
 
                p.setString(1, id);
 
                p.execute();
            } else if ("insert".equals(method)) {
                PreparedStatement p = conn.prepareStatement("INSERT INTO questions VALUES (?, ?, ?)");
 
                p.setString(1, id);
                p.setString(2, request.getParameter("question"));
                p.setString(3, request.getParameter("answer"));
 
                p.execute();
            }
 
            success = true;
        }
 
    } catch (Exception e) {
        dataError = true;
        e.printStackTrace();
    }
 
    try {
        Statement statement = conn.createStatement();
        questions = statement.executeQuery("SELECT * FROM questions ORDER BY questionText ASC");
    } catch (Exception e) {
        error = true;
        e.printStackTrace();
    }
%><!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
		<title>Support Center Admin Panel – FESTIVAL Aviation Support</title>
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
			<section class="support">
				<div class="section-content">
					<h2>Fragen</h2> 
					<%
					    if (success) {
					%>
					<article class="flag success">
						<div class="header">
							<div class="icon"><span><span class="ai ai-success"></span></span></div><span class="title">Aktion erfolgreich</span>
						</div>
						<div class="content">
							<p>Die Aktion wurde erfolgreich durchgeführt.</p>
						</div>
					</article> 
					<%
					    }
					 
					    if (dataError) {
					%>
					<article class="flag error">
						<div class="header">
							<div class="icon"><span><span class="ai ai-error"></span></span></div><span class="title">Hier funktioniert etwas nicht</span>
						</div>
						<div class="content">
							<p>Beim Durchführen der Aktion ist ein Fehler aufgetreten. Bitte versuch es später noch einmal.</p>
						</div>
					</article> 
					<%
					    }
					 
					    if (error) {
					%>
					<article class="flag error">
						<div class="header">
							<div class="icon"><span><span class="ai ai-error"></span></span></div><span class="title">Hier funktioniert etwas nicht</span>
						</div>
						<div class="content">
							<p>Es scheint als hätten wir Probleme im Hintergrund, sodass aktuell keine Fragen geladen werden können. Bitte versuch es später noch einmal.</p>
						</div>
					</article> 
					<%
					    }
					 
					    if (!error) {
					%>
					<article class="flag info">
						<div class="header">
							<div class="icon"><span><span class="ai ai-info"></span></span></div><span class="title">Information zu Fragen</span>
						</div>
						<div class="content">
							<p>Jede Frage hat eine eindeutige Id. Diese darf nicht für andere Fragen verwendet werden und kann später nicht geändert werden. Die Id darf nur aus Kleinbuchstaben, Zahlen und Bindestrichen bestehen.</p>
						</div>
					</article>
					<table class="editor">
						<tr>
							<th><kbd>linkId</kbd></th>
							<th><kbd>questionText</kbd></th>
							<th><kbd>answerText</kbd></th>
							<th>Aktionen</th>
						</tr> 
						<%
						     while (questions.next()) {
						%>
						<tr>
							<td><kbd><%= questions.getString("linkId") %></kbd></td>
							<td>
								<input type="text" data-q-question="<%= questions.getString("linkId") %>" value="<%= questions.getString("questionText") %>">
							</td>
							<td>
								<input type="text" data-q-answer="<%= questions.getString("linkId") %>" value="<%= questions.getString("answerText") %>">
							</td>
							<td>
								<button data-q-id="<%= questions.getString("linkId") %>" data-modal-type="question" data-modal-title="Frage aktualisieren?" data-modal-text="Möchtest du die Frage aktualisieren?" data-modal-primary="Frage aktualisieren" data-modal-primary-action="submit" class="icon success update modal-trigger"><span class="ai ai-check"></span></button>
								<button data-q-id="<%= questions.getString("linkId") %>" data-modal-type="error" data-modal-title="Frage löschen?" data-modal-text="Möchtest du die Frage löschen?" data-modal-primary="Frage löschen" data-modal-primary-action="submit" class="icon error delete modal-trigger"><span class="ai ai-delete"></span></button>
							</td>
						</tr> 
						<%
						    }
						%>
						<tr>
							<td>
								<input type="text" id="new-question-id">
							</td>
							<td>
								<input type="text" id="new-question-question">
							</td>
							<td>
								<input type="text" id="new-question-answer">
							</td>
							<td>
								<button data-modal-type="question" data-modal-title="Frage hinzufügen?" data-modal-text="Möchtest du die Frage hinzufügen?" data-modal-primary="Frage hinzufügen" data-modal-primary-action="submit" class="icon info insert modal-trigger"><span class="ai ai-plus"></span></button>
							</td>
						</tr>
					</table> 
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