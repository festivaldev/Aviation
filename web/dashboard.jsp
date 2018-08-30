<!--
    dashboard.jsp
    FESTIVAL Aviation

    Manage profile, password and billing address of loggedd in user
    Show open and completed bookings
    Link to support center admin panel if acitve user is admin

    @author Fabian Krahtz (f.krahtz@ostfalia.de)
    @version 1.0
-->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ml.festival.aviation.AuthManager" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%!
    public Boolean isCurrentPage(String requestedPage, String pageName) {
        if (requestedPage != null) {
            return pageName.equals(requestedPage);
        }
        return false;
    }
%>

<%
    Boolean validAuth = false;
    AuthManager authManager = new AuthManager();

    // Variables to store all sql data
    String accountId = "";
    String firstName = "";
    String lastName = "";
    String email = "";
    boolean isAdmin = false;
 
    String bId = "";
    String bPrefix = "";
    String bFirstName = "";
    String bLastName = "";
    String bStreet = "";
    String bPostalCode = "";
    String bPostalCity = "";
    String bCountry = "";
    String bEmail = "";
    String bPhone = "";
 
    String result = "";
 
    result = request.getParameter("result");

    // Make sure result isn't null
    if (result == null) {
        result = "";
    }

    // Check session id
    if (authManager.validate(String.valueOf(session.getAttribute("sid")))) {
        validAuth = true;
    }
 
    if (!validAuth) {
        // When session is invalid or doesn't exists, redirect user to login
        response.sendRedirect("login.jsp");
    } else if (request.getParameter("p") == null || request.getParameter("p").isEmpty()) {
        // When page Parameter isn't set or empty, redirect user to the profile page
        response.sendRedirect("dashboard.jsp?p=profile");
    } else if (validAuth) {

        // Load and set profile details

        ResultSet profile = authManager.getProfileDetails(String.valueOf(session.getAttribute("sid")));
 
        if (profile.next()) {
            accountId = profile.getString("id");
            firstName = profile.getString("firstName");
            lastName = profile.getString("lastName");
            email = profile.getString("email");
            isAdmin = profile.getBoolean("isAdmin");
        }

        // Laad and set billing details
 
        ResultSet billing = authManager.getBillingAddress(String.valueOf(session.getAttribute("sid")));
 
        if (billing != null) {
            bId = billing.getString("id");
            bPrefix = billing.getString("prefix");
            bFirstName = billing.getString("firstName");
            bLastName = billing.getString("lastName");
            bStreet = billing.getString("street");
            bPostalCode = billing.getString("postalCode");
            bPostalCity = billing.getString("postalCity");
            bCountry = billing.getString("country");
            bEmail = billing.getString("email");
            bPhone = billing.getString("phoneNumber");
        }
    }
 
    authManager.closeConnection();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
        <title>Dashboard – FESTIVAL Aviation</title>
        <link rel="stylesheet" href="css/aviation.css">
        <link rel="stylesheet" href="css/modal.built.css">
        <link rel="stylesheet" href="css/flag.built.css">
        <link rel="stylesheet" href="css/dashboard.built.css">
        <link rel="stylesheet" href="css/components/tables.css">
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
                    </div>
                    <a href="#" class="link-home"></a><a href="dashboard.jsp" class="link-user-cp"></a>
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
            <section class="dashboard">
                <%
                    // Show corresponding flag for each result

                       if (!result.isEmpty()) {
                %>

                <div style="margin-bottom: 2em" class="section-content">
                    <%
                        if (result.equals("profileUpdated")) {
                    %>

                    <article class="flag success">
                        <div class="header">
                            <div class="icon"><span><span class="ai ai-success"></span></span></div>
                            <span class="title">Profil aktualisiert</span>
                        </div>
                        <div class="content">
                            <p>Dein Profil wurde erfolgreich aktualisiert.</p>
                        </div>
                    </article>

                    <%
                        } else if (result.equals("passwordUpdated")) {
                    %>

                    <article class="flag success">
                        <div class="header">
                            <div class="icon"><span><span class="ai ai-success"></span></span></div>
                            <span class="title">Passwort aktualisiert</span>
                        </div>
                        <div class="content">
                            <p>Dein Passwort wurde erfolgreich aktualisiert.</p>
                        </div>
                    </article>

                    <%
                        } else if (result.equals("billingUpdated")) {
                    %>

                    <article class="flag success">
                        <div class="header">
                            <div class="icon"><span><span class="ai ai-success"></span></span></div>
                            <span class="title">Rechnungsadresse aktualisiert</span>
                        </div>
                        <div class="content">
                            <p>Deine Rechnungsadresse wurde erfolgreich aktualisiert.</p>
                        </div>
                    </article>

                    <%
                        } else if (result.equals("invalidData")) {
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
                        } else if (result.equals("oldPasswordWrong")) {
                    %>

                    <article class="flag error">
                        <div class="header">
                            <div class="icon"><span><span class="ai ai-error"></span></span></div>
                            <span class="title">Passwort falsch</span>
                        </div>
                        <div class="content">
                            <p>Das alte Passwort ist nicht korrekt.</p>
                        </div>
                    </article>

                    <%
                        } else if (result.equals("newPasswordsDontMatch")) {
                    %>

                    <article class="flag error">
                        <div class="header">
                            <div class="icon"><span><span class="ai ai-error"></span></span></div>
                            <span class="title">Passwörter ungleich</span>
                        </div>
                        <div class="content">
                            <p>Die neuen Passwörter stimmen nicht überein.</p>
                        </div>
                    </article>

                    <%
                        } else if (result.equals("error")) {
                    %>

                    <article class="flag error">
                        <div class="header">
                            <div class="icon"><span><span class="ai ai-error"></span></span></div>
                            <span class="title">Hier funktioniert etwas nicht</span>
                        </div>
                        <div class="content">
                            <p>Beim Durchführen der Aktion ist ein Fehler aufgetreten. Bitte versuch es später noch einmal.</p>
                        </div>
                    </article>

                    <%
                        }
                    %>

                </div>

                <%
                    }
                %>

                <div class="section-content row">
                    <aside class="column column-3">
                        <ul class="user-cp-menu">
                            <li class="menu-item heading">Allgemein</li>
                            <a href="?p=profile" class="menu-item <%= isCurrentPage(request.getParameter("p"), "profile") ? "selected" : "" %>">
                                <li>Profil</li>
                            </a>
                            <a href="?p=billing" class="menu-item <%= isCurrentPage(request.getParameter("p"), "billing") ? "selected" : "" %>">
                                <li>Rechnungsadresse</li>
                            </a>
                        </ul>

                        <ul class="user-cp-menu">
                            <li class="menu-item heading">Buchungen</li>
                            <a href="?p=openBookings" class="menu-item <%= isCurrentPage(request.getParameter("p"), "openBookings") ? "selected" : "" %>">
                                <li>Offene Buchungen</li>
                            </a>
                            <a href="?p=completedBookings" class="menu-item <%= isCurrentPage(request.getParameter("p"), "completedBookings") ? "selected" : "" %>">
                                <li>Abgeschlossene Buchungen</li>
                            </a>
                        </ul>

                        <%
                            // If user is admin, show additional menu

                            if (isAdmin) {
                        %>

                        <ul class="user-cp-menu">
                            <li class="menu-item heading">Administration</li>
                            <a href="sc-admin.jsp" class="menu-item">
                                <li>Support Center Admin Panel</li>
                            </a>
                        </ul>

                        <% } %>

                        <ul class="user-cp-menu">
                            <a href="?p=logout" class="menu-item">
                                <li>Abmelden</li>
                            </a>
                        </ul>
                    </aside>

                    <!-- Dynamic Page Content -->

                    <% if (isCurrentPage(request.getParameter("p"), "profile")) { %>

                    <div class="column column-8 offset-1">
                        <h2>Profil</h2>
                        <p>Hier kannst du die Details deines Profils anpassen.</p>
                        <form method="POST" action="update_profile.jsp" novalidate>
                            <input type="hidden" name="method" value="update-profile">
                            <input type="hidden" name="id" value="<%= accountId %>">
                            <label for="firstName">Vorname</label>
                            <input type="text" name="firstName" id="firstName" value="<%= firstName %>">
                            <label for="lastName">Nachname</label>
                            <input type="text" name="lastName" id="lastName" value="<%= lastName %>">
                            <label for="email">E-Mail-Adresse</label>
                            <input type="email" name="email" id="email" value="<%= email %>">
                            <button class="fill blue">Profil speichern</button>
                        </form>
                        <h3>Passwort ändern</h3>
                        <form method="POST" action="update_profile.jsp" novalidate>
                            <input type="hidden" name="method" value="update-password">
                            <input type="hidden" name="id" value="<%= accountId %>">
                            <label for="oldPassword">Altes Passwort</label>
                            <input type="password" name="oldPassword" id="oldPassword">
                            <label for="oldPassword">Neues Passwort</label>
                            <input type="password" name="newPassword" id="newPassword">
                            <label for="oldPassword">Neues Passwort bestätigen</label>
                            <input type="password" name="newPasswordConfirm" id="newPasswordConfirm">
                            <button class="fill blue">Passwort ändern</button>
                        </form>
                    </div>

                    <%
                        }
                        
                        if (isCurrentPage(request.getParameter("p"), "billing")) {
                    %>

                    <div class="column column-8 offset-1">
                        <h2>Rechnungsadresse</h2>
                        <p>Zum Buchen von Flügen benötigst du eine gültige Rechnungsadresse. Diese kannst du hier jederzeit ändern.</p>
                        <form method="POST" action="update_profile.jsp" novalidate>
                            <input type="hidden" name="method" value="update-billing">
                            <input type="hidden" name="id" value="<%= accountId %>">
                            <input type="hidden" name="billingId" value="<%= bId %>">
                            <div class="row no-justify">
                                <div class="column column-3">
                                    <label for="title">Anrede</label>
                                </div>
                                <div class="column column-6">
                                    <select name="title" id="title">
                                        <option value="" <%= bPrefix.isEmpty() ? "selected" : null %>></option>
                                        <option value="male" <%= bPrefix.equals("male") ? "selected" : null %>>Herr</option>
                                        <option value="female" <%= bPrefix.equals("female") ? "selected" : null %>>Frau</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row no-justify">
                                <div class="column column-3">
                                    <label for="firstName">Vorname</label>
                                </div>
                                <div class="column column-6">
                                    <input type="text" name="firstName" id="firstName" value="<%= bFirstName %>">
                                </div>
                            </div>
                            <div class="row no-justify">
                                <div class="column column-3">
                                    <label for="lastName">Nachname</label>
                                </div>
                                <div class="column column-6">
                                    <input type="text" name="lastName" id="lastName" value="<%= bLastName %>">
                                </div>
                            </div>
                            <div class="row no-justify">
                                <div class="column column-3">
                                    <label for="street">Straße</label>
                                </div>
                                <div class="column column-6">
                                    <input type="text" name="street" id="street" value="<%= bStreet %>">
                                </div>
                            </div>
                            <div class="row no-justify">
                                <div class="column column-3">
                                    <label for="zip">PLZ/Ort</label>
                                </div>
                                <div class="column column-2">
                                    <input type="text" name="zip" id="zip" value="<%= bPostalCode %>">
                                </div>
                                <div class="column column-4">
                                    <input type="text" name="city" id="city" value="<%= bPostalCity %>">
                                </div>
                            </div>
                            <div class="row no-justify">
                                <div class="column column-3">
                                    <label for="country">Land</label>
                                </div>
                                <div class="column column-6">
                                    <select name="country" id="country">
                                        <option value="de" <%= (bCountry.isEmpty() || bCountry.equals("de")) ? "selected" : null %>>Deutschland</option>
                                        <option value="at" <%= bCountry.equals("at") ? "selected" : null %>>Österreich</option>
                                        <option value="ch" <%= bCountry.equals("ch") ? "selected" : null %>>Schweiz</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row no-justify">
                                <div class="column column-3">
                                    <label for="email">E-Mail</label>
                                </div>
                                <div class="column column-6">
                                    <input type="email" name="email" id="email" value="<%= bEmail %>">
                                </div>
                            </div>
                            <div class="row no-justify">
                                <div class="column column-3">
                                    <label for="phone">Telefon</label>
                                </div>
                                <div class="column column-6">
                                    <input type="phone" name="phone" id="phone" value="<%= bPhone %>">
                                </div>
                            </div>
                            <button class="fill blue">Rechnungsadresse ändern</button>
                        </form>
                    </div>

                    <%
                       }
                     
                       if (isCurrentPage(request.getParameter("p"), "openBookings")) {
                    %>

                    <div class="column column-8 offset-1">
                        <h2>Offene Buchungen</h2>
                        <p>Hier siehst du eine Liste all deiner noch offenen Buchungen, also die, die noch bezahlt werden müssen.</p></p>
                        <table>
                            <thead>
                                <tr>
                                    <th>Flug</th>
                                    <th>Route</th>
                                    <th>Summe</th>
                                    <th>Verbleibend</th>
                                </tr>
                            </thead>
                            <tbody>
                                 <%
                                    InitialContext initialContext;
                                    Context environmentContext;
                                    DataSource dataSource;
                                    Connection conn = null;
                                    ResultSet bookings = null;

                                    // Variables to store sql data
                                    String invoice = "";
                                    String flightId = "";
                                    String fromIATA = "";
                                    String toIATA = "";
                                    String fromName = "";
                                    String toName = "";
                                    String extras = "";
                                    float price = 0F;
                                    LocalDateTime dateTime = LocalDateTime.now();

                                    try {
                                        initialContext = new InitialContext();
                                        environmentContext = (Context)initialContext.lookup("java:/comp/env");
                                        dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
                                        conn = dataSource.getConnection();

                                        // Get all bookings that aren't paid yet
                                        PreparedStatement statement = conn.prepareStatement("SELECT * FROM bookings WHERE holder = ? AND paid = FALSE");
                                        statement.setString(1, accountId);

                                        bookings = statement.executeQuery();

                                        while (bookings.next()) {
                                            invoice = bookings.getString("id");
                                            flightId = bookings.getString("flightId");
                                            fromIATA = bookings.getString("fromIATA");
                                            toIATA = bookings.getString("toIATA");
                                            extras = bookings.getString("extras");
                                            price = bookings.getFloat("price");
                                            dateTime = LocalDateTime.parse(bookings.getString("createdAt").replace(" ", "T"), DateTimeFormatter.ISO_DATE_TIME);

                                            // Get airport data for start airport
                                            PreparedStatement astm = conn.prepareStatement("SELECT name, municipality, iso_country FROM airports WHERE iata_code = ?");
                                            astm.setString(1, fromIATA);

                                            ResultSet airport = astm.executeQuery();

                                            if (airport.next()) {
                                                fromName = airport.getString("name") + ", " + airport.getString("municipality") + ", " + airport.getString("iso_country");
                                            }

                                            // Get airport data for destination airport
                                            astm.setString(1, toIATA);

                                            airport = astm.executeQuery();

                                            if (airport.next()) {
                                                toName = airport.getString("name") + ", " + airport.getString("municipality") + ", " + airport.getString("iso_country");
                                            }

                                            // Calculate total price by adding the cost of each extra
                                            if (extras.length() > 0 && extras.contains(",")) {
                                                for (int i = 0; i < extras.split(",").length; i++) {
                                                    PreparedStatement stm = conn.prepareStatement("SELECT * FROM services WHERE serviceId = ?");
                                                    stm.setString(1, extras.split(",")[i]);

                                                    ResultSet extra = stm.executeQuery();

                                                    if (extra.next()) {
                                                        price += extra.getFloat("price");
                                                    }
                                                }
                                            }
                                %>

                                <tr>
                                    <td><%= flightId %></td>
                                    <td><abbr title="<%= fromName %>"><%= fromIATA %></abbr> &rarr; <abbr title="<%= toName %>"><%= toIATA %></abbr></td>
                                    <td><%= String.format("%.2f", price) %>€<br><a href="checkout.jsp?invoice=<%= invoice %>" target="_blank" style="white-space: nowrap">Jetzt bezahlen</a></td>
                                    <td><%= LocalDateTime.now().until(dateTime.plusHours(24), ChronoUnit.HOURS) %> Stunden</td>
                                </tr>

                                <%
                                        }
                                        conn.close();
                                    } catch (Exception e) {
                                        // MySQL Error
                                        e.printStackTrace();
                                    }
                                %>

                            </tbody>
                        </table>
                    </div>

                    <%
                        }
                    
                        if (isCurrentPage(request.getParameter("p"), "completedBookings")) {
                    %>

                    <div class="column column-8 offset-1">
                        <h2>Abgeschlossene Buchungen</h2>
                        <p>Hier siehst du eine Liste all deiner abgeschlossenen Buchungen, also die, die bereits bezahlt wurden.</p>
                        <table>
                            <thead>
                                <tr>
                                    <th>Flug</th>
                                    <th>Route</th>
                                    <th>Klasse</th>
                                    <th>Extras</th>
                                    <th>Abflug</th>
                                    <th>Bezahlt am</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    InitialContext initialContext;
                                    Context environmentContext;
                                    DataSource dataSource;
                                    Connection conn = null;
                                    ResultSet bookings = null;

                                    // Variables to store all sql data
                                    String bookingId = "";
                                    String svid = "";
                                    String flightId = "";
                                    String fromIATA = "";
                                    String toIATA = "";
                                    String fromName = "";
                                    String toName = "";
                                    String flightClass = "";
                                    String extras = "";
                                    String extrasDisplay = "";
                                    LocalDateTime departure = LocalDateTime.now();
                                    LocalDateTime dateTime = LocalDateTime.now();
                                    boolean cancelled = false;

                                    try {
                                        initialContext = new InitialContext();
                                        environmentContext = (Context)initialContext.lookup("java:/comp/env");
                                        dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
                                        conn = dataSource.getConnection();

                                        // Get all bookings that are paid
                                        PreparedStatement statement = conn.prepareStatement("SELECT * FROM bookings WHERE holder = ? AND paid = TRUE");
                                        statement.setString(1, accountId);

                                        bookings = statement.executeQuery();

                                        while (bookings.next()) {
                                            bookingId = bookings.getString("id");
                                            svid = bookings.getString("svid");
                                            flightId = bookings.getString("flightId");
                                            fromIATA = bookings.getString("fromIATA");
                                            toIATA = bookings.getString("toIATA");
                                            flightClass = bookings.getString("class").toUpperCase().replace("_", " ");
                                            extras = bookings.getString("extras");
                                            departure = LocalDateTime.parse(bookings.getString("departure").replace(" ", "T"), DateTimeFormatter.ISO_DATE_TIME);
                                            dateTime = LocalDateTime.parse(bookings.getString("updatedAt").replace(" ", "T"), DateTimeFormatter.ISO_DATE_TIME);
                                            extrasDisplay = "";

                                            // Get airport data for start airport
                                            PreparedStatement astm = conn.prepareStatement("SELECT name, municipality, iso_country FROM airports WHERE iata_code = ?");
                                            astm.setString(1, fromIATA);

                                            ResultSet airport = astm.executeQuery();

                                            if (airport.next()) {
                                                fromName = airport.getString("name") + ", " + airport.getString("municipality") + ", " + airport.getString("iso_country");
                                            }

                                            // Get airport data for destination airport
                                            astm.setString(1, toIATA);

                                            airport = astm.executeQuery();

                                            if (airport.next()) {
                                                toName = airport.getString("name") + ", " + airport.getString("municipality") + ", " + airport.getString("iso_country");
                                            }

                                            // Get name for each extra
                                            if (extras.length() > 0 && extras.contains(",")) {
                                                for (int i = 0; i < extras.split(",").length; i++) {
                                                    PreparedStatement stm = conn.prepareStatement("SELECT * FROM services WHERE serviceId = ?");
                                                    stm.setString(1, extras.split(",")[i]);
                                                    ResultSet extra = stm.executeQuery();
                                                    if (extra.next()) {
                                                        extrasDisplay += extra.getString("title") + "\n";
                                                    }
                                                }
                                            } else {
                                                extrasDisplay = "Keine Extras gebucht";
                                            }

                                            // Check if booking is cancelled
                                            PreparedStatement stm = conn.prepareStatement("SELECT * FROM cancellations WHERE ticketId = ?");
                                            stm.setString(1, bookingId);

                                            ResultSet cancellation = stm.executeQuery();

                                            cancelled = cancellation.next();
                                %>

                                <tr>
                                    <td><%= flightId %></td>
                                    <td><abbr title="<%= fromName %>"><%= fromIATA %></abbr> &rarr; <abbr title="<%= toName %>"><%= toIATA %></abbr></td>
                                    <td><%= flightClass %></td>
                                    <td><a style="cursor: pointer" data-modal-type="info" data-modal-title="Extras" data-modal-text="<%= extrasDisplay %>" class="modal-trigger">Anzeigen</a></td>
                                    <td><%= departure.format(DateTimeFormatter.ofPattern("dd.MM.yy HH:mm")) %></td>

                                    <%
                                        if (cancelled) {
                                    %>

                                    <td>Storniert</td>

                                    <%
                                        } else {
                                    %>

                                    <td><%= dateTime.format(DateTimeFormatter.ofPattern("dd.MM.yy")) %><br><a style="cursor: pointer; white-space: nowrap" data-b-id="<%= bookingId %>" data-b-svid="<%= svid %>" data-b-holder="<%= accountId %>" data-b-email="<%= email %>" data-modal-type="error" data-modal-title="Ticket wirklich stornieren?" data-modal-text="Wenn alle Eingaben korrekt sind, wird das Ticket unwiderruflich storniert und unbrauchbar. Die Stornierung kann nicht rückgängig gemacht werden.&#xA;&#xA;SVID: <%= svid %>" data-modal-primary="Ticket stornieren" data-modal-primary-action="submit" data-modal-primary-target="hidden-form" class="cancel modal-trigger">Stornieren</a></td>

                                    <%
                                        }
                                    %>
                                </tr>
                            </tbody>

                                <%
                                        }
                                        conn.close();
                                    } catch (Exception e) {
                                        // MySQL Error
                                        e.printStackTrace();
                                    }
                                %>

                        </table>
                    </div>

                    <%
                        }
                    
                        if (isCurrentPage(request.getParameter("p"), "logout")) {
                    %>

                    <div class="column column-8 offset-1">
                        <h2>Abmeldung erfolgt...</h2>
                        <p>Du wirst in Kürze abgemeldet und zur Startseite umgeleitet</p>

                        <%
                            authManager.openConnection();
                            if (authManager.destroySession(String.valueOf(session.getAttribute("sid"))) == AuthManager.ErrorCode.OK) {
                                response.sendRedirect("index.jsp");
                            }
                            authManager.closeConnection();
                        %>

                    </div>

                    <% } %>

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

        <script src="js/dashboard.js"></script>
        <script src="js/modal.js"></script>
        <script src="js/icons.js"></script>

    </body>
</html>
