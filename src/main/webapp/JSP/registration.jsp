<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="templates/header.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/auth.css">
    <!--    <link rel="stylesheet" href="../CSS/templates.css">-->

</head>
<body>
<div class="container">
    <h3>REGISTRATION</h3>
    <form action="registration" method="post">
        <input type="text" name="email" placeholder="Enter an email"><br>
        <input type="password" name="password" placeholder="Enter a password"><br>
        <input type="password" name="passwordRepeat" placeholder="Repeat the password"><br>
        <input type="submit" value="submit">
    </form>
    <div class="info">
        <p>Have an account?</p>
        <a href="/login">login</a>
    </div>
</div>
</body>
</html>