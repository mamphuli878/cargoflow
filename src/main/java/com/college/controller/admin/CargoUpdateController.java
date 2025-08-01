package com.college.controller.admin;

import java.io.IOException;
import java.time.LocalDate;

import com.college.model.CargoTypeModel;
import com.college.model.CargoModel;
import com.college.service.CargoUpdateService;
import com.college.service.CargoService;
import com.college.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation for handling cargo update operations.
 * 
 * This servlet processes HTTP requests for updating cargo information.
 * It interacts with the CargoUpdateService to perform database operations and 
 * forwards requests to the appropriate JSP page for user interaction.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/cargoUpdate" })
public class CargoUpdateController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Service for updating cargo information
    private CargoUpdateService updateService;
    
    // Service for fetching cargo information
    private CargoService cargoService;

    /**
     * Default constructor initializes the CargoUpdateService and CargoService instances.
     */
    public CargoUpdateController() {
        this.updateService = new CargoUpdateService();
        this.cargoService = new CargoService();
    }

    /**
     * Handles HTTP GET requests by retrieving cargo information from the database 
     * using cargo ID parameter or from the session, and forwarding the request 
     * to the update JSP page.
     * 
     * @param req The HttpServletRequest object containing the request data.
     * @param resp The HttpServletResponse object used to return the response.
     * @throws ServletException If an error occurs during request processing.
     * @throws IOException If an input or output error occurs.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Check if user is logged in and has admin role
        HttpSession session = req.getSession(false);
        String username = null;
        String role = null;
        
        if (session != null) {
            username = (String) session.getAttribute("username");
            role = (String) session.getAttribute("role");
        }
        
        System.out.println("CargoUpdateController: User " + username + " with role " + role + " accessing cargo update");
        
        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login to access cargo update");
            return;
        }
        
        // Check if user is admin or employee
        if (!"admin".equals(role) && !"employee".equals(role)) {
            req.setAttribute("error", "Access denied. Only administrators and employees can update cargo.");
            resp.sendRedirect(req.getContextPath() + "/userDashboard?error=Access denied. You don't have permission to update cargo.");
            return;
        }
        
        CargoModel cargo = null;
        
        // First, try to get cargo from session (in case of form validation errors)
        if (req.getSession().getAttribute("cargo") != null) {
            cargo = (CargoModel) SessionUtil.getAttribute(req, "cargo");
            SessionUtil.removeAttribute(req, "cargo");
        } else {
            // Try to get cargo ID from request parameter
            String cargoIdParam = req.getParameter("id");
            if (cargoIdParam != null && !cargoIdParam.trim().isEmpty()) {
                try {
                    int cargoId = Integer.parseInt(cargoIdParam.trim());
                    cargo = cargoService.getSpecificCargoInfo(cargoId);
                    
                    if (cargo == null) {
                        req.setAttribute("error", "Cargo not found with ID: " + cargoId);
                    }
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "Invalid cargo ID format: " + cargoIdParam);
                }
            } else {
                req.setAttribute("error", "No cargo ID provided. Please select a cargo to update.");
            }
        }
        
        // Set cargo object for the JSP page
        if (cargo != null) {
            req.setAttribute("cargo", cargo);
        }

        // Forward to the cargo update JSP page
        req.getRequestDispatcher("/WEB-INF/pages/admin/cargo-update.jsp").forward(req, resp);
    }

    /**
     * Handles HTTP POST requests for updating cargo information.
     * Retrieves cargo data from the request parameters, updates the cargo record 
     * in the database using CargoUpdateService, and redirects to the dashboard or 
     * handles update failure.
     * 
     * @param req The HttpServletRequest object containing the request data.
     * @param resp The HttpServletResponse object used to return the response.
     * @throws ServletException If an error occurs during request processing.
     * @throws IOException If an input or output error occurs.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        // Check if user is logged in and has admin role
        HttpSession session = req.getSession(false);
        String username = null;
        String role = null;
        
        if (session != null) {
            username = (String) session.getAttribute("username");
            role = (String) session.getAttribute("role");
        }
        
        System.out.println("CargoUpdateController POST: User " + username + " with role " + role + " updating cargo");
        
        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login to update cargo");
            return;
        }
        
        // Check if user is admin or employee
        if (!"admin".equals(role) && !"employee".equals(role)) {
            req.setAttribute("error", "Access denied. Only administrators and employees can update cargo.");
            resp.sendRedirect(req.getContextPath() + "/userDashboard?error=Access denied. You don't have permission to update cargo.");
            return;
        }
        
        try {
            // Validate required parameters first
            String cargoIdStr = req.getParameter("cargoId");
            String weightStr = req.getParameter("weight");
            String shippingCostStr = req.getParameter("shippingCost");
            
            if (cargoIdStr == null || cargoIdStr.trim().isEmpty()) {
                handleUpdateFailure(req, resp, false, "Cargo ID is required.");
                return;
            }
            
            if (weightStr == null || weightStr.trim().isEmpty()) {
                handleUpdateFailure(req, resp, false, "Weight is required.");
                return;
            }
            
            if (shippingCostStr == null || shippingCostStr.trim().isEmpty()) {
                handleUpdateFailure(req, resp, false, "Shipping cost is required.");
                return;
            }
            
            // Parse numeric values
            int cargoId = Integer.parseInt(cargoIdStr.trim());
            double weight = Double.parseDouble(weightStr.trim());
            double shippingCost = Double.parseDouble(shippingCostStr.trim());
            
            // Retrieve other cargo data from request parameters
            String cargoNumber = req.getParameter("cargoNumber");
            String senderName = req.getParameter("senderName");
            String senderAddress = req.getParameter("senderAddress");
            String senderPhone = req.getParameter("senderPhone");
            String receiverName = req.getParameter("receiverName");
            String receiverAddress = req.getParameter("receiverAddress");
            String receiverPhone = req.getParameter("receiverPhone");
            String description = req.getParameter("description");
            String dimensions = req.getParameter("dimensions");
            String status = req.getParameter("status");
            String shipmentDateStr = req.getParameter("shipmentDate");
            String expectedDeliveryDateStr = req.getParameter("expectedDeliveryDate");
            String trackingNumber = req.getParameter("trackingNumber");
            String notes = req.getParameter("notes");
            
            // Parse dates
            LocalDate shipmentDate = null;
            LocalDate expectedDeliveryDate = null;
            
            if (shipmentDateStr != null && !shipmentDateStr.trim().isEmpty()) {
                shipmentDate = LocalDate.parse(shipmentDateStr.trim());
            }
            
            if (expectedDeliveryDateStr != null && !expectedDeliveryDateStr.trim().isEmpty()) {
                expectedDeliveryDate = LocalDate.parse(expectedDeliveryDateStr.trim());
            }

            // Validate required text fields
            if (cargoNumber == null || cargoNumber.trim().isEmpty()) {
                handleUpdateFailure(req, resp, false, "Cargo number is required.");
                return;
            }
            
            if (senderName == null || senderName.trim().isEmpty()) {
                handleUpdateFailure(req, resp, false, "Sender name is required.");
                return;
            }
            
            if (receiverName == null || receiverName.trim().isEmpty()) {
                handleUpdateFailure(req, resp, false, "Receiver name is required.");
                return;
            }
            
            if (status == null || status.trim().isEmpty()) {
                handleUpdateFailure(req, resp, false, "Status is required.");
                return;
            }

            // Create CargoTypeModel object
            CargoTypeModel cargoType = new CargoTypeModel();
            cargoType.setName(req.getParameter("cargoType"));

            // Create CargoModel object with updated data
            CargoModel cargo = new CargoModel(cargoId, cargoNumber.trim(), senderName.trim(), 
                    senderAddress != null ? senderAddress.trim() : "", 
                    senderPhone != null ? senderPhone.trim() : "",
                    receiverName.trim(), 
                    receiverAddress != null ? receiverAddress.trim() : "",
                    receiverPhone != null ? receiverPhone.trim() : "",
                    description != null ? description.trim() : "", 
                    weight, 
                    dimensions != null ? dimensions.trim() : "",
                    cargoType, status.trim(), shipmentDate, expectedDeliveryDate, 
                    null, // actualDeliveryDate 
                    shippingCost, 
                    trackingNumber != null ? trackingNumber.trim() : "",
                    notes != null ? notes.trim() : "");

            // Attempt to update cargo information in the database
            Boolean result = updateService.updateCargoInfo(cargo);
            if (result != null && result) {
                resp.sendRedirect(req.getContextPath() + "/modifyCargo"); // Redirect to dashboard on success
            } else {
                req.getSession().setAttribute("cargo", cargo);
                handleUpdateFailure(req, resp, result, null); // Handle failure
            }
        } catch (NumberFormatException e) {
            handleUpdateFailure(req, resp, false, "Invalid number format. Please check weight and shipping cost values.");
        } catch (Exception e) {
            e.printStackTrace();
            handleUpdateFailure(req, resp, false, "An unexpected error occurred. Please try again.");
        }
    }

    /**
     * Handles update failures by setting an error message and forwarding the request 
     * back to the update page.
     * 
     * @param req The HttpServletRequest object containing the request data.
     * @param resp The HttpServletResponse object used to return the response.
     * @param result Indicates the result of the update operation.
     * @param customMessage Custom error message to display (null to use default).
     * @throws ServletException If an error occurs during request processing.
     * @throws IOException If an input or output error occurs.
     */
    private void handleUpdateFailure(HttpServletRequest req, HttpServletResponse resp, Boolean result, String customMessage)
            throws ServletException, IOException {
        // Determine error message based on update result or use custom message
        String errorMessage;
        if (customMessage != null && !customMessage.trim().isEmpty()) {
            errorMessage = customMessage;
        } else if (result == null) {
            errorMessage = "Our server is under maintenance. Please try again later!";
        } else {
            errorMessage = "Update Failed. Please try again!";
        }
        req.setAttribute("error", errorMessage);
        req.getRequestDispatcher("/WEB-INF/pages/admin/cargo-update.jsp").forward(req, resp);
    }
}
