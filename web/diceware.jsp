<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Random" %>

<%
    String path = session.getServletContext().getRealPath("/resources/diceware.txt");
    BufferedReader reader = new BufferedReader(new FileReader(path));
    String line;
    Map<String, String> dictionary = new HashMap<>();

    while((line = reader.readLine()) != null){
        dictionary.put(line.split(" ")[0], line.split(" ")[1]);
    }

    response.setContentType("application/json");
    response.getWriter().print("\"" + dictionary.get(String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1)) + " " + dictionary.get(String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1)) + " " + dictionary.get(String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1)) + " " + dictionary.get(String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1) + String.valueOf(new Random().nextInt(6) + 1)) + "\"");
%>
