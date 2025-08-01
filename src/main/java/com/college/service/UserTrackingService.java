package com.college.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.college.config.DbConfig;
import com.college.model.CargoModel;

/**
 * Service class for managing user tracking watchlist.
 * Allows users to add tracking numbers to their personal watchlist.
 */
public class UserTrackingService {

    private Connection dbConn;
    private boolean isConnectionError = false;

    /**
     * Constructor initializes the database connection.
     */
    public UserTrackingService() {
        try {
            dbConn = DbConfig.getDbConnection();
        } catch (SQLException | ClassNotFoundException ex) {
            ex.printStackTrace();
            isConnectionError = true;
        }
    }

    /**
     * Adds a tracking number to user's watchlist
     * 
     * @param username The username of the user
     * @param trackingNumber The tracking number to add
     * @return Boolean - true if added successfully, false if failed, null if connection error
     */
    public Boolean addToWatchlist(String username, String trackingNumber) {
        if (isConnectionError) {
            System.out.println("Connection Error!");
            return null;
        }

        System.out.println("UserTrackingService: Adding to watchlist - User: " + username + ", Tracking: " + trackingNumber);

        // First check if the cargo exists to get cargo_number
        CargoService cargoService = new CargoService();
        CargoModel cargo = cargoService.getCargoByTrackingNumber(trackingNumber);
        
        String cargoNumber = null;
        if (cargo != null) {
            cargoNumber = cargo.getCargoNumber();
            System.out.println("UserTrackingService: Found cargo - " + cargoNumber);
        } else {
            System.out.println("UserTrackingService: Cargo not found, but allowing user to add to watchlist anyway");
        }

        // Check if user already has this tracking number in watchlist
        if (isInWatchlist(username, trackingNumber)) {
            System.out.println("UserTrackingService: Already in watchlist");
            return true; // Already in watchlist, consider it success
        }

        String query = "INSERT INTO user_watchlist (username, tracking_number, cargo_number, added_date) VALUES (?, ?, ?, NOW())";
        
        System.out.println("UserTrackingService: Inserting into watchlist - tracking_number: " + trackingNumber + ", cargo_number: " + cargoNumber);
        
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, trackingNumber);
            stmt.setString(3, cargoNumber); // Can be null if cargo doesn't exist yet
            
            int result = stmt.executeUpdate();
            System.out.println("UserTrackingService: Insert result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.out.println("UserTrackingService: Error inserting into watchlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Checks if a tracking number is already in user's watchlist
     * 
     * @param username The username
     * @param trackingNumber The tracking number
     * @return true if in watchlist, false otherwise
     */
    /**
     * Checks if a tracking number is already in user's watchlist
     * 
     * @param username The username
     * @param trackingNumber The tracking number
     * @return true if already in watchlist, false otherwise
     */
    public boolean isInWatchlist(String username, String trackingNumber) {
        if (isConnectionError) {
            return false;
        }

        System.out.println("UserTrackingService: Checking if in watchlist - User: " + username + ", Tracking: " + trackingNumber);

        // Check both tracking_number and cargo_number fields to handle both cases
        String query = "SELECT COUNT(*) FROM user_watchlist WHERE username = ? AND (tracking_number = ? OR cargo_number = ?)";
        
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, trackingNumber);
            stmt.setString(3, trackingNumber); // Check cargo_number as well
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("UserTrackingService: Found " + count + " entries in watchlist for this tracking number");
                    return count > 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("UserTrackingService: Error checking watchlist: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    /**
     * Gets all tracking numbers from user's watchlist with current status
     * 
     * @param username The username
     * @return List of CargoModel objects that user is tracking
     */
    public List<CargoModel> getUserWatchlist(String username) {
        if (isConnectionError) {
            return new ArrayList<>();
        }

        List<CargoModel> watchlist = new ArrayList<>();
        CargoService cargoService = new CargoService();
        
        String query = "SELECT tracking_number, cargo_number FROM user_watchlist WHERE username = ? ORDER BY added_date DESC";
        
        System.out.println("UserTrackingService: Getting watchlist for user: " + username);
        
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String trackingNumber = rs.getString("tracking_number");
                    String cargoNumber = rs.getString("cargo_number");
                    
                    // Try to get cargo details using tracking number
                    CargoModel cargo = cargoService.getCargoByTrackingNumber(trackingNumber);
                    
                    if (cargo != null) {
                        watchlist.add(cargo);
                        System.out.println("UserTrackingService: Added cargo to watchlist: " + cargo.getCargoNumber());
                    } else {
                        // If cargo not found, create a minimal cargo object for display
                        CargoModel placeholderCargo = new CargoModel();
                        placeholderCargo.setCargoNumber(cargoNumber != null ? cargoNumber : trackingNumber);
                        placeholderCargo.setStatus("Not Found");
                        placeholderCargo.setDescription("Cargo not found in system");
                        watchlist.add(placeholderCargo);
                        System.out.println("UserTrackingService: Added placeholder cargo: " + trackingNumber);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("UserTrackingService: Error getting watchlist: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("UserTrackingService: Returning " + watchlist.size() + " items in watchlist");
        return watchlist;
    }

    /**
     * Removes a tracking number from user's watchlist
     * 
     * @param username The username
     * @param trackingNumber The tracking number to remove
     * @return true if removed successfully, false otherwise
     */
    public boolean removeFromWatchlist(String username, String trackingNumber) {
        if (isConnectionError) {
            return false;
        }

        System.out.println("UserTrackingService: Removing from watchlist - User: " + username + ", Tracking: " + trackingNumber);

        String query = "DELETE FROM user_watchlist WHERE username = ? AND (tracking_number = ? OR cargo_number = ?)";
        
        try (PreparedStatement stmt = dbConn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, trackingNumber);
            stmt.setString(3, trackingNumber); // Remove by either tracking_number or cargo_number
            
            int result = stmt.executeUpdate();
            System.out.println("UserTrackingService: Remove result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.out.println("UserTrackingService: Error removing from watchlist: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
