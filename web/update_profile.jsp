<!--
    update_profile.jsp
    FESTIVAL Aviation

    Has methods to update a users profile in the dashboard

    @author Jonas Zadach (j.zadach@ostfalia.de)
    @version 1.0
-->

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.Base64" %>

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

    try {
        initialContext = new InitialContext();
        environmentContext = (Context)initialContext.lookup("java:/comp/env");
        dataSource = (DataSource)environmentContext.lookup("jdbc/aviation");
        conn = dataSource.getConnection();

        request.setCharacterEncoding("UTF-8");

        if ("POST".equals(request.getMethod())) {
            // These request parameters are shared between all methods
            String method = request.getParameter("method");
            String id = request.getParameter("id");

            if ("update-profile".equals(method)) {
                // Update first name, last name and email in the database
                PreparedStatement p = conn.prepareStatement("UPDATE accounts SET firstName = ?, lastName = ?, email = ? WHERE id = ?");

                // Get request data
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");

                if (firstName == null || firstName.isEmpty() || lastName == null || lastName.isEmpty() || email == null || email.isEmpty()) {
                    // Some fields aren't filled out
                    response.sendRedirect("dashboard.jsp?p=profile&result=invalidData");

                    conn.close();
                    return;
                }

                p.setString(1, firstName);
                p.setString(2, lastName);
                p.setString(3, email);
                p.setString(4, id);

                p.execute();

                // Redirect with result to show the success flag
                response.sendRedirect("dashboard.jsp?p=profile&result=profileUpdated");
            } else if ("update-password".equals(method)) {

                // Get request data
                String oldPassword = request.getParameter("oldPassword");
                String newPassword = request.getParameter("newPassword");
                String newPasswordRepeat = request.getParameter("newPasswordConfirm");

                
                if (oldPassword == null || oldPassword.isEmpty() || newPassword == null || newPassword.isEmpty() || newPasswordRepeat == null || newPasswordRepeat.isEmpty()) {
                    // Some fields aren't filled out
                    response.sendRedirect("dashboard.jsp?p=profile&result=invalidData");

                    conn.close();
                    return;
                }

                try {
                    oldPassword = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(oldPassword.getBytes(StandardCharsets.UTF_8))));
                    newPassword = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(newPassword.getBytes(StandardCharsets.UTF_8))));
                    newPasswordRepeat = new String(Base64.getEncoder().encode(MessageDigest.getInstance("SHA-256").digest(newPasswordRepeat.getBytes(StandardCharsets.UTF_8))));
                } catch (Exception e) {
                    response.sendRedirect("dashboard.jsp?p=profile&result=invalidData");

                    conn.close();
                    return;
                }

                if (newPassword.equals(newPasswordRepeat)) {
                    // If the user correctly repeated the new password, get the old one
                    PreparedStatement p = conn.prepareStatement("SELECT password FROM accounts WHERE id = ?");

                    p.setString(1, id);

                    ResultSet pw = p.executeQuery();

                    if (pw.next() && pw.getString("password").equals(oldPassword)) {
                        // If the user entered the old one correctly, update the password in the database to the new one
                        p = conn.prepareStatement("UPDATE accounts SET password = ? WHERE id = ?");

                        p.setString(1, newPassword);
                        p.setString(2, id);

                        p.execute();


                        // Redirect with result to show the success flag
                        response.sendRedirect("dashboard.jsp?p=profile&result=passwordUpdated");
                    } else {
                        // Redirect with result to show the error flag
                        response.sendRedirect("dashboard.jsp?p=profile&result=oldPasswordWrong");

                        conn.close();
                        return;
                    }
                } else {
                    // Redirect with result to show the error flag
                    response.sendRedirect("dashboard.jsp?p=profile&result=newPasswordsDontMatch");

                    conn.close();
                    return;
                }
            } else if ("update-billing".equals(method)) {
                // Replace the users billing address (REPLACE INTO either replaces or creates)
                PreparedStatement p = conn.prepareStatement("REPLACE INTO billing_addresses VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, DEFAULT, DEFAULT)");

                // Get the request data
                String title = request.getParameter("title");
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String street = request.getParameter("street");
                String zip = request.getParameter("zip");
                String city = request.getParameter("city");
                String country = request.getParameter("country");
                String email = request.getParameter("email");
                String phone = request.getParameter("phone");
                String existingId = request.getParameter("billingId");

                if (title == null || title.isEmpty() || firstName == null || firstName.isEmpty() || lastName == null || lastName.isEmpty() || street == null || street.isEmpty() || zip == null || zip.isEmpty() || city == null || city.isEmpty() || country == null || country.isEmpty() || email == null || email.isEmpty() || phone == null || phone.isEmpty()) {
                    // Some fields aren't filled out
                    response.sendRedirect("dashboard.jsp?p=billing&result=invalidData");

                    conn.close();
                    return;
                }

                String billingId = bytesToHex(MessageDigest.getInstance("SHA-256").digest(String.format("%s%s%s%d", firstName, lastName, email, System.currentTimeMillis() / 1000L).getBytes(StandardCharsets.UTF_8))).substring(0, 32);

                if (existingId != null && !existingId.isEmpty()) {
                    // If the user already had a billing address and it's id is given, re-use the old id
                    p.setString(1, existingId);
                } else {
                    // If the user creates a new address assign it a new id
                    p.setString(1, billingId);
                }
                p.setString(2, id);
                p.setString(3, request.getParameter("title"));
                p.setString(4, request.getParameter("firstName"));
                p.setString(5, request.getParameter("lastName"));
                p.setString(6, request.getParameter("street"));
                p.setString(7, request.getParameter("zip"));
                p.setString(8, request.getParameter("city"));
                p.setString(9, request.getParameter("country"));
                p.setString(10, request.getParameter("email"));
                p.setString(11, request.getParameter("phone"));

                p.execute();


                // Redirect with result to show the success flag
                response.sendRedirect("dashboard.jsp?p=billing&result=billingUpdated");
            }
        }

    } catch (Exception e) {
        // Redirect with result to show the error flag
        
        response.sendRedirect("dashboard.jsp?p=profile&result=error");
        e.printStackTrace();
    }

    // Remember to close the connection
    if (conn != null)
        conn.close();
%>
