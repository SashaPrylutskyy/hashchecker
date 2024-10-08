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
<div id="container" class="container">
    <h3>REGISTRATION</h3>

    <h2 id="infoMessage"></h2>
    <form id="registrationForm" onsubmit="createUser(event)">
        <input type="text" id="email" name="email" placeholder="Enter an email" pattern=".+@.+.+" required><br>
        <input type="password" id="password" name="password" placeholder="Enter a password" pattern=".{8,}" required><br>
        <input type="password" id="passwordRepeat" name="passwordRepeat" placeholder="Repeat the password" pattern=".{8,}" required><br>
        <input type="submit" value="submit">
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
        let container = document.getElementById("container");
        let infoMessage = document.getElementById("infoMessage");

        if (password !== passwordRepeat) {
            container.classList.add("error");
            container.style.display = "block";
            infoMessage.innerHTML = "Passwords don't match";
        } else {
            fetch("/registration", {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({email: email, password: password})
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === "error") {
                        container.style.display = "block";
                    } else if (data.status === "success") {
                        document.getElementById("email").innerHTML = "";
                        document.getElementById("password").innerHTML = "";
                        document.getElementById("passwordRepeat").innerHTML = "";

                        container.classList.add("success");
                        infoMessage.innerHTML = data.message;
                    }
                    container.classList.add("error");
                    infoMessage.innerHTML = data.message;
                })
                .catch(e => {
                    container.style.display = "block";
                    container.classList.add("error");
                    infoMessage.innerHTML = "Couldn't reach the database";
                });
        }
    }
</script>
</body>
</html>