package com.college.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.college.config.DbConfig;
import com.college.model.CargoModel;

/**
 * Service class for updating cargo information in the database.
 * 
 * This class provides methods to update cargo details and fetch cargo type IDs
 * from the database. It manages database connections and handles SQL
 * exceptions.
 */
public class CargoUpdateService {

	private Connection dbConn;
	private boolean isConnectionError = false;

	/**
	 * Constructor initializes the database connection. Sets the connection error
	 * flag if the connection fails.
	 */
	public CargoUpdateService() {
		try {
			dbConn = DbConfig.getDbConnection();
		} catch (SQLException | ClassNotFoundException ex) {
			ex.printStackTrace();
			isConnectionError = true;
		}
	}

	/**
	 * Updates cargo information in the database.
	 * 
	 * @param cargoModel The CargoModel object containing updated cargo information.
	 * @return Boolean indicating the success of the update operation. Returns null
	 *         if there is a connection error.
	 */
	public Boolean updateCargoInfo(CargoModel cargoModel) {
		if (isConnectionError) {
			System.out.println("Connection Error!");
			return null;
		}

		// Get cargo type ID first
		int cargoTypeId = getCargoTypeId(cargoModel.getCargoType().getName());

		String updateQuery = "UPDATE cargo SET cargo_number = ?, sender_name = ?, sender_address = ?, "
				+ "sender_phone = ?, receiver_name = ?, receiver_address = ?, receiver_phone = ?, "
				+ "description = ?, weight = ?, dimensions = ?, cargo_type_id = ?, status = ?, "
				+ "shipment_date = ?, expected_delivery_date = ?, shipping_cost = ?, notes = ? "
				+ "WHERE cargo_id = ?";

		try (PreparedStatement stmt = dbConn.prepareStatement(updateQuery)) {
			stmt.setString(1, cargoModel.getCargoNumber());
			stmt.setString(2, cargoModel.getSenderName());
			stmt.setString(3, cargoModel.getSenderAddress());
			stmt.setString(4, cargoModel.getSenderPhone());
			stmt.setString(5, cargoModel.getReceiverName());
			stmt.setString(6, cargoModel.getReceiverAddress());
			stmt.setString(7, cargoModel.getReceiverPhone());
			stmt.setString(8, cargoModel.getDescription());
			stmt.setDouble(9, cargoModel.getWeight());
			stmt.setString(10, cargoModel.getDimensions());
			stmt.setInt(11, cargoTypeId);
			stmt.setString(12, cargoModel.getStatus());
			stmt.setDate(13, cargoModel.getShipmentDate() != null ? Date.valueOf(cargoModel.getShipmentDate()) : null);
			stmt.setDate(14, cargoModel.getExpectedDeliveryDate() != null ? Date.valueOf(cargoModel.getExpectedDeliveryDate()) : null);
			stmt.setDouble(15, cargoModel.getShippingCost());
			stmt.setString(16, cargoModel.getNotes());
			stmt.setInt(17, cargoModel.getCargoId());

			int rowsUpdated = stmt.executeUpdate();
			return rowsUpdated > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * Retrieves the cargo type ID based on the cargo type name.
	 * 
	 * @param cargoTypeName The name of the cargo type.
	 * @return The cargo type ID. Returns 1 (default) if the cargo type is not found
	 *         or if there is a connection error.
	 */
	private int getCargoTypeId(String cargoTypeName) {
		if (isConnectionError) {
			return 1; // Default cargo type ID
		}

		String query = "SELECT cargo_type_id FROM cargo_type WHERE name = ?";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setString(1, cargoTypeName);
			ResultSet result = stmt.executeQuery();

			if (result.next()) {
				return result.getInt("cargo_type_id");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return 1; // Default cargo type ID if not found
	}
}
