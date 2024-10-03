<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/templates.css">
</head>
<body>
<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) { %>
        <div class="header">
            <a href="/" class="logo">Hash Checker</a>
            <div class="header-right">
                <a class="active" href="/login">Authorization</a>
            </div>
        </div>
<% } else { %>
    <div class="header">
        <a href="/" class="logo">Hash Checker</a>
        <div class="header-right">
            <a href="#"><%= session.getAttribute("username").toString()%></a>
            <a class="active" href="/">Uploads</a>
            <a href="/upload">Upload</a>
            <a href="/logout">Log out</a>
        </div>
    </div>
<% } %>

</body>
</html>