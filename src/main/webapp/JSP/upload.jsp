<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Upload a file</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/upload.css" />
</head>
<body>
<%@ include file="templates/header.jsp"%>
<div class="container">
    <input type="file" id="file-input" multiple />
    <label for="file-input">
        <i class="fa-solid fa-arrow-up-from-bracket"></i>
        Choose Files To Upload
    </label>
    <div id="num-of-files">No Files Chosen</div>
    <ul id="files-list"></ul>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
<script src="../JS/script.js"></script>
</body>
</html>
