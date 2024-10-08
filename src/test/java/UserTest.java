import com.sashaprylutskyy.hashchecker.DatabaseDAO;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;

import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class UserTest {
    private final String EMAIL = "thisisemailmdhousetobesafe@gmail.com";
    private final String PASSWORD = "0c88cc86a73aa7c4058ff7c0e31d6f105c0ca3575d5a68e060e95d9c84a607a9";

    private DatabaseDAO databaseDAO;

    @BeforeAll
    public void setUp() {
        // Get the singleton instance and connect to the database
        databaseDAO = DatabaseDAO.getInstance();
        databaseDAO.connect();
    }

    @Test
    public void testCreateUser() throws SQLException {
        // Execute the method to test
        databaseDAO.createUser(EMAIL, PASSWORD);

        // Retrieve user to verify the insert
        ResultSet resultSet = databaseDAO.getUser(EMAIL);
        assertTrue(resultSet.next());
        assertEquals(EMAIL, resultSet.getString("email"));
        assertEquals(PASSWORD, resultSet.getString("password"));
    }

    @Test
    public void testGetUser() throws SQLException {
        // Assume a user already exists with the given email and password
        ResultSet resultSet = databaseDAO.getUser(EMAIL, PASSWORD);

        // Check if the result is correct
        if (resultSet.next()) {
            assertEquals(EMAIL, resultSet.getString("email"));
            assertEquals(PASSWORD, resultSet.getString("password"));
        }
    }

    @Test
    public void testPushRecord() throws SQLException {
        int userID = 1;
        String hashcode = "abcd1234";
        String title = "Test File";
        int fileSize = 500;

        // Execute the method to test
        databaseDAO.pushRecord(userID, hashcode, title, fileSize);

        // Retrieve the record to verify the insert
        ResultSet resultSet = databaseDAO.getRecord(userID);
        if (resultSet.next()) {
            assertEquals(userID, resultSet.getInt("userID"));
            assertEquals(hashcode, resultSet.getString("hashcode"));
            assertEquals(title, resultSet.getString("title"));
            assertEquals(fileSize, resultSet.getInt("file_size"));
        }
    }

    @Test
    public void testDeleteUser() throws SQLException {
        // Insert user first
        databaseDAO.createUser(EMAIL, PASSWORD);

        // Delete the user
        databaseDAO.deleteUser(EMAIL, PASSWORD);

        // Verify user deletion
        ResultSet resultSet = databaseDAO.getUser(EMAIL);
        assertFalse(resultSet.next());  // Should not return any result
    }

    @Test
    public void testDeleteRecord() throws SQLException {
        int recordID = 1;

        // Assume a record with recordID = 1 exists
        databaseDAO.deleteRecord(recordID);

        // Verify record deletion
        ResultSet resultSet = databaseDAO.getRecord(recordID);
        assertFalse(resultSet.next());  // Should not return any result
    }
}
