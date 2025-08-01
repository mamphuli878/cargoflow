package com.college.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation for handling Contact Us page requests.
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/contact" })
public class ContactController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * Handles HTTP GET requests for the Contact Us page.
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// Forward to the contact us page
		request.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(request, response);
	}

	/**
	 * Handles HTTP POST requests for the Contact Us form submission.
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		// Get form parameters
		String name = request.getParameter("name");
		String email = request.getParameter("email");
		// String phone = request.getParameter("phone"); // Unused for now
		// String subject = request.getParameter("subject"); // Unused for now
		String message = request.getParameter("message");
		
		// Simple validation
		if (name == null || name.trim().isEmpty() || 
			email == null || email.trim().isEmpty() || 
			message == null || message.trim().isEmpty()) {
			
			request.setAttribute("error", "Please fill in all required fields.");
			request.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(request, response);
			return;
		}
		
		// For now, just show a success message
		// In a real application, you would save this to database or send an email
		request.setAttribute("success", "Thank you for your message! We will get back to you soon.");
		request.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(request, response);
	}
}
