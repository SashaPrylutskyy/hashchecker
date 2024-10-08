<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/auth.css">
</head>
<body>
<%@ include file="templates/header.jsp" %>
<div id="container" class="container">
    <h3>LOGIN</h3>

    <h2 id="infoMessage"></h2>
    <form id="loginForm" onsubmit="login(event)">
        <input type="text" id="email" name="email" placeholder="Enter an email" pattern=".+@.+.+" required><br>
        <input type="password" id="password" name="password" placeholder="Enter a password" pattern=".{8,}" required><br>
        <input type="submit" value="submit">
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
        let container = document.getElementById("container");
        let infoMessage = document.getElementById("infoMessage");

        fetch("/login", {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({email: email, password: password})
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === "error") {
                    container.classList.add("error");
                    infoMessage.innerHTML = data.message;
                    container.style.display = "block";
                } else {
                    window.location.href = data.redirect;
                }
            })
            .catch(e => {
                container.classList.add("error");
                infoMessage.innerHTML = "Couldn't reach the database";
                container.style.display = "block";
            });
    }
</script>
</body>
</html>