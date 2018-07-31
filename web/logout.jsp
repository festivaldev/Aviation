<%--suppress UnhandledExceptionInJSP --%>

<%--
-
-   Festival Aviation - Logout
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

    if (rs.next() && rs.getString("sid").equals(sid)) {
        pst = c.prepareStatement("DELETE FROM sessions WHERE uid = ?");
        pst.setString(1, id);
        pst.execute();
    }

    pst.close();
    c.close();

    response.sendRedirect("logout.html");
    return;

%>