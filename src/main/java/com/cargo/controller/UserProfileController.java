package com.cargo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet implementation class UserProfileController
 * Handles user profile/account management operations
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/profile", "/account" })
public class UserProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Default constructor.
     */
    public UserProfileController() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get user session info (for when authentication is re-enabled)
        HttpSession session = request.getSession(false);
        String username = session != null ? (String) session.getAttribute("username") : "Demo User";
        
        // Set user info for display
        request.setAttribute("username", username != null ? username : "Demo User");
        request.setAttribute("firstName", "John");
        request.setAttribute("lastName", "Doe");
        request.setAttribute("email", "john.doe@example.com");
        request.setAttribute("phone", "+1 (555) 123-4567");
        request.setAttribute("joinDate", "January 15, 2024");
        request.setAttribute("totalShipments", 23);
        request.setAttribute("activeShipments", 3);
        
        request.getRequestDispatcher("/WEB-INF/pages/userProfile.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Handle profile update
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // Here you would typically update the database
        // For now, just set a success message
        request.setAttribute("successMessage", "Profile updated successfully!");
        
        // Redirect back to profile page
        doGet(request, response);
    }
}
