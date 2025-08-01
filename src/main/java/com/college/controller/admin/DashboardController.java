package com.college.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.college.model.CargoTypeModel;
import com.college.model.CargoModel;
import com.college.service.CargoService;

/**
 * Servlet implementation for handling dashboard-related HTTP requests.
 * 
 * This servlet manages interactions with the CargoService to fetch cargo
 * information, handle updates, and manage cargo data. It forwards requests to
 * appropriate JSP pages or handles POST actions based on the request
 * parameters.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/dashboard" })
public class DashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// Instance of CargoService for handling business logic
	private CargoService cargoService;

	/**
	 * Default constructor initializes the CargoService instance.
	 */
	public DashboardController() {
		this.cargoService = new CargoService();
	}

	/**
	 * Handles HTTP GET requests by retrieving cargo information and forwarding
	 * the request to the dashboard JSP page.
	 * 
	 * @param request  The HttpServletRequest object containing the request data.
	 * @param response The HttpServletResponse object used to return the response.
	 * @throws ServletException If an error occurs during request processing.
	 * @throws IOException      If an input or output error occurs.
	 */
	@Override
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
		
		System.out.println("DashboardController: User " + username + " with role " + role + " accessing admin dashboard");
		
		if (username == null) {
			response.sendRedirect(request.getContextPath() + "/login?error=Please login to access admin dashboard");
			return;
		}
		
		// Check if user is admin or employee
		if (!"admin".equals(role) && !"employee".equals(role)) {
			request.setAttribute("error", "Access denied. Only administrators and employees can access the admin dashboard.");
			request.getRequestDispatcher("/WEB-INF/pages/userDashboard.jsp").forward(request, response);
			return;
		}
		
		// Retrieve all cargo information from the CargoService
		request.setAttribute("cargoList", cargoService.getRecentCargo());

		request.setAttribute("total", cargoService.getTotalCargo());
		request.setAttribute("pending", cargoService.getPendingCargo());
		request.setAttribute("inTransit", cargoService.getInTransitCargo());
		request.setAttribute("delivered", cargoService.getDeliveredCargo());

		// Forward the request to the dashboard JSP for rendering
		request.getRequestDispatcher("/WEB-INF/pages/admin/dashboard.jsp").forward(request, response);
	}

}
