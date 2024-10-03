package com.sashaprylutskyy.hashchecker.Servlets;

import com.sashaprylutskyy.hashchecker.DatabaseDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.codec.digest.DigestUtils;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;

@WebServlet("/login")
public class AuthServlet extends HttpServlet {
    private DatabaseDAO database = DatabaseDAO.getInstance();

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        database.connect();

        PrintWriter out = response.getWriter();

        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        String jsonData = sb.toString();
        JSONObject jsonObject = new JSONObject(jsonData);

        String email = jsonObject.getString("email");
        String password = jsonObject.getString("password");

        String hashed_password = DigestUtils.sha256Hex(password);
        JSONObject jsonResponse = new JSONObject();
        try {
            ResultSet rs = database.getUser(email, hashed_password);

            if (rs.next()) {
                HttpSession loginSession = request.getSession(true);
                loginSession.setAttribute("username", email);
                jsonResponse.put("redirect", "/");

                out.println(jsonResponse);
                out.flush();
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Invalid username or password");

                out.println(jsonResponse);
                out.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
