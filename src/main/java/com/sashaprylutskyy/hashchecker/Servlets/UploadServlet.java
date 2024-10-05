package com.sashaprylutskyy.hashchecker.Servlets;

import com.sashaprylutskyy.hashchecker.DatabaseDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;

@WebServlet("/upload")
public class UploadServlet extends HttpServlet {
    private final DatabaseDAO database = DatabaseDAO.getInstance();

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        database.connect();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String email = session.getAttribute("username").toString();

        PrintWriter out = response.getWriter();

        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        String jsonData = sb.toString();
        JSONObject jsonObject = new JSONObject(jsonData);

        String fileName = jsonObject.getString("fileName");
        String hashcode = jsonObject.getString("hashcode");
        int fileSize = jsonObject.getInt("fileSize");

        JSONObject jsonResponse = new JSONObject();
        try {
            ResultSet rs = database.getUser(email);

            if (rs.next()) {
                int userId = rs.getInt(1);

                database.pushRecord(userId, hashcode, fileName, fileSize);
                jsonResponse.put("status", "success");
            } else {
                jsonResponse.put("status", "failed");
            }
        } catch (Exception e) {
            jsonResponse.put("status", "failed");
            jsonResponse.put("message", e.getMessage());
        }

        out.println(jsonResponse);
        out.flush();
    }
}
