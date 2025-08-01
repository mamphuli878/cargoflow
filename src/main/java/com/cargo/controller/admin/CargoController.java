package com.cargo.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;

import com.cargo.model.CargoModel;
import com.cargo.model.CargoTypeModel;
import com.cargo.service.CargoService;
import com.cargo.util.ValidationUtil;

/**
 * Servlet implementation class CargoController
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/modifyCargo" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50) // 50MB
public class CargoController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// Instance of CargoService for handling business logic
	private CargoService cargoService;

	/**
	 * Default constructor initializes the CargoService instance.
	 */
	public CargoController() {
		this.cargoService = new CargoService();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
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
		
		System.out.println("CargoController: User " + username + " with role " + role + " accessing cargo management");
		
		if (username == null) {
			response.sendRedirect(request.getContextPath() + "/login?error=Please login to access cargo management");
			return;
		}
		
		// Check if user is admin or employee
		if (!"admin".equals(role) && !"employee".equals(role)) {
			request.setAttribute("error", "Access denied. Only administrators and employees can manage cargo.");
			response.sendRedirect(request.getContextPath() + "/userDashboard?error=Access denied. You don't have permission to access cargo management.");
			return;
		}
		
		// Retrieve all cargo information from the CargoService
		request.setAttribute("cargoList", cargoService.getAllCargoInfo());

		request.setAttribute("total", cargoService.getTotalCargo());
		request.setAttribute("pending", cargoService.getPendingCargo());
		request.setAttribute("inTransit", cargoService.getInTransitCargo());
		request.setAttribute("delivered", cargoService.getDeliveredCargo());
		// Forward the request to the cargo JSP for rendering
		request.getRequestDispatcher("/WEB-INF/pages/admin/cargo.jsp").forward(request, response);
	}

	/**
	 * Handles HTTP POST requests for various actions such as update, delete, or
	 * redirecting to the update form. Processes the request parameters based on the
	 * specified action.
	 * 
	 * @param request  The HttpServletRequest object containing the request data.
	 * @param response The HttpServletResponse object used to return the response.
	 * @throws ServletException If an error occurs during request processing.
	 * @throws IOException      If an input or output error occurs.
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// Check if user is logged in and has admin role
		HttpSession session = request.getSession(false);
		String username = null;
		String role = null;
		
		if (session != null) {
			username = (String) session.getAttribute("username");
			role = (String) session.getAttribute("role");
		}
		
		System.out.println("CargoController POST: User " + username + " with role " + role + " performing cargo action");
		
		if (username == null) {
			response.sendRedirect(request.getContextPath() + "/login?error=Please login to perform cargo operations");
			return;
		}
		
		// Check if user is admin or employee
		if (!"admin".equals(role) && !"employee".equals(role)) {
			request.setAttribute("error", "Access denied. Only administrators and employees can perform cargo operations.");
			response.sendRedirect(request.getContextPath() + "/userDashboard?error=Access denied. You don't have permission to perform cargo operations.");
			return;
		}
		
		String action = request.getParameter("action");
		int cargoId = Integer.parseInt(request.getParameter("cargoId"));

		switch (action) {
		case "updateForm":
			handleUpdateForm(request, response, cargoId);
			break;

		case "update":
			handleUpdate(request, response, cargoId);
			break;

		case "delete":
			handleDelete(request, response, cargoId);
			break;

		default:
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
		}
	}

	/**
	 * Handles the update form action by setting cargo data in the session and
	 * redirecting to the update page.
	 * 
	 * @param request   The HttpServletRequest object containing the request data.
	 * @param response  The HttpServletResponse object used to return the response.
	 * @param cargoId The ID of the cargo to be updated.
	 * @throws IOException If an input or output error occurs.
	 */
	private void handleUpdateForm(HttpServletRequest request, HttpServletResponse response, int cargoId)
			throws ServletException, IOException {
		// Redirect to the update URL with cargo ID as parameter
		response.sendRedirect(request.getContextPath() + "/cargoUpdate?id=" + cargoId);
	}

	/**
	 * Handles the update action by processing cargo data and updating it through
	 * the CargoService. Redirects to the dashboard page upon completion.
	 * 
	 * @param request   The HttpServletRequest object containing the request data.
	 * @param response  The HttpServletResponse object used to return the response.
	 * @param cargoId The ID of the cargo to be updated.
	 * @throws ServletException If an error occurs during request processing.
	 * @throws IOException      If an input or output error occurs.
	 */
	private void handleUpdate(HttpServletRequest request, HttpServletResponse response, int cargoId)
			throws ServletException, IOException {
		// Validate form parameters
		String validationMessage = validateUpdateForm(request);
		if (validationMessage != null) {
			request.setAttribute("error", validationMessage);
			doGet(request, response); // Reload the page with the error message
			return;
		}

		// Retrieve form parameters
		String cargoNumber = request.getParameter("cargoNumber");
		String senderName = request.getParameter("senderName");
		String senderAddress = request.getParameter("senderAddress");
		String senderPhone = request.getParameter("senderPhone");
		String receiverName = request.getParameter("receiverName");
		String receiverAddress = request.getParameter("receiverAddress");
		String receiverPhone = request.getParameter("receiverPhone");
		String description = request.getParameter("description");
		double weight = Double.parseDouble(request.getParameter("weight"));
		String dimensions = request.getParameter("dimensions");
		String cargoTypeName = request.getParameter("cargoType");
		String status = request.getParameter("status");
		String shipmentDateStr = request.getParameter("shipmentDate");
		LocalDate shipmentDate = shipmentDateStr != null && !shipmentDateStr.isEmpty() 
			? LocalDate.parse(shipmentDateStr) : null;
		String expectedDeliveryDateStr = request.getParameter("expectedDeliveryDate");
		LocalDate expectedDeliveryDate = expectedDeliveryDateStr != null && !expectedDeliveryDateStr.isEmpty()
			? LocalDate.parse(expectedDeliveryDateStr) : null;
		double shippingCost = Double.parseDouble(request.getParameter("shippingCost"));
		String notes = request.getParameter("notes");

		// Create a CargoTypeModel object
		CargoTypeModel cargoType = new CargoTypeModel();
		cargoType.setName(cargoTypeName);

		// Create a CargoModel object
		CargoModel cargo = new CargoModel(cargoId, cargoNumber, senderName, senderAddress, senderPhone,
				receiverName, receiverAddress, receiverPhone, description, weight, dimensions, cargoType,
				status, shipmentDate, expectedDeliveryDate, null, shippingCost, null, notes);

		// Update the cargo using CargoService
		boolean success = cargoService.updateCargo(cargo);

		// Handle the result of the update operation
		if (success) {
			request.setAttribute("success", "Cargo information updated successfully.");
		} else {
			request.setAttribute("error", "Failed to update cargo information.");
		}

		// Forward to the dashboard to reflect changes
		doGet(request, response);
	}

	/**
	 * Validates the form fields for the update operation.
	 * 
	 * @param request The HttpServletRequest object containing the request data.
	 * @return A validation error message, or null if all validations pass.
	 */
	private String validateUpdateForm(HttpServletRequest request) {
		String cargoNumber = request.getParameter("cargoNumber");
		String senderName = request.getParameter("senderName");
		String receiverName = request.getParameter("receiverName");
		String description = request.getParameter("description");
		String weightStr = request.getParameter("weight");
		String cargoType = request.getParameter("cargoType");
		String status = request.getParameter("status");
		String shippingCostStr = request.getParameter("shippingCost");

		// Check for null or empty fields first
		if (ValidationUtil.isNullOrEmpty(cargoNumber))
			return "Cargo number is required.";
		if (ValidationUtil.isNullOrEmpty(senderName))
			return "Sender name is required.";
		if (ValidationUtil.isNullOrEmpty(receiverName))
			return "Receiver name is required.";
		if (ValidationUtil.isNullOrEmpty(description))
			return "Description is required.";
		if (ValidationUtil.isNullOrEmpty(weightStr))
			return "Weight is required.";
		if (ValidationUtil.isNullOrEmpty(cargoType))
			return "Cargo type is required.";
		if (ValidationUtil.isNullOrEmpty(status))
			return "Status is required.";
		if (ValidationUtil.isNullOrEmpty(shippingCostStr))
			return "Shipping cost is required.";

		// Validate numeric fields
		try {
			Double.parseDouble(weightStr);
			Double.parseDouble(shippingCostStr);
		} catch (NumberFormatException e) {
			return "Weight and shipping cost must be valid numbers.";
		}

		// return null if all validations pass
		return null;
	}

	/**
	 * Handles the delete action by removing a cargo from the database and
	 * forwarding to the dashboard page.
	 * 
	 * @param request   The HttpServletRequest object containing the request data.
	 * @param response  The HttpServletResponse object used to return the response.
	 * @param cargoId The ID of the cargo to be deleted.
	 * @throws ServletException If an error occurs during request processing.
	 * @throws IOException      If an input or output error occurs.
	 */
	private void handleDelete(HttpServletRequest request, HttpServletResponse response, int cargoId)
			throws ServletException, IOException {
		boolean success = cargoService.deleteCargo(cargoId);

		if (success) {
			System.out.println("Deletion successful");
		} else {
			System.out.println("Deletion failed");
		}

		// Forward to the dashboard to reflect changes
		doGet(request, response);
	}
}
