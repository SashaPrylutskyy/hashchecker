<%@ page import="com.sashaprylutskyy.hashchecker.DatabaseDAO" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/record.css">
    <style>

    </style>
</head>
<body>
<%@ include file="templates/header.jsp" %>

<div class="container">
    <h1 id="info-message">Record information</h1>
</div>
<%
    DatabaseDAO database = DatabaseDAO.getInstance();
    database.connect();

    String recordID = request.getParameter("id");
    if (recordID != null) {
        int id = Integer.parseInt(recordID);
        try {
            ResultSet rs = database.getRecord(id);

            if (rs.next()) {
%>
                <div id="file-details" class="file-details">
                    <h2>File: <%= rs.getString("title")%>></h2>
                    <p><strong><%= rs.getInt("file_size")%></strong></p>
                    <hr>
                    <p><strong>Uploaded by:</strong> <%= rs.getString("email")%></p>
                    <!--    <p>Uploaded on: 2024-10-06</p>-->
                    <p><strong>Hash:</strong>
                        <i style="font-family: sans-serif; font-style: normal"><%= rs.getString("hashcode")%></i>
                    </p>

                    <div class="buttons">
                        <button class="check-btn" onclick="check()">Check</button>
                        <button class="share-btn" onclick="share()">Share</button>
                        <button class="delete-btn" onclick="deleteRecord()">Delete</button>
                    </div>
                </div>
<%
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
%>

<script>
    function deleteRecord() {
        const fileDetails = document.getElementById("file-details");

        const urlParams = new URLSearchParams(window.location.search);
        const recordID = urlParams.get("id");

        fetch("/delete", {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({recordID: recordID})
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === "success") {
                    fileDetails.classList.add("fade-out");

                    setTimeout(function () {
                        fileDetails.style.display = "none";
                    }, 2000);
                } else {
                    document.getElementById("info-message").innerText = "Error";
                }
            })
            .catch(e => console.error(e));
    }
</script>
</body>
</html>
