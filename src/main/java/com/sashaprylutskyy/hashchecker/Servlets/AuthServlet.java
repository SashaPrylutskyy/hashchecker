package com.sashaprylutskyy.hashchecker.Servlets;

import com.sashaprylutskyy.hashchecker.DatabaseDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.codec.digest.DigestUtils;

import java.sql.ResultSet;

@WebServlet("/login")
public class AuthServlet extends HttpServlet {
    private DatabaseDAO database = DatabaseDAO.getInstance();

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) {
        database.connect();

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String hashed_password = DigestUtils.sha256Hex(password);
        try {
            ResultSet rs = database.getUser(email, hashed_password);

            if (rs.next()) {
                HttpSession loginSession = request.getSession(true);
                loginSession.setAttribute("username", email);
                response.sendRedirect("/");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
