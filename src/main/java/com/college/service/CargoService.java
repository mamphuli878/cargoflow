package com.college.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.college.config.DbConfig;
import com.college.model.CargoModel;
import com.college.model.CargoTypeModel;

/**
 * Service class for interacting with the database to retrieve cargo-related
 * data. This class handles database connections and performs queries to fetch
 * cargo information.
 */
public class CargoService {

	private Connection dbConn;
	private boolean isConnectionError = false;

	/**
	 * Constructor that initializes the database connection. Sets the connection
	 * error flag if the connection fails.
	 */
	public CargoService() {
		try {
			dbConn = DbConfig.getDbConnection();
		} catch (SQLException | ClassNotFoundException ex) {
			// Log and handle exceptions related to database connection
			ex.printStackTrace();
			isConnectionError = true;
		}
	}

	/**
	 * Retrieves all cargo information from the database.
	 * 
	 * @return A list of CargoModel objects containing cargo data. Returns null
	 *         if there is a connection error or if an exception occurs during query
	 *         execution.
	 */
	public List<CargoModel> getAllCargoInfo() {
		if (isConnectionError) {
			System.out.println("Connection Error!");
			return null;
		}

		// SQL query to fetch cargo details
		String query = "SELECT cargo_id, cargo_number, sender_name, receiver_name, cargo_type_id, status, shipping_cost FROM cargo";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			ResultSet result = stmt.executeQuery();
			List<CargoModel> cargoList = new ArrayList<>();

			while (result.next()) {
				// SQL query to fetch cargo type name based on cargo_type_id
				String cargoTypeQuery = "SELECT cargo_type_id, name FROM cargo_type WHERE cargo_type_id = ?";
				try (PreparedStatement cargoTypeStmt = dbConn.prepareStatement(cargoTypeQuery)) {
					cargoTypeStmt.setInt(1, result.getInt("cargo_type_id"));
					ResultSet cargoTypeResult = cargoTypeStmt.executeQuery();

					CargoTypeModel cargoTypeModel = new CargoTypeModel();
					if (cargoTypeResult.next()) {
						// Set cargo type name in the CargoTypeModel
						cargoTypeModel.setName(cargoTypeResult.getString("name"));
						cargoTypeModel.setCargoTypeId(cargoTypeResult.getInt("cargo_type_id"));
					}

					// Create and add CargoModel to the list
					cargoList.add(new CargoModel(result.getInt("cargo_id"), // Cargo ID
							result.getString("cargo_number"), // Cargo Number
							result.getString("sender_name"), // Sender Name
							result.getString("receiver_name"), // Receiver Name
							cargoTypeModel, // Associated Cargo Type
							result.getString("status"), // Status
							result.getDouble("shipping_cost") // Shipping Cost
					));

					cargoTypeResult.close(); // Close ResultSet to avoid resource leaks
				} catch (SQLException e) {
					// Log and handle exceptions related to cargo type query execution
					e.printStackTrace();
					// Continue to process other cargo or handle this error appropriately
				}
			}
			return cargoList;
		} catch (SQLException e) {
			// Log and handle exceptions related to cargo query execution
			e.printStackTrace();
			return null;
		}
	}

	public CargoModel getSpecificCargoInfo(int cargoId) {
		if (isConnectionError) {
			System.out.println("Connection Error!");
			return null;
		}

		// SQL query to join cargo and cargo_type tables
		String query = "SELECT c.cargo_id, c.cargo_number, c.sender_name, c.sender_address, c.sender_phone, "
				+ "c.receiver_name, c.receiver_address, c.receiver_phone, c.description, c.weight, "
				+ "c.dimensions, c.cargo_type_id, c.status, c.shipment_date, c.expected_delivery_date, "
				+ "c.actual_delivery_date, c.shipping_cost, c.tracking_number, c.notes, "
				+ "ct.name AS cargo_type_name, ct.description AS cargo_type_description, "
				+ "ct.rate_per_kg AS cargo_type_rate, ct.category AS cargo_type_category " + "FROM cargo c "
				+ "JOIN cargo_type ct ON c.cargo_type_id = ct.cargo_type_id " + "WHERE c.cargo_id = ?";

		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setInt(1, cargoId);
			ResultSet result = stmt.executeQuery();
			CargoModel cargo = null;

			if (result.next()) {
				// Extract data from the result set
				int id = result.getInt("cargo_id");
				String cargoNumber = result.getString("cargo_number");
				String senderName = result.getString("sender_name");
				String senderAddress = result.getString("sender_address");
				String senderPhone = result.getString("sender_phone");
				String receiverName = result.getString("receiver_name");
				String receiverAddress = result.getString("receiver_address");
				String receiverPhone = result.getString("receiver_phone");
				String description = result.getString("description");
				double weight = result.getDouble("weight");
				String dimensions = result.getString("dimensions");
				String status = result.getString("status");
				LocalDate shipmentDate = result.getDate("shipment_date") != null 
					? result.getDate("shipment_date").toLocalDate() : null;
				LocalDate expectedDeliveryDate = result.getDate("expected_delivery_date") != null 
					? result.getDate("expected_delivery_date").toLocalDate() : null;
				LocalDate actualDeliveryDate = result.getDate("actual_delivery_date") != null 
					? result.getDate("actual_delivery_date").toLocalDate() : null;
				double shippingCost = result.getDouble("shipping_cost");
				String trackingNumber = result.getString("tracking_number");
				String notes = result.getString("notes");

				// Create CargoTypeModel instance
				CargoTypeModel cargoType = new CargoTypeModel();
				cargoType.setCargoTypeId(result.getInt("cargo_type_id"));
				cargoType.setName(result.getString("cargo_type_name"));
				cargoType.setDescription(result.getString("cargo_type_description"));
				cargoType.setRatePerKg(result.getDouble("cargo_type_rate"));
				cargoType.setCategory(result.getString("cargo_type_category"));

				// Create CargoModel instance
				cargo = new CargoModel(id, cargoNumber, senderName, senderAddress, senderPhone, receiverName,
						receiverAddress, receiverPhone, description, weight, dimensions, cargoType, status,
						shipmentDate, expectedDeliveryDate, actualDeliveryDate, shippingCost, trackingNumber, notes);
			}
			return cargo;
		} catch (SQLException e) {
			// Log and handle exceptions
			e.printStackTrace();
			return null;
		}
	}

	public List<CargoModel> getRecentCargo() {
		if (isConnectionError) {
			System.out.println("Connection Error!");
			return null;
		}

		// SQL query to fetch recent cargo details
		String query = "SELECT cargo_id, cargo_number, sender_name, receiver_name, status "
				+ "FROM cargo ORDER BY cargo_id DESC LIMIT 3";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			ResultSet result = stmt.executeQuery();
			List<CargoModel> cargoList = new ArrayList<>();

			while (result.next()) {
				// Create and add CargoModel to the list
				cargoList.add(new CargoModel(result.getInt("cargo_id"), // Cargo ID
						result.getString("cargo_number"), // Cargo Number
						result.getString("sender_name"), // Sender Name
						result.getString("receiver_name"), // Receiver Name
						result.getString("status") // Status
				));
			}
			return cargoList;
		} catch (SQLException e) {
			// Log and handle exceptions related to cargo query execution
			e.printStackTrace();
			return null;
		}
	}

	public boolean updateCargo(CargoModel cargo) {
		if (isConnectionError)
			return false;

		String updateQuery = "UPDATE cargo SET cargo_number = ?, sender_name = ?, sender_address = ?, "
				+ "sender_phone = ?, receiver_name = ?, receiver_address = ?, receiver_phone = ?, "
				+ "description = ?, weight = ?, dimensions = ?, cargo_type_id = ?, status = ?, "
				+ "shipment_date = ?, expected_delivery_date = ?, shipping_cost = ?, notes = ? WHERE cargo_id = ?";
		
		try (PreparedStatement stmt = dbConn.prepareStatement(updateQuery)) {
			stmt.setString(1, cargo.getCargoNumber());
			stmt.setString(2, cargo.getSenderName());
			stmt.setString(3, cargo.getSenderAddress());
			stmt.setString(4, cargo.getSenderPhone());
			stmt.setString(5, cargo.getReceiverName());
			stmt.setString(6, cargo.getReceiverAddress());
			stmt.setString(7, cargo.getReceiverPhone());
			stmt.setString(8, cargo.getDescription());
			stmt.setDouble(9, cargo.getWeight());
			stmt.setString(10, cargo.getDimensions());
			stmt.setInt(11, getCargoTypeId(cargo.getCargoType().getName()));
			stmt.setString(12, cargo.getStatus());
			stmt.setDate(13, cargo.getShipmentDate() != null ? Date.valueOf(cargo.getShipmentDate()) : null);
			stmt.setDate(14, cargo.getExpectedDeliveryDate() != null ? Date.valueOf(cargo.getExpectedDeliveryDate()) : null);
			stmt.setDouble(15, cargo.getShippingCost());
			stmt.setString(16, cargo.getNotes());
			stmt.setInt(17, cargo.getCargoId());

			int rowsUpdated = stmt.executeUpdate();
			return rowsUpdated > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteCargo(int cargoId) {
		if (isConnectionError)
			return false;

		String deleteQuery = "DELETE FROM cargo WHERE cargo_id = ?";
		try (PreparedStatement stmt = dbConn.prepareStatement(deleteQuery)) {
			stmt.setInt(1, cargoId);
			int rowsDeleted = stmt.executeUpdate();
			return rowsDeleted > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public String getCargoTypeName(int id) {
		if (isConnectionError)
			return "";

		String query = "SELECT name FROM cargo_type WHERE cargo_type_id = ?";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setInt(1, id);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return rs.getString("name");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return "";
	}

	public int getCargoTypeId(String name) {
		if (isConnectionError)
			return 1;

		String query = "SELECT cargo_type_id FROM cargo_type WHERE name = ?";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setString(1, name);
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return rs.getInt("cargo_type_id");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 1; // Default cargo type ID
	}

	public String getTotalCargo() {
		if (isConnectionError)
			return "0";

		String query = "SELECT COUNT(*) as total FROM cargo";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return String.valueOf(rs.getInt("total"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return "0";
	}

	public String getPendingCargo() {
		if (isConnectionError)
			return "0";

		String query = "SELECT COUNT(*) as pending FROM cargo WHERE status = 'Pending'";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return String.valueOf(rs.getInt("pending"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return "0";
	}

	public String getInTransitCargo() {
		if (isConnectionError)
			return "0";

		String query = "SELECT COUNT(*) as in_transit FROM cargo WHERE status = 'In Transit'";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return String.valueOf(rs.getInt("in_transit"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return "0";
	}

	public String getDeliveredCargo() {
		if (isConnectionError)
			return "0";

		String query = "SELECT COUNT(*) as delivered FROM cargo WHERE status = 'Delivered'";
		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			ResultSet rs = stmt.executeQuery();
			if (rs.next()) {
				return String.valueOf(rs.getInt("delivered"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return "0";
	}

	public CargoModel trackCargo(String trackingNumber) {
		if (isConnectionError) {
			System.out.println("Connection Error!");
			return null;
		}

		String query = "SELECT c.cargo_id, c.cargo_number, c.sender_name, c.receiver_name, "
				+ "c.description, c.status, c.shipment_date, c.expected_delivery_date, "
				+ "c.tracking_number, ct.name AS cargo_type_name FROM cargo c "
				+ "JOIN cargo_type ct ON c.cargo_type_id = ct.cargo_type_id "
				+ "WHERE c.tracking_number = ? OR c.cargo_number = ?";

		System.out.println("Tracking cargo with number: " + trackingNumber);

		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setString(1, trackingNumber);
			stmt.setString(2, trackingNumber); // Search both tracking_number and cargo_number
			ResultSet result = stmt.executeQuery();

			if (result.next()) {
				System.out.println("Found cargo in trackCargo: " + result.getString("cargo_number"));
				CargoTypeModel cargoType = new CargoTypeModel();
				cargoType.setName(result.getString("cargo_type_name"));

				return new CargoModel(
					result.getInt("cargo_id"),
					result.getString("cargo_number"),
					result.getString("sender_name"),
					result.getString("receiver_name"),
					cargoType,
					result.getString("status"),
					0.0 // shipping cost not needed for tracking
				);
			} else {
				System.out.println("No cargo found in trackCargo with number: " + trackingNumber);
			}
		} catch (SQLException e) {
			System.out.println("SQL Error in trackCargo: " + e.getMessage());
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Retrieves cargo information for a specific user (customer).
	 * 
	 * @param username The username of the customer whose cargo to retrieve
	 * @return A list of CargoModel objects belonging to the specified user
	 */
	public List<CargoModel> getUserCargo(String username) {
		if (isConnectionError) {
			System.out.println("Connection Error!");
			return new ArrayList<>();
		}

		List<CargoModel> userCargo = new ArrayList<>();
		String query = """
			SELECT c.cargo_id, c.cargo_number, c.sender_name, c.sender_address, c.sender_phone,
				   c.receiver_name, c.receiver_address, c.receiver_phone, c.description,
				   c.weight, c.dimensions, ct.name as cargo_type_name, c.status,
				   c.shipment_date, c.expected_delivery_date, c.actual_delivery_date,
				   c.shipping_cost, c.tracking_number, c.notes, c.created_by
			FROM cargo c
			LEFT JOIN cargo_type ct ON c.cargo_type_id = ct.cargo_type_id
			WHERE c.created_by = ?
			ORDER BY c.shipment_date DESC
		""";

		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setString(1, username);
			
			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					// Create CargoTypeModel
					CargoTypeModel cargoType = new CargoTypeModel();
					cargoType.setName(rs.getString("cargo_type_name"));

					// Create CargoModel
					CargoModel cargo = new CargoModel(
						rs.getInt("cargo_id"),
						rs.getString("cargo_number"),
						rs.getString("sender_name"),
						rs.getString("sender_address"),
						rs.getString("sender_phone"),
						rs.getString("receiver_name"),
						rs.getString("receiver_address"),
						rs.getString("receiver_phone"),
						rs.getString("description"),
						rs.getDouble("weight"),
						rs.getString("dimensions"),
						cargoType,
						rs.getString("status"),
						rs.getDate("shipment_date") != null ? rs.getDate("shipment_date").toLocalDate() : null,
						rs.getDate("expected_delivery_date") != null ? rs.getDate("expected_delivery_date").toLocalDate() : null,
						rs.getDate("actual_delivery_date") != null ? rs.getDate("actual_delivery_date").toLocalDate() : null,
						rs.getDouble("shipping_cost"),
						rs.getString("tracking_number"),
						rs.getString("notes")
					);

					userCargo.add(cargo);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return userCargo;
	}

	/**
	 * Retrieves cargo information by tracking number
	 * 
	 * @param trackingNumber The tracking number to search for
	 * @return CargoModel object if found, null otherwise
	 */
	public CargoModel getCargoByTrackingNumber(String trackingNumber) {
		if (isConnectionError) {
			System.out.println("Connection Error!");
			return null;
		}

		String query = """
			SELECT c.cargo_id, c.cargo_number, c.sender_name, c.sender_address, c.sender_phone,
				   c.receiver_name, c.receiver_address, c.receiver_phone, c.description,
				   c.weight, c.dimensions, ct.name as cargo_type_name, c.status,
				   c.shipment_date, c.expected_delivery_date, c.actual_delivery_date,
				   c.shipping_cost, c.tracking_number, c.notes, c.created_by
			FROM cargo c
			LEFT JOIN cargo_type ct ON c.cargo_type_id = ct.cargo_type_id
			WHERE c.tracking_number = ? OR c.cargo_number = ?
		""";

		System.out.println("Searching for cargo with tracking number or cargo number: " + trackingNumber);

		try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
			stmt.setString(1, trackingNumber);
			stmt.setString(2, trackingNumber); // Search both tracking_number and cargo_number
			
			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					System.out.println("Found cargo: " + rs.getString("cargo_number") + " / " + rs.getString("tracking_number"));
					// Create CargoTypeModel
					CargoTypeModel cargoType = new CargoTypeModel();
					cargoType.setName(rs.getString("cargo_type_name"));

					// Create CargoModel
					return new CargoModel(
						rs.getInt("cargo_id"),
						rs.getString("cargo_number"),
						rs.getString("sender_name"),
						rs.getString("sender_address"),
						rs.getString("sender_phone"),
						rs.getString("receiver_name"),
						rs.getString("receiver_address"),
						rs.getString("receiver_phone"),
						rs.getString("description"),
						rs.getDouble("weight"),
						rs.getString("dimensions"),
						cargoType,
						rs.getString("status"),
						rs.getDate("shipment_date") != null ? rs.getDate("shipment_date").toLocalDate() : null,
						rs.getDate("expected_delivery_date") != null ? rs.getDate("expected_delivery_date").toLocalDate() : null,
						rs.getDate("actual_delivery_date") != null ? rs.getDate("actual_delivery_date").toLocalDate() : null,
						rs.getDouble("shipping_cost"),
						rs.getString("tracking_number"),
						rs.getString("notes")
					);
				} else {
					System.out.println("No cargo found with tracking number or cargo number: " + trackingNumber);
				}
			}
		} catch (SQLException e) {
			System.out.println("SQL Error while searching for cargo: " + e.getMessage());
			e.printStackTrace();
		}

		return null;
	}
}
