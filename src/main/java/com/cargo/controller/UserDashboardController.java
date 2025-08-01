package com.cargo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.cargo.model.CargoModel;
import com.cargo.service.CargoService;
import com.cargo.service.UserTrackingService;

/**
 * Servlet implementation class UserDashboardController
 * Handles user dashboard operations for customers to track their shipments
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/userDashboard" })
public class UserDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CargoService cargoService;
    private UserTrackingService userTrackingService;
    
    /**
     * Default constructor.
     */
    public UserDashboardController() {
        this.cargoService = new CargoService();
        this.userTrackingService = new UserTrackingService();
    }
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String username = null;
        
        if (session != null) {
            username = (String) session.getAttribute("username");
        }
        
        if (username == null) {
            // User not logged in, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get user's tracking watchlist (tracking numbers they've added)
        List<CargoModel> userWatchlist = userTrackingService.getUserWatchlist(username);
        
        // Debug: Log watchlist size
        System.out.println("UserDashboardController: User " + username + " has " + userWatchlist.size() + " items in watchlist");
        
        // Get summary statistics from watchlist
        int totalTracked = userWatchlist.size();
        int pendingShipments = (int) userWatchlist.stream()
                .filter(cargo -> "Pending".equalsIgnoreCase(cargo.getStatus()))
                .count();
        int inTransitShipments = (int) userWatchlist.stream()
                .filter(cargo -> "In Transit".equalsIgnoreCase(cargo.getStatus()))
                .count();
        int deliveredShipments = (int) userWatchlist.stream()
                .filter(cargo -> "Delivered".equalsIgnoreCase(cargo.getStatus()))
                .count();
        
        // Set attributes for JSP
        request.setAttribute("userWatchlist", userWatchlist);
        request.setAttribute("totalTracked", totalTracked);
        request.setAttribute("pendingShipments", pendingShipments);
        request.setAttribute("inTransitShipments", inTransitShipments);
        request.setAttribute("deliveredShipments", deliveredShipments);
        request.setAttribute("username", username);
        
        // Forward to user dashboard JSP
        request.getRequestDispatcher("/WEB-INF/pages/userDashboard.jsp").forward(request, response);
    }
    
    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String username = null;
        
        if (session != null) {
            username = (String) session.getAttribute("username");
        }
        
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("addTracking".equals(action)) {
            String trackingNumber = request.getParameter("trackingNumber");
            
            if (trackingNumber != null && !trackingNumber.trim().isEmpty()) {
                try {
                    // Add tracking number to user's watchlist
                    Boolean added = userTrackingService.addToWatchlist(username, trackingNumber.trim());
                    
                    if (added == null) {
                        request.setAttribute("error", "System error. Please try again later.");
                    } else if (added) {
                        // Get cargo details for display
                        CargoModel cargo = cargoService.getCargoByTrackingNumber(trackingNumber.trim());
                        if (cargo != null) {
                            request.setAttribute("success", "Tracking ID " + trackingNumber + " added to your watchlist! Current status: " + cargo.getStatus());
                            request.setAttribute("trackedCargo", cargo);
                        } else {
                            request.setAttribute("success", "Tracking ID " + trackingNumber + " added to your watchlist!");
                        }
                    } else {
                        request.setAttribute("error", "Tracking ID '" + trackingNumber + "' not found in our system.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Error adding tracking ID. Please try again.");
                }
            } else {
                request.setAttribute("error", "Please enter a valid tracking ID.");
            }
        } else if ("removeTracking".equals(action)) {
            String trackingNumber = request.getParameter("trackingNumber");
            
            if (trackingNumber != null && !trackingNumber.trim().isEmpty()) {
                try {
                    boolean removed = userTrackingService.removeFromWatchlist(username, trackingNumber.trim());
                    if (removed) {
                        request.setAttribute("success", "Tracking ID " + trackingNumber + " removed from your watchlist.");
                    } else {
                        request.setAttribute("error", "Could not remove tracking ID from watchlist.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("error", "Error removing tracking ID. Please try again.");
                }
            }
        }
        
        // Reload dashboard data
        doGet(request, response);
    }
}
