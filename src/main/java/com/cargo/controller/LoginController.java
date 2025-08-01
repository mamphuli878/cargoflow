package com.cargo.controller;

import java.io.IOException;
import java.sql.SQLException;

import com.cargo.model.UserModel;
import com.cargo.service.LoginService;
import com.cargo.util.CookieUtil;
import com.cargo.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * LoginController is responsible for handling login requests. It interacts with
 * the LoginService to authenticate users.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/login" })
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final LoginService loginService;

	/**
	 * Constructor initializes the LoginService.
	 */
	public LoginController() {
		this.loginService = new LoginService();
	}

	/**
	 * Handles GET requests to the login page.
	 *
	 * @param request  HttpServletRequest object
	 * @param response HttpServletResponse object
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
	}

	/**
	 * Handles POST requests for user login.
	 *
	 * @param request  HttpServletRequest object
	 * @param response HttpServletResponse object
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String username = req.getParameter("username");
		String password = req.getParameter("password");

		UserModel userModel = new UserModel(username, password);
		Boolean loginStatus = loginService.loginUser(userModel);

		if (loginStatus != null && loginStatus) {
			// Get complete user details including role
			UserModel userDetails = null;
			try {
				userDetails = loginService.getUserDetails(username);
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			String userRole = userDetails != null ? userDetails.getRole() : "customer";
			
			// Debug: Print user details
			System.out.println("Login successful for user: " + username);
			System.out.println("User details: " + (userDetails != null ? "Found" : "Not found"));
			System.out.println("User role: " + userRole);
			
			SessionUtil.setAttribute(req, "username", username);
			SessionUtil.setAttribute(req, "role", userRole);
			
			// Debug: Verify session attributes
			System.out.println("Session username: " + req.getSession().getAttribute("username"));
			System.out.println("Session role: " + req.getSession().getAttribute("role"));
			
			// Set role cookie and redirect based on role
			if ("admin".equals(userRole)) {
				CookieUtil.addCookie(resp, "role", "admin", 5 * 30);
				System.out.println("Redirecting admin to dashboard");
				resp.sendRedirect(req.getContextPath() + "/dashboard"); // Admin dashboard
			} else {
				CookieUtil.addCookie(resp, "role", "customer", 5 * 30);
				System.out.println("Redirecting customer to userDashboard");
				resp.sendRedirect(req.getContextPath() + "/userDashboard"); // User dashboard
			}
		} else {
			handleLoginFailure(req, resp, loginStatus);
		}
	}

	/**
	 * Handles login failures by setting attributes and forwarding to the login
	 * page.
	 *
	 * @param req         HttpServletRequest object
	 * @param resp        HttpServletResponse object
	 * @param loginStatus Boolean indicating the login status
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException      if an I/O error occurs
	 */
	private void handleLoginFailure(HttpServletRequest req, HttpServletResponse resp, Boolean loginStatus)
			throws ServletException, IOException {
		String errorMessage;
		if (loginStatus == null) {
			errorMessage = "Our server is under maintenance. Please try again later!";
		} else {
			errorMessage = "User credential mismatch. Please try again!";
		}
		req.setAttribute("error", errorMessage);
		req.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(req, resp);
	}

}