<!--
    sc-cancellations.jsp
    FESTIVAL Aviation

    Cancel bookings that have been made without beeing logged in

    @author Fabian Krahtz (f.krahtz@ostfalia.de)
    @version 1.0
-->

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

    // Variables for request data
    String holder = "";
    String ticketId = "";
    String svid = "";
    String email = "";
    String message = "";

    // Flags for results
    boolean invalid = false;
    boolean send = false;
    boolean error = false;
    boolean inputError = false;
 
    request.setCharacterEncoding("UTF-8");
 
    if ("POST".equals(request.getMethod())) {
        // We don't want any of this to happen when we just visit the page via a GET request

        // Get request data
        holder = request.getParameter("holder");
        ticketId = request.getParameter("bookingId");
        svid = request.getParameter("svid");
        email = request.getParameter("email");
        message = request.getParameter("message");
 
        if (holder != null && !holder.isEmpty() && ticketId != null && !ticketId.isEmpty() && email != null && !email.isEmpty() && svid != null && !svid.isEmpty()) {
            try {
                initialContext = new InitialContext();
                environmentContext = (Context)initialContext.lookup("java:/comp/env");
                dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
                conn = dataSource.getConnection();

                // Get SVID and holder for the booking that the user wants to cancel
                PreparedStatement statement = conn.prepareStatement("SELECT svid, holder FROM bookings WHERE id = ?");
 
                statement.setString(1, ticketId);
 
                ResultSet ticket = statement.executeQuery();
 
                if (ticket != null && ticket.next()) {
                    if (ticket.getString("holder").equals(holder) && ticket.getString("svid").equals(svid)) {
                        // Insert new cancellation for this booking
                        statement = conn.prepareStatement("INSERT INTO `cancellations` VALUES (?, ?, ?, ?, DEFAULT, DEFAULT)");
 
                        statement.setString(1, ticketId);
                        statement.setString(2, ticketId);
                        statement.setString(3, email);
                        statement.setString(4, message);
 
                        statement.execute();
 
                        send = true;
                    } else {
                        // Holder and/or SVID is not correct
                        inputError = true;
                    }
                } else {
                    // No booking found
                    error = true;
                }
            } catch (Exception e) {
                // Catch all sql errors

                error = true;
                e.printStackTrace();
            }
        } else {
            // Some fields haven't been filled out

            invalid = true;
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
        <title>Stornierungen – FESTIVAL Aviation Support</title>
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
                    <div id="modal-title-bar" class="title-bar">
                        <span class="icon error"><span class="ai ai-error"></span></span>
                        <span class="icon info"><span class="ai ai-info"></span></span>
                        <span class="icon question"><span class="ai ai-question"></span></span>
                        <span class="icon success"><span class="ai ai-success"></span></span>
                        <span class="icon warning"><span class="ai ai-warning"></span></span>
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
                    <aside class="column column-3">
                        <ul class="sc-menu">
                            <li class="menu-item heading">Support</li>
                            <a href="sc-index.jsp" class="menu-item">
                                <li>FAQ</li>
                            </a>
                            <a href="sc-contact.jsp" class="menu-item">
                                <li>Kontakt</li>
                            </a>
                            <a href="sc-cancellations.jsp" class="menu-item selected">
                                <li>Stornierungen</li>
                            </a>
                            <a href="sc-complaints.jsp" class="menu-item">
                                <li>Beschwerden</li>
                            </a>
                            <a href="sc-rights.html" class="menu-item">
                                <li>Fluggastrechte</li>
                            </a>
                        </ul>
                    </aside>

                    <div class="column column-8 offset-1">
                        <h2>Stornierungen</h2>

                        <%
                            // Show corresponding flag for each result

                            if (send) {
                        %>

                        <article class="flag success">
                            <div class="header">
                                <div class="icon"><span><span class="ai ai-success"></span></span></div>
                                <span class="title">Ticket storniert</span>
                            </div>
                            <div class="content">
                                <p>Du hast das Ticket erfolgreich storniert. Die Gutschrift erfolgt in Kürze.</p>
                            </div>
                        </article>

                        <%
                            }
                         
                            if (error) {
                        %>

                        <article class="flag error">
                            <div class="header">
                                <div class="icon"><span><span class="ai ai-error"></span></span></div>
                                <span class="title">Hier funktioniert etwas nicht</span>
                            </div>
                            <div class="content">
                                <p>Beim Absenden deiner Stornierung ist ein Fehler aufgetreten. Bitte versuch es später noch einmal oder überprüfe deine Buchungs-ID.</p>
                            </div>
                        </article>

                        <%
                            }
                         
                            if (invalid) {
                        %>

                        <article class="flag error">
                            <div class="header">
                                <div class="icon"><span><span class="ai ai-error"></span></span></div>
                                <span class="title">Ungültige Eingabe</span>
                            </div>
                            <div class="content">
                                <p>Du musst alle Felder, die nicht als optional gekennzeichnet sind, ausfüllen.</p>
                            </div>
                        </article>

                        <%
                            }
                         
                            if (inputError) {
                        %>

                        <article class="flag error">
                            <div class="header">
                                <div class="icon"><span><span class="ai ai-error"></span></span></div>
                                <span class="title">Ungültige Eingabe</span>
                            </div>
                            <div class="content">
                                <p>Deine Eingaben sind nicht korrekt. Überprüfe die Felder bitte auf ihre Richtigkeit. Wenn der Fehler weiterhin auftritt versuch das Ticket über das Dashboard zu stornieren oder <a href="sc-contact.jsp">melde dich bei uns</a>.</p>
                            </div>
                        </article>

                        <%
                            }

                            // Don't show the form again, if the cancellation has been done (We don't want the user to cancel his ticket again)

                            if (!send) {
                        %>

                        <article class="flag warning">
                            <div class="header">
                                <div class="icon"><span><span class="ai ai-warning"></span></span></div>
                                <span class="title">Hinweis</span>
                            </div>
                            <div class="content">
                                <p>Hier kannst du nur Buchungen stornieren, die ohne Account erstellt wurden. Wenn du deine Buchung von einem Account aus getätigt hast, storniere deine sie bitte im <a href="dashboard.jsp?p=completedBookings">Dashboard</a>.</p>
                            </div>
                        </article>

                        <form method="POST" action="sc-cancellations.jsp" novalidate>
                            <label for="holder">Name des Passagiers</label>
                            <input type="text" name="holder" id="holder" value="<%= holder %>">
                            <label for="bookingId">Buchungs-ID</label>
                            <input type="text" name="bookingId" id="bookingId" value="<%= ticketId %>">
                            <a data-modal-type="question" data-modal-title="Was ist die Buchungs-ID?" data-modal-text="Die Buchungs-ID ist eine für jede Buchung einzigartige Nummer, die es ermöglicht eine Buchung eindeutig zu identifizieren. Sie befindet sich auf der Rechnung." class="help modal-trigger">Was ist das?</a>
                            <label for="svid">Storno-Verifizierungs-ID (SVID)</label>
                            <input type="text" name="svid" id="svid" value="<%= svid %>">
                            <a data-modal-type="question" data-modal-title="Was ist die Storno-Verifizierungs-ID?" data-modal-text="Bei der Storno-Verifizierungs-ID handelt es sich um eine Nummer die als Sicherheit benötigt wird, um die Stornierung durchzuführen. Die Storno-Verifizierungs-ID findest du in deiner Rechnung." class="help modal-trigger">Was ist das?</a>
                            <label for="email">E-Mail-Adresse</label>
                            <p class="description">Gib hier die E-Mail-Adresse des Accounts an, der die Gutschrift bekommen soll.</p>
                            <input type="email" name="email" id="email" value="<%= email %>">
                            <label for="message">Grund der Stornierung (optional)</label>
                            <textarea name="message" id="message" rows="12"></textarea>
                            <button data-modal-type="error" data-modal-title="Ticket wirklich stornieren?" data-modal-text="Wenn alle Eingaben korrekt sind, wird das Ticket unwiderruflich storniert und unbrauchbar. Die Stornierung kann nicht rückgängig gemacht werden." data-modal-primary="Ticket stornieren" data-modal-primary-action="submit" class="fill blue modal-trigger">Absenden</button>
                        </form>

                        <%
                            }
                        %>
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

        <script src="js/support-center.js"></script>
        <script src="js/modal.js"></script>
        <script src="js/icons.js"></script>
    </body>
</html> 

<%
    // As always, make sure to close the connection
    if (conn != null)
        conn.close();
%>
