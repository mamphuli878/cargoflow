package com.college.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(asyncSupported = true, urlPatterns = "/*")
public class AuthenticationFilter implements Filter {

	private static final String LOGIN = "/login";
	private static final String REGISTER = "/register";
	private static final String HOME = "/home";
	private static final String ROOT = "/";
	private static final String DASHBOARD = "/dashboard";
	private static final String MODIFY_CARGO = "/modifyCargo";
	private static final String CARGO_UPDATE = "/cargoUpdate";
	private static final String REGISTER_CARGO = "/registerCargo";
	private static final String TRACK = "/track";
	private static final String LOGOUT = "/logout";
	private static final String ABOUT = "/about";
	private static final String CONTACT = "/contact";
	private static final String PORTFOLIO = "/portfolio";
	private static final String USER_DASHBOARD = "/userDashboard";
	private static final String SHIPPING_HISTORY = "/shippingHistory";
	private static final String STUDENT_UPDATE = "/studentUpdate";

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// Initialization logic, if required
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		String uri = req.getRequestURI();
		String contextPath = req.getContextPath();
		
		// Remove context path from URI for cleaner matching
		if (uri.startsWith(contextPath)) {
			uri = uri.substring(contextPath.length());
		}
		
		// Allow access to static resources
		if (uri.endsWith(".png") || uri.endsWith(".jpg") || uri.endsWith(".css") || uri.endsWith(".js") 
			|| uri.startsWith("/css/") || uri.startsWith("/resources/")) {
			chain.doFilter(request, response);
			return;
		}
		
		// Get user session information
		HttpSession session = req.getSession(false);
		String username = (session != null) ? (String) session.getAttribute("username") : null;
		String userRole = (session != null) ? (String) session.getAttribute("role") : null;
		boolean isLoggedIn = username != null;

		// Debug info
		System.out.println("Authentication Filter - URI: " + uri + ", Role: " + userRole + ", LoggedIn: " + isLoggedIn + ", Username: " + username);

		// Define admin-only endpoints
		boolean isAdminEndpoint = uri.equals(DASHBOARD) || uri.equals(MODIFY_CARGO) || 
								 uri.equals(CARGO_UPDATE) || uri.equals(SHIPPING_HISTORY) || 
								 uri.equals(STUDENT_UPDATE) || uri.startsWith("/admin/");

		// Define public endpoints (accessible without login)
		boolean isPublicEndpoint = uri.equals(LOGIN) || uri.equals(REGISTER) || uri.equals(HOME) || 
								  uri.equals(ROOT) || uri.equals(ABOUT) || uri.equals(CONTACT) || 
								  uri.equals(PORTFOLIO) || uri.equals(TRACK);

		if (isLoggedIn) {
			// User is logged in
			if ("admin".equals(userRole) || "employee".equals(userRole)) {
				// Admin or Employee - allow access to everything
				if (uri.equals(LOGIN) || uri.equals(REGISTER)) {
					res.sendRedirect(req.getContextPath() + DASHBOARD);
				} else {
					chain.doFilter(request, response);
				}
			} else if ("customer".equals(userRole)) {
				// Customer - restrict access to admin endpoints
				if (uri.equals(LOGIN) || uri.equals(REGISTER)) {
					res.sendRedirect(req.getContextPath() + USER_DASHBOARD);
				} else if (isAdminEndpoint) {
					// Redirect customer trying to access admin endpoints
					System.out.println("Customer attempted to access admin endpoint: " + uri);
					res.sendRedirect(req.getContextPath() + USER_DASHBOARD + "?error=Access denied. You don't have permission to access this page.");
				} else {
					// Allow access to customer endpoints
					chain.doFilter(request, response);
				}
			} else {
				// Unknown role - redirect to login
				res.sendRedirect(req.getContextPath() + LOGIN + "?error=Invalid user role. Please login again.");
			}
		} else {
			// Not logged in
			if (isPublicEndpoint) {
				chain.doFilter(request, response);
			} else if (isAdminEndpoint) {
				// Redirect non-logged users trying to access admin endpoints
				res.sendRedirect(req.getContextPath() + LOGIN + "?error=Please login to access this page.");
			} else {
				// For other protected endpoints, redirect to login
				res.sendRedirect(req.getContextPath() + LOGIN + "?error=Please login to continue.");
			}
		}
			}
		
	

	@Override
	public void destroy() {
		// Cleanup logic, if required
	}
}
