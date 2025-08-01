<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-section">
                <h3>CargoFlow</h3>
                <p>Your trusted partner for reliable and efficient cargo management solutions worldwide.</p>
                <p>Delivering excellence since 2020.</p>
            </div>
            
            <div class="footer-section">
                <h3>Quick Links</h3>
                <a href="${contextPath}/home">Home</a>
                <a href="${contextPath}/about">About Us</a>
                <a href="${contextPath}/portfolio">Our Services</a>
                <a href="${contextPath}/track">Track Cargo</a>
                <a href="${contextPath}/contact">Contact Us</a>
            </div>
            
            <div class="footer-section">
                <h3>Services</h3>
                <a href="#">Express Delivery</a>
                <a href="#">International Shipping</a>
                <a href="#">Cargo Insurance</a>
                <a href="#">Warehouse Solutions</a>
                <a href="#">Custom Clearance</a>
            </div>
            
            <div class="footer-section">
                <h3>Contact Info</h3>
                <p>📍 123 Cargo Street, Logistics City, LC 12345</p>
                <p>📞 +1 (555) 123-4567</p>
                <p>✉️ info@cargoflow.com</p>
                <p>🕒 24/7 Customer Support</p>
            </div>
        </div>
        
        <div class="footer-bottom">
            <p>&copy; 2025 CargoFlow Management System. All rights reserved. | Privacy Policy | Terms of Service</p>
        </div>
    </div>
</footer>