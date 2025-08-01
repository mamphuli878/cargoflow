package com.cargo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation for handling Portfolio page requests.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/portfolio" })
public class PortfolioController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * Handles HTTP GET requests for the Portfolio page.
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// Forward to the portfolio page
		request.getRequestDispatcher("/WEB-INF/pages/portfolio.jsp").forward(request, response);
	}
}
