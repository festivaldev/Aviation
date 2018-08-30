<!--
    sc-complaints.jsp
    FESTIVAL Aviation

    Complaint form for customers

    @author Fabian Krahtz (f.krahtz@ostfalia.de)
    @version 1.0
-->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.sql.PreparedStatement" %>

<%!
    private String bytesToHex(byte[] bytes) {
        StringBuffer result = new StringBuffer();
        for (byte byt : bytes) result.append(Integer.toString((byt & 0xff) + 0x100, 16).substring(1));
        return result.toString();
    }
%>
 
<%
    InitialContext initialContext;
    Context environmentContext;
    DataSource dataSource;
    Connection conn = null;

    // Variables to store request data
    String firstName = "";
    String lastName = "";
    String email = "";
    String type = "";
    String message = "";

    // Flags for results
    boolean invalid = false;
    boolean send = false;
    boolean error = false;
 
    request.setCharacterEncoding("UTF-8");
 
    if ("POST".equals(request.getMethod())) {
        // Again, we don't want this to happen when we just *visit* the page

        // Get request data
        firstName = request.getParameter("firstName");
        lastName = request.getParameter("lastName");
        email = request.getParameter("email");
        type = request.getParameter("complaintType");
        message = request.getParameter("message");
 
        if (firstName != null && !firstName.isEmpty() && lastName != null && !lastName.isEmpty() && email != null && !email.isEmpty() && message != null && !message.isEmpty()) {
            try {
                initialContext = new InitialContext();
                environmentContext = (Context)initialContext.lookup("java:/comp/env");
                dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
                conn = dataSource.getConnection();

                // Insert complaint into database
                PreparedStatement statement = conn.prepareStatement("INSERT INTO `contacts` VALUES (?, ?, ?, ?, ?, ?, default, default)");
 
                statement.setString(1, bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%s%s%s%s%d", firstName, lastName, email, message, System.currentTimeMillis() / 1000L).getBytes(StandardCharsets.UTF_8))).substring(0, 32));
                statement.setString(2, firstName);
                statement.setString(3, lastName);
                statement.setString(4, email);
                statement.setString(5, type);
                statement.setString(6, message);
 
                statement.execute();
 
                send = true;
            } catch (Exception e) {
                // Catch all sql errors

                error = true;
                e.printStackTrace();
            }
        } else {
            // Some fields aren't filled out

            invalid = true;
        }
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
        <title>Beschwerden – FESTIVAL Aviation Support</title>
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
                            <a href="sc-cancellations.jsp" class="menu-item">
                                <li>Stornierungen</li>
                            </a>
                            <a href="sc-complaints.jsp" class="menu-item selected">
                                <li>Beschwerden</li>
                            </a>
                            <a href="sc-rights.html" class="menu-item">
                                <li>Fluggastrechte</li>
                            </a>
                        </ul>
                    </aside>

                    <div class="column column-8 offset-1">
                        <h2>Beschwerde einreichen</h2>
                        <p class="flow">Etwas lief bei deiner letzten Buchung schief oder du bist mit dem Flug nicht zufrieden gewesen? Was es auch sein mag, wir kümmern uns drum; Denn du verdienst es!</p>
                        <p class="flow">Allerdings benötigen wir dafür ein paar Details von dir. Versuch das wichtigste in deiner Nachricht zu erwähnen, dann müssen wir nicht so viel nachfragen und können uns schneller und besser um dein Problem kümmern!</p> 

                        <%
                            // Show corresponding flag for each result

                            if (send) {
                        %>

                        <article class="flag success">
                            <div class="header">
                                <div class="icon"><span><span class="ai ai-success"></span></span></div>
                                <span class="title">Beschwerde abgeschickt</span>
                            </div>
                            <div class="content">
                                <p>Deine Beschwerde wurde erfolgreich abgeschickt. Wir kümmern uns jetzt so schnell wie möglich um dein Anliegen.</p>
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
                                <p>Beim Absenden deiner Beschwerde ist ein Fehler aufgetreten. Bitte versuch es später noch einmal.</p>
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
                        %>

                        <form action="#">
                            <label for="firstName">Vorname</label>
                            <input type="text" name="firstName" id="firstName">
                            <label for="lastName">Nachname</label>
                            <input type="text" name="lastName" id="lastName">
                            <label for="email">E-Mail-Adresse</label>
                            <input type="email" name="email" id="email">
                            <a data-modal-type="question" data-modal-title="Warum muss ich eine E-Mail-Adresse angeben?" data-modal-text="Ohne Angabe einer E-Mail-Adresse können wir nicht auf dein Anliegen antworten. Aber keine Sorge, alle deine Daten werden vertraulich behandelt und nur bis zur Aufklärung deiner Anfrage aufbewahrt." class="help modal-trigger">Ist das notwendig?</a>
                            <label for="complaintType">Art der Beschwerde</label>
                            <select name="complaintType" id="complaintType">
                                <option value="general">Allgemeine Beschwerde</option>
                                <option value="search">Suche</option>
                                <option value="offer">Anegbot</option>
                                <option value="ads-marketing">Werbung + Marceting</option>
                                <option value="flight">Flug</option>
                                <option value="other">Sonstige</option>
                            </select>
                            <label for="message">Ihre Nachricht</label>
                            <textarea name="message" id="message" rows="12"></textarea>
                            <button data-modal-type="warning" data-modal-title="Passt das so?" data-modal-text="Du kannst deine Nachricht nach dem Abschicken nicht mehr bearbeiten. Bist du sicher, dass du deine Nachricht so abschicken willst?" data-modal-primary="Das passt so!" data-modal-primary-action="submit" data-modal-secondary="Ne noch nicht" class="fill blue modal-trigger">Absenden</button>
                        </form>
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
    // You wanna close this at all times!
    if (conn != null)
        conn.close();
%>
