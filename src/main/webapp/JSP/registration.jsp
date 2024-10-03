<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="templates/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/CSS/auth.css">
</head>
<body>
<div class="container">
    <h3>REGISTRATION</h3>

    <h2 id="infoMessage"></h2>
    <form id="registrationForm">
        <input type="text" id="email" name="email" placeholder="Enter an email"><br>
        <input type="password" id="password" name="password" placeholder="Enter a password"><br>
        <input type="password" id="passwordRepeat" name="passwordRepeat" placeholder="Repeat the password"><br>
        <input type="submit" value="submit" onclick="createUser()">
    </form>
    <div class="info">
        <p>Have an account?</p>
        <a href="/login">login</a>
    </div>
</div>

<script>
    function createUser() {
        event.preventDefault();
        let email = document.getElementById("email").value;
        let password = document.getElementById("password").value;
        let passwordRepeat = document.getElementById("passwordRepeat").value;

        if (password !== passwordRepeat) {
            document.getElementById("infoMessage").style.color = "red";
            document.getElementById("infoMessage").innerHTML = "Passwords don't match";
        } else {
            fetch("/registration", {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({email: email, password: password})
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === "error") {
                        document.getElementById("infoMessage").style.color = "red";
                    } else if (data.status === "success") {
                        document.getElementById("email").innerHTML = "";
                        document.getElementById("password").innerHTML = "";
                        document.getElementById("passwordRepeat").innerHTML = "";
                        document.getElementById("infoMessage").style.color = "#425e50";
                    }
                    document.getElementById("infoMessage").innerHTML = data.message;
                })
                .catch(e => console.error(e));
        }
    }
</script>
</body>
</html>