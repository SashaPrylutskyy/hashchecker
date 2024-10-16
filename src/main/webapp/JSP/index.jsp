<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.sashaprylutskyy.hashchecker.DatabaseDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hash checked | main</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/style.css">
</head>
<body>
<%@ include file="templates/header.jsp"%>
<div class="records">
<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) {
%>
        <div class="container">
            <h1>DON'T BE FOOLED</h1>
            <hr>
            <h2>COMPARE BEFORE YOU CARE!</h2>
        </div>
<%
    } else {
        DatabaseDAO database = DatabaseDAO.getInstance();
        database.connect();

        String user_email = session.getAttribute("username").toString();
        try {
            ResultSet rs = database.getUserRecords(user_email);
            while (rs.next()) {
%>
                <div class="record">
                    <a href="/record?id=<%= rs.getInt("id")%>">
                        <div class="record-content">
                            <h2 class="title"><%= rs.getString("title")%></h2>
    <%--                        <p class="upload_time">uploaded: 28.09.2024</p>--%>
                            <p class="hashcode">hash: <%= rs.getString("hashcode")%></p>
                        </div>
                    </a>
                </div>
<%
            }
        } catch (SQLException e) {
%>          <div class="container">
                <h5 style="color: darkred; ">Couldn't reach database</h5>
            </div>

<%
        }
    }
%>
</div>
</body>
</html>