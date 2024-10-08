package com.sashaprylutskyy.hashchecker.Servlets;

import com.sashaprylutskyy.hashchecker.DatabaseDAO;
import com.sashaprylutskyy.hashchecker.FetchAPIService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.codec.digest.DigestUtils;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/registration")
public class RegistrationServlet extends HttpServlet {
    private final DatabaseDAO database = DatabaseDAO.getInstance();

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        database.connect();

        PrintWriter out = response.getWriter();

        JSONObject jsonObject = FetchAPIService.getJsonObj(request, response);
        String email = jsonObject.getString("email");
        String password = jsonObject.getString("password");
        String hashed_password = DigestUtils.sha256Hex(password);

        JSONObject jsonResponse = new JSONObject();

        if (isUserExists(email)) {
            sendJSON(jsonResponse, out, "error", "Email is already in taken");
        } else {
            try {
                database.createUser(email, hashed_password);
                sendJSON(jsonResponse, out, "success", "Successfully registered. Please, login");
            } catch (SQLException e) {
                sendJSON(jsonResponse, out, "error", e.getMessage());
            }
        }
    }

    public void sendJSON(JSONObject jsonResponse, PrintWriter out, String status, String message) {
        jsonResponse.put("status", status);
        jsonResponse.put("message", message);
        out.println(jsonResponse);
        out.flush();
    }

    public boolean isUserExists(String email) {
        try {
            ResultSet rs = database.getUser(email);
            if (rs.next()) return true;
        } catch (Exception ignored) {}

        return false;
    }
}
