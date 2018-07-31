<%--suppress UnhandledExceptionInJSP --%>

<%--
-
-   Festival Aviation - Login
-   Fabian Krahtz
-
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.Random" %>

<%

    String id = request.getParameter("id");
    String password = request.getParameter("password");

    if (id == null || id.isEmpty() || password == null || password.isEmpty()) {
        // TODO Error: Missing Input
        return;
    }

    MessageDigest digest = MessageDigest.getInstance("SHA-256");
    byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
    String b64Hash = new String(Base64.getEncoder().encode(hash));

    Context initContext = new InitialContext();
    Context envContext = (Context) initContext.lookup("java:/comp/env");
    DataSource ds = (DataSource) envContext.lookup("jdbc/iae");
    Connection c = ds.getConnection();

    PreparedStatement pst = c.prepareStatement("SELECT hash FROM users WHERE id = ?");
    pst.setString(1, id);

    ResultSet rs = pst.executeQuery();

    if (rs.next() && rs.getString("hash").equals(b64Hash)) {
        String sessionId = id + LocalDateTime.now().toString() + "FAV" + new Random().nextLong();
        String sid = new String(Base64.getEncoder().encode(digest.digest(sessionId.getBytes(StandardCharsets.UTF_8))));

        session.setAttribute("uid", id);
        session.setAttribute("sid", sid);

        pst = c.prepareStatement("DELETE FROM sessions WHERE uid = ?");
        pst.setString(1, id);
        pst.execute();

        pst = c.prepareStatement("INSERT INTO sessions VALUES (?, ?)");
        pst.setString(1, id);
        pst.setString(2, sid);
        pst.execute();

        pst.close();
        c.close();

        response.sendRedirect("http://192.168.0.103:8080/dashboard.jsp");
    }

%>

<html>

    <head>
        <title>Festival Aviation</title>
    </head>

    <body>
    </body>

</html>
