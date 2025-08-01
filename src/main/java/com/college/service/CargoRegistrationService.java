package com.college.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Random;

import com.college.config.DbConfig;
import com.college.model.CargoModel;

/**
 * CargoRegistrationService handles the registration of new cargo shipments. 
 * It manages database interactions for cargo registration.
 */
public class CargoRegistrationService {

	private Connection dbConn;

	/**
	 * Constructor initializes the database connection.
	 */
	public CargoRegistrationService() {
		try {
			this.dbConn = DbConfig.getDbConnection();
		} catch (SQLException | ClassNotFoundException ex) {
			System.err.println("Database connection error: " + ex.getMessage());
			ex.printStackTrace();
		}
	}

	/**
	 * Registers a new cargo shipment in the database.
	 * Automatically generates a unique cargo number if not provided.
	 *
	 * @param cargoModel the cargo details to be registered
	 * @return Boolean indicating the success of the operation
	 */
	public Boolean addCargo(CargoModel cargoModel) {
		if (dbConn == null) {
			System.err.println("Database connection is not available.");
			return null;
		}

		// Generate unique cargo number if not provided or empty
		if (cargoModel.getCargoNumber() == null || cargoModel.getCargoNumber().trim().isEmpty()) {
			String generatedCargoNumber = generateUniqueCargoNumber();
			cargoModel.setCargoNumber(generatedCargoNumber);
		}

		String cargoTypeQuery = "SELECT cargo_type_id FROM cargo_type WHERE name = ?";
		String insertQuery = "INSERT INTO cargo (cargo_number, sender_name, sender_address, sender_phone, "
				+ "receiver_name, receiver_address, receiver_phone, description, weight, dimensions, "
				+ "cargo_type_id, status, shipment_date, expected_delivery_date, shipping_cost, "
				+ "tracking_number, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (PreparedStatement cargoTypeStmt = dbConn.prepareStatement(cargoTypeQuery);
				PreparedStatement insertStmt = dbConn.prepareStatement(insertQuery)) {

			// Fetch cargo type ID
			cargoTypeStmt.setString(1, cargoModel.getCargoType().getName());
			ResultSet result = cargoTypeStmt.executeQuery();
			int cargoTypeId = result.next() ? result.getInt("cargo_type_id") : 1;

			// Use cargo number as tracking number for consistency
			String trackingNumber = cargoModel.getCargoNumber();
			
			System.out.println("Registering cargo with number: " + cargoModel.getCargoNumber());
			System.out.println("Using tracking number: " + trackingNumber);

			// Insert cargo details
			insertStmt.setString(1, cargoModel.getCargoNumber());
			insertStmt.setString(2, cargoModel.getSenderName());
			insertStmt.setString(3, cargoModel.getSenderAddress());
			insertStmt.setString(4, cargoModel.getSenderPhone());
			insertStmt.setString(5, cargoModel.getReceiverName());
			insertStmt.setString(6, cargoModel.getReceiverAddress());
			insertStmt.setString(7, cargoModel.getReceiverPhone());
			insertStmt.setString(8, cargoModel.getDescription());
			insertStmt.setDouble(9, cargoModel.getWeight());
			insertStmt.setString(10, cargoModel.getDimensions());
			insertStmt.setInt(11, cargoTypeId);
			insertStmt.setString(12, cargoModel.getStatus());
			insertStmt.setDate(13, cargoModel.getShipmentDate() != null ? Date.valueOf(cargoModel.getShipmentDate()) : null);
			insertStmt.setDate(14, cargoModel.getExpectedDeliveryDate() != null ? Date.valueOf(cargoModel.getExpectedDeliveryDate()) : null);
			insertStmt.setDouble(15, cargoModel.getShippingCost());
			insertStmt.setString(16, trackingNumber);
			insertStmt.setString(17, cargoModel.getNotes());

			int rowsInserted = insertStmt.executeUpdate();
			return rowsInserted > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Generates a unique tracking number for cargo shipments.
	 * 
	 * @return A unique tracking number
	 */
	private String generateTrackingNumber() {
		Random random = new Random();
		StringBuilder trackingNumber = new StringBuilder("CRG");
		
		// Add current timestamp last 6 digits
		long timestamp = System.currentTimeMillis();
		trackingNumber.append(String.valueOf(timestamp).substring(7));
		
		// Add 3 random digits
		for (int i = 0; i < 3; i++) {
			trackingNumber.append(random.nextInt(10));
		}
		
		return trackingNumber.toString();
	}

	/**
	 * Generates a unique cargo number that doesn't exist in the database.
	 * Format: CG-YYYY-NNNN (e.g., CG-2025-0001)
	 * 
	 * @return A unique cargo number
	 */
	private String generateUniqueCargoNumber() {
		String baseFormat = "CG-" + LocalDate.now().getYear() + "-";
		String cargoNumber;
		int attempts = 0;
		int maxAttempts = 100;

		do {
			// Generate a 4-digit sequence number
			Random random = new Random();
			int sequenceNumber = random.nextInt(9999) + 1; // 1 to 9999
			cargoNumber = baseFormat + String.format("%04d", sequenceNumber);
			attempts++;
			
			// Safety check to prevent infinite loop
			if (attempts >= maxAttempts) {
				// Fallback: use timestamp-based number
				long timestamp = System.currentTimeMillis() % 10000;
				cargoNumber = baseFormat + String.format("%04d", timestamp);
				break;
			}
		} while (isCargoNumberExists(cargoNumber));

		return cargoNumber;
	}

	/**
	 * Checks if a cargo number already exists in the database.
	 * 
	 * @param cargoNumber the cargo number to check
	 * @return true if the cargo number exists, false otherwise
	 */
	private boolean isCargoNumberExists(String cargoNumber) {
		if (dbConn == null) {
			return false;
		}

		String checkQuery = "SELECT COUNT(*) FROM cargo WHERE cargo_number = ?";
		try (PreparedStatement stmt = dbConn.prepareStatement(checkQuery)) {
			stmt.setString(1, cargoNumber);
			ResultSet result = stmt.executeQuery();
			
			if (result.next()) {
				return result.getInt(1) > 0;
			}
		} catch (SQLException e) {
			System.err.println("Error checking cargo number existence: " + e.getMessage());
			e.printStackTrace();
		}
		
		return false;
	}
}
