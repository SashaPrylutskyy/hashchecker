package com.sashaprylutskyy.hashchecker;

import java.sql.*;

public class DatabaseDAO {
    private static DatabaseDAO instance;
    private Connection conn;
    private PreparedStatement stmt;

    private DatabaseDAO() {}

    public static DatabaseDAO getInstance() {
        if (instance == null) {
            instance = new DatabaseDAO();
        }
        return instance;
    }

    public void connect(String username, String password) {
        final String URL = "jdbc:mysql://localhost:3306/hashchecker";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, username, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void pushRecord(int userID, String hashcode, String title, int file_size) throws SQLException {
        String query =  "INSERT INTO records (userID, hashcode, title, file_size) " +
                        "VALUES (?, ?, ?, ?);";

        stmt = conn.prepareStatement(query);
        stmt.setInt(1, userID);
        stmt.setString(2, hashcode);
        stmt.setString(3, title);
        stmt.setInt(4, file_size);

        stmt.executeUpdate();
    }

    public void createUser(String email, String hashed_password) throws SQLException {
        String query =  "INSERT INTO users (email, password) " +
                        "VALUES (?, ?);";

        stmt = conn.prepareStatement(query);
        stmt.setString(1, email);
        stmt.setString(2, hashed_password);
        stmt.executeUpdate();
    }

    public ResultSet getUser(String email) throws SQLException {
        String query =  "SELECT * FROM users WHERE email = ?;";

        stmt = conn.prepareStatement(query);
        stmt.setString(1, email);
        return stmt.executeQuery();
    }
}
