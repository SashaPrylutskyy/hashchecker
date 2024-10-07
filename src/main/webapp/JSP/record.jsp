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
    session = request.getSession(false);
    String authorizedUser = "";
    if (session != null && session.getAttribute("username") != null) {
        authorizedUser = session.getAttribute("username").toString();
    }

    DatabaseDAO database = DatabaseDAO.getInstance();
    database.connect();

    String recordID = request.getParameter("id");
    if (recordID != null) {
        int id = Integer.parseInt(recordID);
        try {
            ResultSet rs = database.getRecord(id);
            if (rs.next()) {
                int fileSize = rs.getInt("file_size");
                String sizeDisplay = fileSize + " KB";

                // Якщо розмір більше або дорівнює 1024 КБ, переводимо в МБ
                if (fileSize >= 1024) {
                    double fileSizeInMB = fileSize / 1024.0;
                    sizeDisplay = String.format("%.1f MB", fileSizeInMB);
                }
%>
                <div id="file-details" class="file-details">
                    <h2>File: <%= rs.getString("title")%>></h2>
                    <p><strong><%= sizeDisplay%></strong></p>
                    <hr>
                    <p><strong>Uploaded by:</strong> <%= rs.getString("email")%></p>
                    <!--    <p>Uploaded on: 2024-10-06</p>-->
                    <p><strong>Hash:</strong>
                        <i id="hashcode" style="font-family: sans-serif; font-style: normal"><%= rs.getString("hashcode")%></i>
                    </p>

                    <div class="buttons">
                        <input type="file" id="fileInput" style="display: none"/>
<%
                        if (authorizedUser.equals(rs.getString("email"))) {
%>                          <button class="check-btn" onclick="checkHashCode()">Check</button>
                            <button class="delete-btn" onclick="deleteRecord()">🗑</button>
<%
                        } else {
%>                          <button class="check-btn" style="width: 600px" onclick="checkHashCode()">Check</button>
<%
                        }
%>                  </div>
                </div>
                <div class="file-details" id="crosscheck-info" style="display: none">
                    <progress id="progressBar" value="0" max="100" style="width: 100%;"></progress>
                </div>
<%
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
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

    function checkHashCode() {
        document.getElementById("fileInput").click();
    }
    document.getElementById('fileInput').addEventListener('change', function(event) {
        const file = event.target.files[0];
        if (!file) {
            return;
        }

        const progressBar = document.getElementById('progressBar');
        const crosscheckInfo = document.getElementById("crosscheck-info");
        crosscheckInfo.style.display = 'block';
        progressBar.value = 0;
        // document.getElementById('hashOutput').textContent = ''; // Clear previous hash output

        const reader = new FileReader();
        const chunkSize = 1024 * 1024; // 1MB chunk size
        let offset = 0;
        const totalChunks = Math.ceil(file.size / chunkSize);
        let currentChunk = 0;

        const hash = CryptoJS.algo.SHA256.create();

        function readNextChunk() {
            const end = Math.min(offset + chunkSize, file.size);
            const blob = file.slice(offset, end);
            reader.readAsArrayBuffer(blob);
        }

        reader.onload = function(e) {
            const data = new Uint8Array(e.target.result);
            const wordArray = CryptoJS.lib.WordArray.create(data);
            hash.update(wordArray);

            currentChunk++;
            progressBar.value = (currentChunk / totalChunks) * 100;

            offset += chunkSize;
            if (offset < file.size) {
                readNextChunk();
            } else {
                const fileDetails = document.getElementById("file-details");

                const hashcode = hash.finalize().toString();
                const originalHash = document.getElementById("hashcode").innerText;

                if (hashcode === originalHash) {
                    fileDetails.style.border = "3px solid green";
                } else {
                    fileDetails.style.border = "3px solid red";
                }

            }
        };

        readNextChunk();
    });
</script>
</body>
</html>
