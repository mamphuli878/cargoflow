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

@WebServlet("/help")
public class HelpController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("category");
        String searchQuery = request.getParameter("search");
        
        // FAQ categories and questions
        List<Map<String, Object>> allFaqs = getFAQData();
        List<Map<String, Object>> filteredFaqs = allFaqs;
        
        // Filter by category if specified
        if (category != null && !category.isEmpty() && !category.equals("all")) {
            filteredFaqs = allFaqs.stream()
                .filter(faq -> category.equals(faq.get("category")))
                .collect(ArrayList::new, (list, item) -> list.add(item), (list1, list2) -> list1.addAll(list2));
        }
        
        // Filter by search query if specified
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            final String query = searchQuery.toLowerCase().trim();
            filteredFaqs = filteredFaqs.stream()
                .filter(faq -> {
                    String question = ((String) faq.get("question")).toLowerCase();
                    String answer = ((String) faq.get("answer")).toLowerCase();
                    return question.contains(query) || answer.contains(query);
                })
                .collect(ArrayList::new, (list, item) -> list.add(item), (list1, list2) -> list1.addAll(list2));
        }
        
        // Set attributes for JSP
        request.setAttribute("faqs", filteredFaqs);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchPerformed", searchQuery != null || (category != null && !category.equals("all")));
        
        // Forward to help page
        request.getRequestDispatcher("/WEB-INF/pages/help.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle contact form submission from help page
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        // In a real application, you would process the form data
        // For now, just redirect with success message
        request.getSession().setAttribute("helpMessage", "Thank you for contacting us! We'll get back to you within 24 hours.");
        request.getSession().setAttribute("helpMessageType", "success");
        
        response.sendRedirect(request.getContextPath() + "/help");
    }
    
    private List<Map<String, Object>> getFAQData() {
        List<Map<String, Object>> faqs = new ArrayList<>();
        
        // Shipping FAQs
        faqs.add(createFAQ("shipping", "How long does shipping take?", 
            "Shipping times vary by service type and destination. Standard shipping typically takes 3-7 business days, Express shipping takes 1-3 business days, and Overnight shipping delivers the next business day. International shipping can take 7-21 business days depending on the destination and customs processing."));
        
        faqs.add(createFAQ("shipping", "What shipping options are available?", 
            "We offer several shipping options: Standard Ground (3-7 days), Express (1-3 days), Overnight (next business day), International Standard (7-14 days), and International Express (3-7 days). Expedited options are available for urgent shipments."));
        
        faqs.add(createFAQ("shipping", "How can I track my shipment?", 
            "You can track your shipment using your tracking number on our tracking page. Simply enter your tracking number to see real-time updates including pickup, transit, and delivery status. You'll also receive email notifications for major status changes."));
        
        faqs.add(createFAQ("shipping", "What are the weight and size limits?", 
            "Standard packages can weigh up to 150 lbs and have maximum dimensions of 108 inches in length and 165 inches in length plus girth. For larger or heavier items, we offer freight services with custom pricing."));
        
        // Pricing FAQs
        faqs.add(createFAQ("pricing", "How is shipping cost calculated?", 
            "Shipping costs are calculated based on package weight, dimensions, destination distance, and service type. We use dimensional weight pricing for lightweight but bulky packages. You can get an instant quote using our shipping calculator."));
        
        faqs.add(createFAQ("pricing", "Are there any additional fees?", 
            "Standard shipping includes basic coverage. Additional fees may apply for: Signature required delivery, Saturday delivery, Remote area delivery, Declared value coverage above $100, Hazardous materials, and Residential delivery surcharge."));
        
        faqs.add(createFAQ("pricing", "Do you offer volume discounts?", 
            "Yes! We offer significant discounts for high-volume shippers. Business accounts with 50+ shipments per month qualify for tiered discounts up to 30% off standard rates. Contact our sales team for custom enterprise pricing."));
        
        // Account FAQs
        faqs.add(createFAQ("account", "How do I create an account?", 
            "Creating an account is free and easy! Click 'Register' on our homepage, fill out your basic information, verify your email address, and you're ready to start shipping. Business accounts require additional verification for enhanced features."));
        
        faqs.add(createFAQ("account", "I forgot my password, what should I do?", 
            "Click 'Forgot Password' on the login page, enter your email address, and we'll send you a secure link to reset your password. The link expires in 24 hours for security. If you continue having issues, contact our support team."));
        
        faqs.add(createFAQ("account", "How do I update my account information?", 
            "Log into your account and go to 'Profile Settings' where you can update your personal information, shipping addresses, payment methods, and notification preferences. Changes take effect immediately."));
        
        faqs.add(createFAQ("account", "Can I save multiple shipping addresses?", 
            "Yes! You can save unlimited shipping addresses in your account address book. This makes it quick and easy to ship to frequently used addresses without re-entering information each time."));
        
        // Delivery FAQs
        faqs.add(createFAQ("delivery", "What if I'm not home for delivery?", 
            "If you're not available during delivery, our driver will leave a delivery notice with instructions. You can schedule redelivery online, have the package held at a nearby service center for pickup, or authorize delivery to a safe location."));
        
        faqs.add(createFAQ("delivery", "Can I change the delivery address after shipping?", 
            "Address changes are possible for an additional fee if the package hasn't reached the destination facility. Use our online package management tools or contact customer service. Same-day changes aren't always possible."));
        
        faqs.add(createFAQ("delivery", "Do you deliver on weekends?", 
            "Saturday delivery is available for Express and Overnight services for an additional fee. Sunday delivery is available in select metropolitan areas. Standard ground service delivers Monday through Friday."));
        
        // Claims FAQs
        faqs.add(createFAQ("claims", "What if my package is damaged or lost?", 
            "We apologize for any shipping issues! File a claim within 9 months of the ship date. Basic coverage up to $100 is included. For higher-value items, we recommend purchasing additional declared value coverage when shipping."));
        
        faqs.add(createFAQ("claims", "How do I file a claim?", 
            "File claims online through your account dashboard or by calling customer service. You'll need your tracking number, description of damage/loss, and photos if applicable. Most claims are processed within 5-10 business days."));
        
        faqs.add(createFAQ("claims", "What items are prohibited?", 
            "Prohibited items include: Hazardous materials (chemicals, batteries), Weapons and ammunition, Illegal drugs, Perishable food items, Live animals, Cash and negotiable instruments, and Items valued over $50,000 without special arrangements."));
        
        return faqs;
    }
    
    private Map<String, Object> createFAQ(String category, String question, String answer) {
        Map<String, Object> faq = new HashMap<>();
        faq.put("category", category);
        faq.put("question", question);
        faq.put("answer", answer);
        return faq;
    }
}
