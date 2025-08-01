<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <!-- Display Messages -->
    <c:if test="${not empty error}">
        <div class="container mt-4">
            <div style="background-color: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                ${error}
            </div>
        </div>
    </c:if>
    
    <c:if test="${not empty success}">
        <div class="container mt-4">
            <div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; color: #166534; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                ${success}
            </div>
        </div>
    </c:if>
    
    <main>
        <!-- Hero Section -->
        <section style="background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)); color: white; padding: 4rem 0;">
            <div class="container">
                <div class="text-center">
                    <h1 style="font-size: 3.5rem; font-weight: 700; margin-bottom: 1.5rem; color: white;">
                        Welcome to CargoFlow
                    </h1>
                    <p style="font-size: 1.5rem; margin-bottom: 2rem; opacity: 0.9;">
                        Your trusted partner for global cargo management and logistics solutions
                    </p>
                    <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                        <a href="${contextPath}/register" class="btn btn-success" style="font-size: 1.25rem; padding: 1rem 2rem;">
                            🚀 Get Started Free
                        </a>
                        <a href="${contextPath}/track" class="btn btn-outline" style="color: white; border-color: white; font-size: 1.25rem; padding: 1rem 2rem;">
                            📦 Track Package
                        </a>
                    </div>
                </div>
            </div>
        </section>
        
        <!-- Features Section -->
        <section class="page-container">
            <div class="container">
                <div class="text-center mb-8">
                    <h2 style="font-size: 2.5rem; font-weight: 600; margin-bottom: 1rem;">
                        Why Choose CargoFlow?
                    </h2>
                    <p style="font-size: 1.25rem; color: var(--text-secondary);">
                        Experience the future of cargo management with our cutting-edge platform
                    </p>
                </div>
                
                <div class="grid grid-cols-3 mb-8">
                    <div class="card text-center">
                        <div class="card-body">
                            <div style="font-size: 4rem; color: var(--primary-color); margin-bottom: 1rem;">⚡</div>
                            <h3 class="card-title mb-4">Lightning Fast</h3>
                            <p>Ship your cargo in minutes with our streamlined booking process. Real-time tracking keeps you informed every step of the way.</p>
                        </div>
                    </div>
                    
                    <div class="card text-center">
                        <div class="card-body">
                            <div style="font-size: 4rem; color: var(--success-color); margin-bottom: 1rem;">🌍</div>
                            <h3 class="card-title mb-4">Global Reach</h3>
                            <p>Connect with over 200 countries worldwide. Our extensive network ensures your cargo reaches any destination safely and on time.</p>
                        </div>
                    </div>
                    
                    <div class="card text-center">
                        <div class="card-body">
                            <div style="font-size: 4rem; color: var(--warning-color); margin-bottom: 1rem;">🛡️</div>
                            <h3 class="card-title mb-4">Secure &amp; Safe</h3>
                            <p>Advanced security protocols and comprehensive insurance options protect your valuable cargo throughout its journey.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Statistics -->
                <div class="grid grid-cols-4 mb-8">
                    <div class="card text-center">
                        <div class="card-body">
                            <div style="font-size: 2.5rem; font-weight: bold; color: var(--primary-color); margin-bottom: 0.5rem;">10M+</div>
                            <p class="text-secondary">Packages Delivered</p>
                        </div>
                    </div>
                    <div class="card text-center">
                        <div class="card-body">
                            <div style="font-size: 2.5rem; font-weight: bold; color: var(--success-color); margin-bottom: 0.5rem;">200+</div>
                            <p class="text-secondary">Countries Served</p>
                        </div>
                    </div>
                    <div class="card text-center">
                        <div class="card-body">
                            <div style="font-size: 2.5rem; font-weight: bold; color: var(--warning-color); margin-bottom: 0.5rem;">99.9%</div>
                            <p class="text-secondary">Delivery Success Rate</p>
                        </div>
                    </div>
                    <div class="card text-center">
                        <div class="card-body">
                            <div style="font-size: 2.5rem; font-weight: bold; color: var(--danger-color); margin-bottom: 0.5rem;">24/7</div>
                            <p class="text-secondary">Customer Support</p>
                        </div>
                    </div>
                </div>
                
                <!-- Services Preview -->
                <div class="card mb-8">
                    <div class="card-header">
                        <h2 class="card-title text-center">Our Services</h2>
                    </div>
                    <div class="card-body">
                        <div class="grid grid-cols-2">
                            <div>
                                <h4 class="text-primary mb-3">🚛 Express Delivery</h4>
                                <p class="mb-4">Same-day and next-day delivery options for urgent shipments. Perfect for time-sensitive cargo.</p>
                                
                                <h4 class="text-success mb-3">✈️ International Shipping</h4>
                                <p class="mb-4">Global reach with air and sea freight options. Complete customs and documentation support.</p>
                            </div>
                            <div>
                                <h4 class="text-warning mb-3">📱 Digital Platform</h4>
                                <p class="mb-4">Modern web and mobile platform for easy shipment management and real-time tracking.</p>
                                
                                <h4 class="text-danger mb-3">🏢 Enterprise Solutions</h4>
                                <p class="mb-4">Custom logistics solutions for businesses with volume discounts and dedicated support.</p>
                            </div>
                        </div>
                        <div class="text-center mt-6">
                            <a href="${contextPath}/portfolio" class="btn btn-primary">View All Services</a>
                        </div>
                    </div>
                </div>
                
                <!-- Call to Action -->
                <div class="card" style="background: var(--bg-accent); border: none;">
                    <div class="card-body text-center p-8">
                        <h2 class="mb-4">Ready to Ship Your Cargo?</h2>
                        <p class="mb-6" style="font-size: 1.125rem; color: var(--text-secondary);">
                            Join millions of satisfied customers who trust CargoFlow for their shipping needs.
                        </p>
                        <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                            <a href="${contextPath}/register" class="btn btn-primary" style="font-size: 1.125rem; padding: 1rem 2rem;">
                                Start Shipping Today
                            </a>
                            <a href="${contextPath}/contact" class="btn btn-outline" style="font-size: 1.125rem; padding: 1rem 2rem;">
                                Contact Sales
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
