package com.college.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet implementation class LocationsController
 * Handles service locations and branch finder functionality
 */
@WebServlet(asyncSupported = true, urlPatterns = { "/locations", "/find-locations" })
public class LocationsController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Default constructor.
     */
    public LocationsController() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get sample locations data
        List<Map<String, String>> locations = getSampleLocations();
        request.setAttribute("locations", locations);
        
        // Get location search if provided
        String searchCity = request.getParameter("city");
        String searchCountry = request.getParameter("country");
        
        if (searchCity != null && !searchCity.trim().isEmpty()) {
            List<Map<String, String>> filteredLocations = new ArrayList<>();
            for (Map<String, String> location : locations) {
                if (location.get("city").toLowerCase().contains(searchCity.toLowerCase()) ||
                    (searchCountry != null && location.get("country").toLowerCase().contains(searchCountry.toLowerCase()))) {
                    filteredLocations.add(location);
                }
            }
            request.setAttribute("searchResults", filteredLocations);
            request.setAttribute("searchPerformed", true);
            request.setAttribute("searchCity", searchCity);
            request.setAttribute("searchCountry", searchCountry);
        }
        
        request.getRequestDispatcher("/WEB-INF/pages/locations.jsp").forward(request, response);
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private List<Map<String, String>> getSampleLocations() {
        List<Map<String, String>> locations = new ArrayList<>();
        
        // North America
        locations.add(createLocation("New York Hub", "New York", "NY", "United States", 
            "123 Cargo Street", "10001", "+1 (555) 123-4567", "Mon-Fri: 8AM-6PM", "hub"));
        locations.add(createLocation("Los Angeles Distribution Center", "Los Angeles", "CA", "United States",
            "456 Logistics Ave", "90001", "+1 (555) 234-5678", "Mon-Fri: 7AM-7PM", "distribution"));
        locations.add(createLocation("Chicago Regional Office", "Chicago", "IL", "United States",
            "789 Freight Blvd", "60601", "+1 (555) 345-6789", "Mon-Fri: 8AM-5PM", "office"));
        locations.add(createLocation("Toronto Branch", "Toronto", "ON", "Canada",
            "321 Shipping Way", "M5V 3A8", "+1 (416) 555-0123", "Mon-Fri: 8AM-6PM", "branch"));
        
        // Europe
        locations.add(createLocation("London European Hub", "London", "", "United Kingdom",
            "456 Thames Road", "SW1A 1AA", "+44 20 7555 0123", "Mon-Fri: 9AM-5PM", "hub"));
        locations.add(createLocation("Hamburg Port Facility", "Hamburg", "", "Germany",
            "789 Hafen Straße", "20457", "+49 40 555 0123", "24/7 Operations", "port"));
        locations.add(createLocation("Paris Distribution", "Paris", "", "France",
            "123 Rue de la Logistique", "75001", "+33 1 55 55 01 23", "Mon-Fri: 8AM-6PM", "distribution"));
        
        // Asia Pacific
        locations.add(createLocation("Shanghai International Hub", "Shanghai", "", "China",
            "888 Cargo Road", "200000", "+86 21 5555 0123", "24/7 Operations", "hub"));
        locations.add(createLocation("Tokyo Service Center", "Tokyo", "", "Japan",
            "123 Logistics Street", "100-0001", "+81 3 5555 0123", "Mon-Fri: 9AM-6PM", "service"));
        locations.add(createLocation("Sydney Branch Office", "Sydney", "NSW", "Australia",
            "456 Harbor Bridge Rd", "2000", "+61 2 5555 0123", "Mon-Fri: 8AM-5PM", "branch"));
        
        return locations;
    }
    
    private Map<String, String> createLocation(String name, String city, String state, String country,
                                             String address, String zip, String phone, String hours, String type) {
        Map<String, String> location = new HashMap<>();
        location.put("name", name);
        location.put("city", city);
        location.put("state", state);
        location.put("country", country);
        location.put("address", address);
        location.put("zip", zip);
        location.put("phone", phone);
        location.put("hours", hours);
        location.put("type", type);
        return location;
    }
}
