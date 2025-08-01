package com.college.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/shipping-history")
public class ShippingHistoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        
        // For demo purposes, we'll show sample data. In real app, query database by username
        String status = request.getParameter("status");
        String timeRange = request.getParameter("timeRange");
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }
        
        // Get shipment history data
        List<Map<String, Object>> allShipments = getSampleShipmentHistory();
        List<Map<String, Object>> filteredShipments = new ArrayList<>(allShipments);
        
        // Filter by status
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            filteredShipments.removeIf(shipment -> !status.equals(shipment.get("status")));
        }
        
        // Filter by time range
        if (timeRange != null && !timeRange.isEmpty() && !timeRange.equals("all")) {
            // For demo, we'll just show all. In real app, filter by date
            // filteredShipments = filterByTimeRange(filteredShipments, timeRange);
        }
        
        // Pagination
        int itemsPerPage = 10;
        int totalItems = filteredShipments.size();
        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
        int startIndex = (page - 1) * itemsPerPage;
        int endIndex = Math.min(startIndex + itemsPerPage, totalItems);
        
        List<Map<String, Object>> pageShipments = totalItems > 0 ? 
            filteredShipments.subList(startIndex, endIndex) : new ArrayList<>();
        
        // Set attributes
        request.setAttribute("shipments", pageShipments);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedTimeRange", timeRange);
        request.setAttribute("hasFilters", (status != null && !status.equals("all")) || 
                                        (timeRange != null && !timeRange.equals("all")));
        
        // Summary statistics
        Map<String, Integer> statusCounts = getStatusCounts(allShipments);
        request.setAttribute("statusCounts", statusCounts);
        
        request.getRequestDispatcher("/WEB-INF/pages/shippingHistory.jsp").forward(request, response);
    }
    
    private List<Map<String, Object>> getSampleShipmentHistory() {
        List<Map<String, Object>> shipments = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd/yyyy HH:mm");
        
        // Recent shipments
        shipments.add(createShipment("TN123456789", "In Transit", "Express", 
            "Electronics", "New York, NY", "Los Angeles, CA", "12/15/2024 10:30", "$45.99", "12/16/2024"));
            
        shipments.add(createShipment("TN123456788", "Delivered", "Standard", 
            "Documents", "Chicago, IL", "Miami, FL", "12/10/2024 14:15", "$12.99", "12/14/2024"));
            
        shipments.add(createShipment("TN123456787", "Delivered", "Overnight", 
            "Medical Supplies", "Seattle, WA", "Portland, OR", "12/08/2024 09:00", "$89.99", "12/09/2024"));
            
        shipments.add(createShipment("TN123456786", "Processing", "Express", 
            "Books", "Dallas, TX", "Houston, TX", "12/14/2024 16:45", "$18.99", "12/17/2024"));
            
        shipments.add(createShipment("TN123456785", "Delivered", "Standard", 
            "Clothing", "Boston, MA", "Washington, DC", "12/05/2024 11:20", "$25.99", "12/09/2024"));
            
        // Older shipments
        shipments.add(createShipment("TN123456784", "Delivered", "Express", 
            "Electronics", "San Francisco, CA", "Denver, CO", "11/28/2024 13:30", "$52.99", "11/30/2024"));
            
        shipments.add(createShipment("TN123456783", "Delivered", "Standard", 
            "Home Goods", "Atlanta, GA", "Nashville, TN", "11/20/2024 10:15", "$31.99", "11/24/2024"));
            
        shipments.add(createShipment("TN123456782", "Delivered", "Overnight", 
            "Legal Documents", "Philadelphia, PA", "New York, NY", "11/15/2024 15:45", "$125.99", "11/16/2024"));
            
        shipments.add(createShipment("TN123456781", "Delivered", "Express", 
            "Art Supplies", "Phoenix, AZ", "Las Vegas, NV", "11/10/2024 12:00", "$38.99", "11/12/2024"));
            
        shipments.add(createShipment("TN123456780", "Delivered", "Standard", 
            "Sports Equipment", "Minneapolis, MN", "Milwaukee, WI", "11/01/2024 09:30", "$44.99", "11/05/2024"));
            
        shipments.add(createShipment("TN123456779", "Delivered", "Express", 
            "Computer Parts", "Austin, TX", "San Antonio, TX", "10/25/2024 14:20", "$29.99", "10/27/2024"));
            
        shipments.add(createShipment("TN123456778", "Cancelled", "Standard", 
            "Furniture", "Detroit, MI", "Cleveland, OH", "10/20/2024 11:45", "$67.99", "Cancelled"));
            
        return shipments;
    }
    
    private Map<String, Object> createShipment(String trackingNumber, String status, String service,
            String contents, String origin, String destination, String shipDate, String cost, String deliveryDate) {
        Map<String, Object> shipment = new HashMap<>();
        shipment.put("trackingNumber", trackingNumber);
        shipment.put("status", status);
        shipment.put("service", service);
        shipment.put("contents", contents);
        shipment.put("origin", origin);
        shipment.put("destination", destination);
        shipment.put("shipDate", shipDate);
        shipment.put("cost", cost);
        shipment.put("deliveryDate", deliveryDate);
        return shipment;
    }
    
    private Map<String, Integer> getStatusCounts(List<Map<String, Object>> shipments) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("total", shipments.size());
        counts.put("delivered", 0);
        counts.put("in-transit", 0);
        counts.put("processing", 0);
        counts.put("cancelled", 0);
        
        for (Map<String, Object> shipment : shipments) {
            String status = (String) shipment.get("status");
            switch (status.toLowerCase()) {
                case "delivered":
                    counts.put("delivered", counts.get("delivered") + 1);
                    break;
                case "in transit":
                    counts.put("in-transit", counts.get("in-transit") + 1);
                    break;
                case "processing":
                    counts.put("processing", counts.get("processing") + 1);
                    break;
                case "cancelled":
                    counts.put("cancelled", counts.get("cancelled") + 1);
                    break;
            }
        }
        
        return counts;
    }
}
