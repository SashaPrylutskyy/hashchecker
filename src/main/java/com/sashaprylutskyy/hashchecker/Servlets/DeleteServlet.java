package com.sashaprylutskyy.hashchecker.Servlets;

import com.sashaprylutskyy.hashchecker.DatabaseDAO;
import com.sashaprylutskyy.hashchecker.FetchAPIService;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/delete")
public class DeleteServlet extends HttpServlet {
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        DatabaseDAO database = DatabaseDAO.getInstance();
        database.connect();

        PrintWriter out = response.getWriter();

        JSONObject jsonObject = FetchAPIService.getJsonObj(request, response);
        int recordID = jsonObject.getInt("recordID");

        JSONObject jsonResponse = new JSONObject();
        try {
            database.deleteRecord(recordID);
            jsonResponse.put("status", "success");
        } catch (Exception e) {
            jsonResponse.put("status", "failed");
        }
        out.println(jsonResponse);
        out.flush();
    }
}
