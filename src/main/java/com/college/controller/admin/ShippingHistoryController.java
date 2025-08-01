package com.college.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.college.model.CargoModel;
import com.college.service.CargoService;

/**
 * Servlet implementation class ShippingHistoryController
 * Handles admin shipping history requests
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/shippingHistory" })
public class ShippingHistoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CargoService cargoService;
    
    /**
     * Default constructor.
     */
    public ShippingHistoryController() {
        this.cargoService = new CargoService();
    }
    
    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and has admin role
        HttpSession session = request.getSession(false);
        String username = null;
        String role = null;
        
        if (session != null) {
            username = (String) session.getAttribute("username");
            role = (String) session.getAttribute("role");
        }
        
        System.out.println("ShippingHistoryController: User " + username + " with role " + role + " accessing shipping history");
        
        if (username == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check if user is admin
        if (!"admin".equals(role)) {
            request.setAttribute("error", "Access denied. Only administrators can view shipping history.");
            request.getRequestDispatcher("/WEB-INF/pages/access-denied.jsp").forward(request, response);
            return;
        }
        
        try {
            // Get all cargo records for shipping history
            List<CargoModel> allCargo = cargoService.getAllCargoInfo();
            
            System.out.println("ShippingHistoryController: Retrieved " + allCargo.size() + " cargo records");
            
            // Calculate statistics
            int totalShipments = allCargo.size();
            int pendingCount = 0;
            int inTransitCount = 0;
            int deliveredCount = 0;
            int cancelledCount = 0;
            
            for (CargoModel cargo : allCargo) {
                String status = cargo.getStatus();
                if ("Pending".equalsIgnoreCase(status)) {
                    pendingCount++;
                } else if ("In Transit".equalsIgnoreCase(status)) {
                    inTransitCount++;
                } else if ("Delivered".equalsIgnoreCase(status)) {
                    deliveredCount++;
                } else if ("Cancelled".equalsIgnoreCase(status)) {
                    cancelledCount++;
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("allCargo", allCargo);
            request.setAttribute("totalShipments", totalShipments);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("inTransitCount", inTransitCount);
            request.setAttribute("deliveredCount", deliveredCount);
            request.setAttribute("cancelledCount", cancelledCount);
            
            // Forward to shipping history JSP
            request.getRequestDispatcher("/WEB-INF/pages/admin/shipping-history.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading shipping history. Please try again.");
            request.getRequestDispatcher("/WEB-INF/pages/admin/dashboard.jsp").forward(request, response);
        }
    }
}
