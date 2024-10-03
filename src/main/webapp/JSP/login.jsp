<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/auth.css">
</head>
<body>
<%@ include file="templates/header.jsp"%>
<div class="container">
    <h3>LOGIN</h3>
    <form action="login" method="post">
        <input type="text" name="email" placeholder="Enter an email"><br>
        <input type="password" name="password" placeholder="Enter a password"><br>
        <input type="submit" value="submit">
    </form>
    <div class="info">
        <p>Don't have an account?</p>
        <a href="/registration">registration</a>
    </div>
</div>
</body>
</html>