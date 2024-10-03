<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/auth.css">
</head>
<body>
<%@ include file="templates/header.jsp" %>
<div class="container">
    <h3>LOGIN</h3>

    <h2 id="infoMessage"></h2>
    <form id="loginForm">
        <input type="text" id="email" name="email" placeholder="Enter an email"><br>
        <input type="password" id="password" name="password" placeholder="Enter a password"><br>
        <input type="submit" value="submit" onclick="login()">
    </form>
    <div class="info">
        <p>Don't have an account?</p>
        <a href="/registration">registration</a>
    </div>
</div>

<script>
    function login() {
        event.preventDefault();
        let email = document.getElementById("email").value;
        let password = document.getElementById("password").value;

        fetch("/login", {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({email: email, password: password})
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === "error") {
                    document.getElementById("infoMessage").style.color = "red";
                    document.getElementById("infoMessage").innerHTML = data.message;
                } else {
                    window.location.href = data.redirect;
                }
            })
            .catch(e => console.error(e));
    }
</script>
</body>
</html>