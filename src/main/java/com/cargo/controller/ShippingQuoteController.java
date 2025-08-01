package com.cargo.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Servlet implementation class ShippingQuoteController
 * Handles shipping quote calculations and estimates
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/quote", "/shipping-quote" })
public class ShippingQuoteController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Default constructor.
     */
    public ShippingQuoteController() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/pages/shippingQuote.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Get form parameters
            String fromCountry = request.getParameter("fromCountry");
            String toCountry = request.getParameter("toCountry");
            String fromCity = request.getParameter("fromCity");
            String toCity = request.getParameter("toCity");
            String shippingType = request.getParameter("shippingType");
            double weight = Double.parseDouble(request.getParameter("weight"));
            double length = Double.parseDouble(request.getParameter("length"));
            double width = Double.parseDouble(request.getParameter("width"));
            double height = Double.parseDouble(request.getParameter("height"));
            
            // Calculate volume and dimensional weight
            double volume = length * width * height / 1000; // Convert to liters
            double dimWeight = volume * 0.2; // Dimensional weight factor
            double chargeableWeight = Math.max(weight, dimWeight);
            
            // Calculate base rates (simplified calculation)
            BigDecimal baseRate = calculateBaseRate(shippingType, chargeableWeight);
            BigDecimal distanceMultiplier = calculateDistanceMultiplier(fromCountry, toCountry);
            BigDecimal totalCost = baseRate.multiply(distanceMultiplier);
            
            // Calculate delivery estimates
            String[] deliveryEstimate = calculateDeliveryTime(shippingType, fromCountry, toCountry);
            
            // Set results
            request.setAttribute("quoteCalculated", true);
            request.setAttribute("fromLocation", fromCity + ", " + fromCountry);
            request.setAttribute("toLocation", toCity + ", " + toCountry);
            request.setAttribute("shippingType", shippingType);
            request.setAttribute("weight", weight);
            request.setAttribute("dimensions", length + " x " + width + " x " + height + " cm");
            request.setAttribute("volume", String.format("%.2f", volume));
            request.setAttribute("chargeableWeight", String.format("%.2f", chargeableWeight));
            request.setAttribute("totalCost", totalCost.setScale(2, RoundingMode.HALF_UP));
            request.setAttribute("deliveryMin", deliveryEstimate[0]);
            request.setAttribute("deliveryMax", deliveryEstimate[1]);
            
            // Set original form values for display
            request.setAttribute("fromCountry", fromCountry);
            request.setAttribute("toCountry", toCountry);
            request.setAttribute("fromCity", fromCity);
            request.setAttribute("toCity", toCity);
            request.setAttribute("selectedShippingType", shippingType);
            request.setAttribute("originalWeight", weight);
            request.setAttribute("originalLength", length);
            request.setAttribute("originalWidth", width);
            request.setAttribute("originalHeight", height);
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error calculating quote. Please check your inputs and try again.");
        }
        
        request.getRequestDispatcher("/WEB-INF/pages/shippingQuote.jsp").forward(request, response);
    }
    
    private BigDecimal calculateBaseRate(String shippingType, double weight) {
        BigDecimal baseRate = BigDecimal.valueOf(10.0); // Base rate
        
        switch (shippingType) {
            case "ground":
                baseRate = BigDecimal.valueOf(8.50);
                break;
            case "express":
                baseRate = BigDecimal.valueOf(15.75);
                break;
            case "overnight":
                baseRate = BigDecimal.valueOf(35.00);
                break;
            case "international":
                baseRate = BigDecimal.valueOf(25.00);
                break;
        }
        
        // Weight multiplier
        return baseRate.multiply(BigDecimal.valueOf(Math.max(1.0, weight * 0.1)));
    }
    
    private BigDecimal calculateDistanceMultiplier(String fromCountry, String toCountry) {
        if (fromCountry.equals(toCountry)) {
            return BigDecimal.valueOf(1.0); // Domestic
        } else {
            return BigDecimal.valueOf(2.5); // International
        }
    }
    
    private String[] calculateDeliveryTime(String shippingType, String fromCountry, String toCountry) {
        boolean international = !fromCountry.equals(toCountry);
        
        switch (shippingType) {
            case "ground":
                return international ? new String[]{"5", "10"} : new String[]{"2", "5"};
            case "express":
                return international ? new String[]{"3", "5"} : new String[]{"1", "3"};
            case "overnight":
                return international ? new String[]{"1", "2"} : new String[]{"1", "1"};
            case "international":
                return new String[]{"7", "14"};
            default:
                return new String[]{"3", "7"};
        }
    }
}
