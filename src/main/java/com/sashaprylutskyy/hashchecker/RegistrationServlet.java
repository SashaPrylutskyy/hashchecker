package com.sashaprylutskyy.hashchecker;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.codec.digest.DigestUtils;

import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/registration")
public class RegistrationServlet extends HttpServlet {
    private final DatabaseDAO database = DatabaseDAO.getInstance();

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        database.connect("root", "");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String passwordRepeat = request.getParameter("passwordRepeat");

        if (isUserExists(email)) {
            System.out.println("Email is already in taken");
        }

        else if (password.equals(passwordRepeat)) {
            String hashed_password = DigestUtils.sha256Hex(password);

            try {
                database.createUser(email, hashed_password);
                System.out.println("Successfully registered. Please, login");
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else {
            System.out.println("passwords do not match");
        }
    }

    public boolean isUserExists(String email) {
        try {
            ResultSet rs = database.getUser(email);
            if (rs.next()) return true;
        } catch (Exception ignored) {}

        return false;
    }
}
