package com.sashaprylutskyy.hashchecker;

import io.github.cdimascio.dotenv.Dotenv;

import java.sql.*;

public class DatabaseDAO {
    private static DatabaseDAO instance;
    private Connection conn;
    private PreparedStatement stmt;

//    Dotenv env = Dotenv.load();

    private DatabaseDAO() {}

    public static DatabaseDAO getInstance() {
        if (instance == null) {
            instance = new DatabaseDAO();
        }
        return instance;
    }

    public void connect() {
//        final String URL = env.get("DATABASE_URL") + env.get("MYSQL_DATABASE");
//        final String USERNAME = env.get("MYSQL_USERNAME");
//        final String PASSWORD = env.get("MYSQL_ROOT_PASSWORD");

        final String URL = "jdbc:mysql://mysql:3306/hashchecker";
        final String USERNAME = "root";
        final String PASSWORD = "root101";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
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
        String query = "INSERT INTO users (email, password) VALUES (?, ?);";

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

    public ResultSet getUser(String email, String password) throws SQLException {
        String query =  "SELECT * FROM users WHERE email = ? AND password = ?;";

        stmt = conn.prepareStatement(query);
        stmt.setString(1, email);
        stmt.setString(2, password);
        return stmt.executeQuery();
    }

    public void deleteUser(String email, String password) throws SQLException {
        String query = "DELETE FROM users WHERE email = ? AND password = ?;";

        stmt = conn.prepareStatement(query);
        stmt.setString(1, email);
        stmt.setString(2, password);
        stmt.executeUpdate();
    }

    public ResultSet getRecord (int recordID) throws SQLException {
        String query = """
                 SELECT * FROM hashchecker.records
                 JOIN hashchecker.users
                     ON hashchecker.users.id = hashchecker.records.userID
                 WHERE hashchecker.records.id = ?;""";

        stmt = conn.prepareStatement(query);
        stmt.setInt(1, recordID);
        return stmt.executeQuery();
    }

    public ResultSet getUserRecords(String user_email) throws SQLException {
        String query = """
                SELECT * FROM hashchecker.records
                JOIN hashchecker.users
                    ON hashchecker.users.id = hashchecker.records.userID
                WHERE email = ?;""";

        stmt = conn.prepareStatement(query);
        stmt.setString(1, user_email);
        return stmt.executeQuery();
    }

    //TODO
    public void deleteRecord(int recordID) throws SQLException {
        String query = "DELETE FROM records WHERE id = ?;";

        stmt = conn.prepareStatement(query);
        stmt.setInt(1, recordID);
        stmt.executeUpdate();
    }

//    public ResultSet getAllUsers() throws SQLException {
//
//    }
}
