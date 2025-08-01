package com.cargo.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.cargo.config.DbConfig;
import com.cargo.model.UserModel;
import com.cargo.util.PasswordUtil;

/**
 * Service class for handling login operations. Connects to the database,
 * verifies user credentials, and returns login status.
 */
public class LoginService {

	private Connection dbConn;
	private boolean isConnectionError = false;

	/**
	 * Constructor initializes the database connection. Sets the connection error
	 * flag if the connection fails.
	 */
	public LoginService() {
		try {
			dbConn = DbConfig.getDbConnection();
		} catch (SQLException | ClassNotFoundException ex) {
			ex.printStackTrace();
			isConnectionError = true;
		}
	}

	/**
	 * Validates the user credentials against the database records.
	 *
	 * @param userModel the UserModel object containing user credentials
	 * @return true if the user credentials are valid, false otherwise; null if a
	 *         connection error occurs
	 */
	public Boolean loginUser(UserModel userModel) {
		if (isConnectionError) {
			System.out.println("Connection Error!");
			return null;
		}

		String query = "SELECT username, password, role FROM users WHERE username = ?";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setString(1, userModel.getUsername());
			ResultSet result = stmt.executeQuery();

			if (result.next()) {
				return validatePassword(result, userModel);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}

		return false;
	}

	/**
	 * Gets user details including role from the database.
	 *
	 * @param username the username to look up
	 * @return UserModel with complete user details, null if user not found or error occurs
	 * @throws SQLException 
	 * @throws ClassNotFoundException 
	 */
	public UserModel getUserDetails(String username) throws ClassNotFoundException, SQLException {
		Connection dbConn = DbConfig.getDbConnection();
		String query = "SELECT username, first_name, last_name, email, phone, role FROM users WHERE username = ?";
		
		System.out.println("Getting user details for: " + username);
		
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setString(1, username);
			ResultSet result = stmt.executeQuery();

			if (result.next()) {
				UserModel user = new UserModel();
				user.setUsername(result.getString("username"));
				user.setFirstName(result.getString("first_name"));
				user.setLastName(result.getString("last_name"));
				user.setEmail(result.getString("email"));
				user.setPhone(result.getString("phone"));
				user.setRole(result.getString("role"));
				
				System.out.println("Found user details:");
				System.out.println("Username: " + user.getUsername());
				System.out.println("Role: " + user.getRole());
				
				return user;
			} else {
				System.out.println("No user found with username: " + username);
			}
		} catch (SQLException e) {
			System.out.println("Error getting user details: " + e.getMessage());
			e.printStackTrace();
		}

		return null;
	}

	/**
	 * Validates the password retrieved from the database.
	 *
	 * @param result       the ResultSet containing the username and password from
	 *                     the database
	 * @param userModel the UserModel object containing user credentials
	 * @return true if the passwords match, false otherwise
	 * @throws SQLException if a database access error occurs
	 */
	private boolean validatePassword(ResultSet result, UserModel userModel) throws SQLException {
		String dbUsername = result.getString("username");
		String dbPassword = result.getString("password");

		// Decrypt the stored password and compare with the plain text password
		String decryptedPassword = PasswordUtil.decrypt(dbPassword, dbUsername);
		
		// Check if decryption was successful and passwords match
		return dbUsername.equals(userModel.getUsername())
				&& decryptedPassword != null 
				&& decryptedPassword.equals(userModel.getPassword());
	}
}