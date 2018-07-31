<%--suppress UnhandledExceptionInJSP --%>

<%--
-
-   Festival Aviation - Registrierung
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

<%

    String name = request.getParameter("name");
    String surname = request.getParameter("surname");
    String email = request.getParameter("email");
    String id = request.getParameter("id");
    String password = request.getParameter("password");

    if (name == null || name.isEmpty() || surname == null || surname.isEmpty() || email == null || email.isEmpty() || id == null || id.isEmpty() || password == null || password.isEmpty()) {
        // TODO Error: Missing Input
    }

    //noinspection UnhandledExceptionInJSP
    MessageDigest digest = MessageDigest.getInstance("SHA-256");
    byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
    String b64Hash = new String(Base64.getEncoder().encode(hash));


    Context initContext = new InitialContext();
    Context envContext = (Context) initContext.lookup("java:/comp/env");
    DataSource ds = (DataSource) envContext.lookup("jdbc/iae");
    Connection c = ds.getConnection();


    PreparedStatement pst = c.prepareStatement("INSERT INTO users VALUES (?, ?, ?, ?, ?)");
    pst.setString(1, name);
    pst.setString(2, surname);
    pst.setString(3, email);
    pst.setString(4, id);
    pst.setString(5, b64Hash);

    pst.execute();
    pst.close();
    c.close();

%>

<html>

    <head>
        <title>Festival Aviation</title>
    </head>

    <body>
        <%= name%>
    </body>

</html>
