package com.cargo.controller;

import java.io.IOException;
import java.time.LocalDate;

import com.cargo.model.CargoModel;
import com.cargo.model.CargoTypeModel;
import com.cargo.service.CargoRegistrationService;
import com.cargo.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * CargoRegistrationController handles cargo registration requests and processes form
 * submissions. It manages cargo creation and registration.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/registerCargo" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50) // 50MB
public class CargoRegistrationController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CargoRegistrationService registrationService = new CargoRegistrationService();

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Check if user is logged in
		String username = (String) req.getSession().getAttribute("username");
		String userRole = (String) req.getSession().getAttribute("role");
		
		// Debug: Print session information
		System.out.println("CargoRegistrationController doGet - Debug Info:");
		System.out.println("Username from session: " + username);
		System.out.println("Role from session: " + userRole);
		
		if (username == null) {
			System.out.println("No username in session - redirecting to login");
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		
		// Check if user is admin - only admins can create cargo
		if (!"admin".equals(userRole)) {
			System.out.println("Access denied - user role is not admin: " + userRole);
			req.setAttribute("error", "Access denied. Only administrators can create new shipments.");
			req.getRequestDispatcher("/WEB-INF/pages/access-denied.jsp").forward(req, resp);
			return;
		}
		
		System.out.println("Admin access granted - proceeding to cargo registration page");
		
		// Generate a cargo number for display purposes
		String generatedCargoNumber = generateCargoNumberPreview();
		req.setAttribute("generatedCargoNumber", generatedCargoNumber);
		req.getRequestDispatcher("/WEB-INF/pages/cargo-register.jsp").forward(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// Check if user is logged in
		String username = (String) req.getSession().getAttribute("username");
		String userRole = (String) req.getSession().getAttribute("role");
		
		// Debug: Print session information
		System.out.println("CargoRegistrationController doPost - Debug Info:");
		System.out.println("Username from session: " + username);
		System.out.println("Role from session: " + userRole);
		
		if (username == null) {
			System.out.println("No username in session - redirecting to login");
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		
		// Check if user is admin - only admins can create cargo
		if (!"admin".equals(userRole)) {
			System.out.println("Access denied in doPost - user role is not admin: " + userRole);
			req.setAttribute("error", "Access denied. Only administrators can create new shipments.");
			req.getRequestDispatcher("/WEB-INF/pages/access-denied.jsp").forward(req, resp);
			return;
		}
		
		System.out.println("Admin access granted in doPost - proceeding with cargo creation");
		
		try {
			// Validate and extract cargo model
			String validationMessage = validateRegistrationForm(req);
			if (validationMessage != null) {
				handleError(req, resp, validationMessage);
				return;
			}

			CargoModel cargoModel = extractCargoModel(req);
			Boolean isAdded = registrationService.addCargo(cargoModel);

			if (isAdded == null) {
				handleError(req, resp, "Our server is under maintenance. Please try again later!");
			} else if (isAdded) {
				// Display success message with generated cargo number
				String successMessage = String.format(
					"Cargo registered successfully! Cargo Number: %s | Your tracking information will be provided shortly.", 
					cargoModel.getCargoNumber()
				);
				req.setAttribute("success", successMessage);
				
				// Generate a new cargo number for the next registration
				String generatedCargoNumber = generateCargoNumberPreview();
				req.setAttribute("generatedCargoNumber", generatedCargoNumber);
				req.getRequestDispatcher("/WEB-INF/pages/cargo-register.jsp").forward(req, resp);
			} else {
				handleError(req, resp, "Registration failed. Please try again!");
			}
		} catch (Exception e) {
			e.printStackTrace();
			handleError(req, resp, "An unexpected error occurred. Please try again!");
		}
	}

	private String validateRegistrationForm(HttpServletRequest req) {
		String cargoNumber = req.getParameter("cargoNumber"); // Not required anymore - will be auto-generated
		String senderName = req.getParameter("senderName");
		String senderAddress = req.getParameter("senderAddress");
		String senderPhone = req.getParameter("senderPhone");
		String receiverName = req.getParameter("receiverName");
		String receiverAddress = req.getParameter("receiverAddress");
		String receiverPhone = req.getParameter("receiverPhone");
		String description = req.getParameter("description");
		String weightStr = req.getParameter("weight");
		String cargoType = req.getParameter("cargoType");
		String shippingCostStr = req.getParameter("shippingCost");

		// Check for null or empty fields (cargo number is no longer required)
		if (ValidationUtil.isNullOrEmpty(senderName))
			return "Sender name is required.";
		if (ValidationUtil.isNullOrEmpty(senderAddress))
			return "Sender address is required.";
		if (ValidationUtil.isNullOrEmpty(senderPhone))
			return "Sender phone is required.";
		if (ValidationUtil.isNullOrEmpty(receiverName))
			return "Receiver name is required.";
		if (ValidationUtil.isNullOrEmpty(receiverAddress))
			return "Receiver address is required.";
		if (ValidationUtil.isNullOrEmpty(receiverPhone))
			return "Receiver phone is required.";
		if (ValidationUtil.isNullOrEmpty(description))
			return "Description is required.";
		if (ValidationUtil.isNullOrEmpty(weightStr))
			return "Weight is required.";
		if (ValidationUtil.isNullOrEmpty(cargoType))
			return "Cargo type is required.";
		if (ValidationUtil.isNullOrEmpty(shippingCostStr))
			return "Shipping cost is required.";

		// Validate phone numbers
		if (!ValidationUtil.isValidPhoneNumber(senderPhone))
			return "Sender phone number must be 10 digits and start with 98.";
		if (!ValidationUtil.isValidPhoneNumber(receiverPhone))
			return "Receiver phone number must be 10 digits and start with 98.";

		// Validate numeric fields
		try {
			double weight = Double.parseDouble(weightStr);
			double shippingCost = Double.parseDouble(shippingCostStr);
			
			if (weight <= 0)
				return "Weight must be greater than 0.";
			if (shippingCost <= 0)
				return "Shipping cost must be greater than 0.";
		} catch (NumberFormatException e) {
			return "Weight and shipping cost must be valid numbers.";
		}

		return null; // All validations pass
	}

	private CargoModel extractCargoModel(HttpServletRequest req) throws Exception {
		// Get the logged-in user
		String loggedInUser = (String) req.getSession().getAttribute("username");
		if (loggedInUser == null) {
			throw new Exception("User must be logged in to create cargo");
		}
		
		// Cargo number will be auto-generated by the service
		String cargoNumber = null; // Set to null to trigger auto-generation
		String senderName = req.getParameter("senderName");
		String senderAddress = req.getParameter("senderAddress");
		String senderPhone = req.getParameter("senderPhone");
		String receiverName = req.getParameter("receiverName");
		String receiverAddress = req.getParameter("receiverAddress");
		String receiverPhone = req.getParameter("receiverPhone");
		String description = req.getParameter("description");
		double weight = Double.parseDouble(req.getParameter("weight"));
		String dimensions = req.getParameter("dimensions");
		String cargoTypeName = req.getParameter("cargoType");
		String status = "Pending"; // Default status
		LocalDate shipmentDate = LocalDate.now();
		
		// Calculate expected delivery date (e.g., 5 days from now)
		LocalDate expectedDeliveryDate = shipmentDate.plusDays(5);
		
		double shippingCost = Double.parseDouble(req.getParameter("shippingCost"));
		String notes = req.getParameter("notes");

		CargoTypeModel cargoTypeModel = new CargoTypeModel(cargoTypeName);
		
		return new CargoModel(cargoNumber, senderName, senderAddress, senderPhone,
				receiverName, receiverAddress, receiverPhone, description, weight,
				dimensions, cargoTypeModel, status, shipmentDate, expectedDeliveryDate,
				shippingCost, null, notes, loggedInUser);
	}

	private void handleError(HttpServletRequest req, HttpServletResponse resp, String message)
			throws ServletException, IOException {
		req.setAttribute("error", message);
		req.setAttribute("cargoNumber", req.getParameter("cargoNumber"));
		req.setAttribute("senderName", req.getParameter("senderName"));
		req.setAttribute("senderAddress", req.getParameter("senderAddress"));
		req.setAttribute("senderPhone", req.getParameter("senderPhone"));
		req.setAttribute("receiverName", req.getParameter("receiverName"));
		req.setAttribute("receiverAddress", req.getParameter("receiverAddress"));
		req.setAttribute("receiverPhone", req.getParameter("receiverPhone"));
		req.setAttribute("description", req.getParameter("description"));
		req.setAttribute("weight", req.getParameter("weight"));
		req.setAttribute("dimensions", req.getParameter("dimensions"));
		req.setAttribute("cargoType", req.getParameter("cargoType"));
		req.setAttribute("shippingCost", req.getParameter("shippingCost"));
		req.setAttribute("notes", req.getParameter("notes"));
		
		// Generate cargo number for display even on error
		String generatedCargoNumber = generateCargoNumberPreview();
		req.setAttribute("generatedCargoNumber", generatedCargoNumber);
		
		req.getRequestDispatcher("/WEB-INF/pages/cargo-register.jsp").forward(req, resp);
	}

	/**
	 * Generates a cargo number preview for display purposes.
	 * This doesn't check for uniqueness as the actual generation will be done by the service.
	 * 
	 * @return A preview cargo number
	 */
	private String generateCargoNumberPreview() {
		return "CG-" + LocalDate.now().getYear() + "-" + String.format("%04d", (int)(Math.random() * 9999) + 1);
	}
}
