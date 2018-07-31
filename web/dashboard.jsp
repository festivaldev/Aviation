<%--suppress UnhandledExceptionInJSP --%>

<%--
-
-   Festival Aviation - Check
-   Fabian Krahtz
-
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>

<%

    if (session.getAttribute("uid") == null || session.getAttribute("sid") == null) {
        response.sendRedirect("login.html");
        return;
    }

    String id = (String) session.getAttribute("uid");
    String sid = (String) session.getAttribute("sid");

    Context initContext = new InitialContext();
    Context envContext = (Context) initContext.lookup("java:/comp/env");
    DataSource ds = (DataSource) envContext.lookup("jdbc/iae");
    Connection c = ds.getConnection();

    PreparedStatement pst = c.prepareStatement("SELECT sid FROM sessions WHERE uid = ?");
    pst.setString(1, id);

    ResultSet rs = pst.executeQuery();

    boolean valid = rs.next() && rs.getString("sid").equals(sid);

    pst.close();
    c.close();

    if (!valid) {
        response.sendRedirect("login.html");
        return;
    }


%>

<html>

    <head>
        <title>Festival Aviation</title>
        <link href="resources/style.css" rel="stylesheet">
    </head>

    <body>

        <nav class="navigation">

        </nav>

        <section class="page-container">

            <figure class="hero is-light is-manual-size mb-2" style="height: 200px">
                <img class="is-rounded" src="https://images.pexels.com/photos/615060/pexels-photo-615060.jpeg" alt="Plane Header" width="100%" />
                <span class="hero-title">Willkommen Fabian Krahtz!</span>
            </figure>

            <div class="columns">

                <aside>
                    <div class="box mt-1 mb-2" style="display: flex; flex-wrap: wrap">
                        <h5 class="aside-nav is-active"><a href="#">Dashboard</a></h5>
                        <h5 class="aside-nav"><a href="#">Tickets</a></h5>
                        <h5 class="aside-nav"><a href="#">Buchungen</a></h5>
                        <div class="divider my-1" style="width: 100%"></div>
                        <h5 class="aside-nav"><a href="#">Konto</a></h5>
                        <h5 class="aside-nav"><a href="logout.jsp">Abmelden</a></h5>
                    </div>
                </aside>

                <section>
                    <h1>Dashboard</h1>

                    <article class="mb-2">
                        <h5>Viktige komm&aelig;nde Änderingen</h5>

                        <article class="details my-1" style="background-color: #FFD500; box-shadow: 0 0 20px 1px #F6D88C">
                            <h6>LH 38: Hannover (HAJ) &rarr; Los Angeles (LAX)</h6>
                            <p>Der Layover in <em>Frankfurt am Main (FRA)</em> verlängert sich um 60 Minuten. Neue Ankunftszeit: 17:20.</p>
                        </article>
                    </article>

                    <article class="my-2">
                        <h5>Nächste Flüge</h5>

                        <article class="details my-1">
                            <h6>AY 4211: Hannover (HAJ) &rarr; Helsinki (HEL)</h6>
                            <p>01.07.2018 10:00 MESZ &rarr; 01.07.2018 12:45 OESZ</p>
                        </article>

                        <article class="details my-1">
                            <h6>AY 4212: Helsinki (HEL) &rarr; Hannover (HAJ)</h6>
                            <p>08.07.2018 22:30 OESZ &rarr; 09.07.2018 02:00 MESZ</p>
                        </article>
                    </article>

                    <article class="my-2">
                        <h5>Letzte Buchungen</h5>

                        <article class="details my-1">
                            <h6>1x Business Economy Finnair</h6>
                            <p>142M-E8801L-AY</p>
                            <p>139,00€</p>
                            <p><span class="indicator-dot" style="background-color: #6BCB4B"></span>Bezahlt am 06.06.2018</p>
                        </article>

                        <article class="details my-1">
                            <h6>1x Business Economy Finnair</h6>
                            <p>253A-E4511C-AY</p>
                            <p>139,00€</p>
                            <p style="color: #FF5A5F"><span class="indicator-dot" style="background-color: #FF5A5F"></span>Zahlung ausstehend</p>
                        </article>


                        <!-- <table class="table has-text-centered mt-1">
                            <tr>
                                <th>Rechnungsnummer</th>
                                <th>Tickets</th>
                                <th>Flugroute</th>
                                <th>Summe</th>
                                <th>Kaufdatum</th>
                                <th>Bezahldatum</th>
                            </tr>
                            <tr>
                                <td>253A-E4511C-AY</td>
                                <td>1x Business Economy Finnair</td>
                                <td>Hannover (HAJ) &rarr; Helsinki (HEL)</td>
                                <td>139,00€</td>
                                <td>06.06.2018</td>
                                <td>06.06.2018</td>
                            </tr>
                        </table> -->

                    </article>
                </section>

            </div>

        </section>

    </body>

</html>
