package com.college.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.college.config.DbConfig;
import com.college.model.UserModel;

/**
 * RegisterService handles the registration of new users. It manages database
 * interactions for user registration.
 */
public class RegisterService {

	private Connection dbConn;

	/**
	 * Constructor initializes the database connection.
	 */
	public RegisterService() {
		try {
			this.dbConn = DbConfig.getDbConnection();
		} catch (SQLException | ClassNotFoundException ex) {
			System.err.println("Database connection error: " + ex.getMessage());
			ex.printStackTrace();
		}
	}

	/**
	 * Registers a new user in the database.
	 *
	 * @param userModel the user details to be registered
	 * @return Boolean indicating the success of the operation
	 */
	public Boolean addUser(UserModel userModel) {
		if (dbConn == null) {
			System.err.println("Database connection is not available.");
			return null;
		}

		String insertQuery = "INSERT INTO users (username, password, first_name, last_name, email, phone, role) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?)";

		try (PreparedStatement insertStmt = dbConn.prepareStatement(insertQuery)) {

			// Insert user details
			insertStmt.setString(1, userModel.getUsername());
			insertStmt.setString(2, userModel.getPassword()); // Plain text for now
			insertStmt.setString(3, userModel.getFirstName());
			insertStmt.setString(4, userModel.getLastName());
			insertStmt.setString(5, userModel.getEmail());
			insertStmt.setString(6, userModel.getPhone());
			insertStmt.setString(7, userModel.getRole());

			return insertStmt.executeUpdate() > 0;
		} catch (SQLException e) {
			System.err.println("Error during user registration: " + e.getMessage());
			e.printStackTrace();
			return null;
		}
	}
}
