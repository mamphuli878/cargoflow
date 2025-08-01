<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">About CargoFlow</h1>
                <p class="page-subtitle">Leading the future of cargo management with innovation and reliability</p>
            </div>
            
            <div class="grid grid-cols-1 mb-8">
                <div class="card">
                    <div class="card-body">
                        <h2 class="text-center mb-6 text-primary" style="font-size: 2rem;">Our Story</h2>
                        <p style="font-size: 1.125rem; line-height: 1.8; text-align: center; color: var(--text-secondary);">
                            Founded in 2020, CargoFlow has revolutionized the cargo management industry with cutting-edge 
                            technology and unparalleled customer service. We've grown from a small startup to a global 
                            leader in logistics solutions, handling millions of shipments worldwide.
                        </p>
                    </div>
                </div>
            </div>
            
            <div class="grid grid-cols-3 mb-8">
                <div class="card">
                    <div class="card-body text-center">
                        <div style="font-size: 3rem; color: var(--primary-color); margin-bottom: 1rem;">🚛</div>
                        <h3 class="card-title mb-4">Our Mission</h3>
                        <p>To provide seamless, efficient, and reliable cargo management solutions that connect businesses 
                        and individuals across the globe, making logistics simple and accessible for everyone.</p>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-body text-center">
                        <div style="font-size: 3rem; color: var(--success-color); margin-bottom: 1rem;">🎯</div>
                        <h3 class="card-title mb-4">Our Vision</h3>
                        <p>To be the world's most trusted cargo management platform, leading innovation in logistics 
                        technology and setting new standards for customer satisfaction and operational excellence.</p>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-body text-center">
                        <div style="font-size: 3rem; color: var(--warning-color); margin-bottom: 1rem;">⭐</div>
                        <h3 class="card-title mb-4">Our Values</h3>
                        <p>Integrity, Innovation, Reliability, and Customer-centricity drive everything we do. 
                        We believe in transparent operations, continuous improvement, and building lasting relationships.</p>
                    </div>
                </div>
            </div>
            
            <div class="card mb-8">
                <div class="card-header">
                    <h2 class="card-title">Why Choose CargoFlow?</h2>
                </div>
                <div class="card-body">
                    <div class="grid grid-cols-2">
                        <div>
                            <h4 class="text-primary mb-3">🔒 Security & Safety</h4>
                            <ul style="list-style: none; padding: 0;">
                                <li style="margin-bottom: 0.5rem;">✓ End-to-end cargo tracking</li>
                                <li style="margin-bottom: 0.5rem;">✓ Secure handling protocols</li>
                                <li style="margin-bottom: 0.5rem;">✓ Insurance coverage options</li>
                                <li style="margin-bottom: 0.5rem;">✓ 24/7 monitoring systems</li>
                            </ul>
                        </div>
                        <div>
                            <h4 class="text-success mb-3">⚡ Speed & Efficiency</h4>
                            <ul style="list-style: none; padding: 0;">
                                <li style="margin-bottom: 0.5rem;">✓ Express delivery options</li>
                                <li style="margin-bottom: 0.5rem;">✓ Optimized routing algorithms</li>
                                <li style="margin-bottom: 0.5rem;">✓ Real-time status updates</li>
                                <li style="margin-bottom: 0.5rem;">✓ Automated processing systems</li>
                            </ul>
                        </div>
                        <div>
                            <h4 class="text-warning mb-3">🌍 Global Reach</h4>
                            <ul style="list-style: none; padding: 0;">
                                <li style="margin-bottom: 0.5rem;">✓ 200+ countries served</li>
                                <li style="margin-bottom: 0.5rem;">✓ Local expertise worldwide</li>
                                <li style="margin-bottom: 0.5rem;">✓ Multi-language support</li>
                                <li style="margin-bottom: 0.5rem;">✓ Cultural understanding</li>
                            </ul>
                        </div>
                        <div>
                            <h4 class="text-danger mb-3">💼 Professional Service</h4>
                            <ul style="list-style: none; padding: 0;">
                                <li style="margin-bottom: 0.5rem;">✓ Dedicated account managers</li>
                                <li style="margin-bottom: 0.5rem;">✓ Custom solutions available</li>
                                <li style="margin-bottom: 0.5rem;">✓ Enterprise-grade support</li>
                                <li style="margin-bottom: 0.5rem;">✓ Flexible pricing models</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="grid grid-cols-4 mb-8">
                <div class="card text-center">
                    <div class="card-body">
                        <div style="font-size: 2.5rem; font-weight: bold; color: var(--primary-color);">10M+</div>
                        <p class="text-secondary">Packages Delivered</p>
                    </div>
                </div>
                <div class="card text-center">
                    <div class="card-body">
                        <div style="font-size: 2.5rem; font-weight: bold; color: var(--success-color);">200+</div>
                        <p class="text-secondary">Countries Served</p>
                    </div>
                </div>
                <div class="card text-center">
                    <div class="card-body">
                        <div style="font-size: 2.5rem; font-weight: bold; color: var(--warning-color);">99.9%</div>
                        <p class="text-secondary">Delivery Success Rate</p>
                    </div>
                </div>
                <div class="card text-center">
                    <div class="card-body">
                        <div style="font-size: 2.5rem; font-weight: bold; color: var(--danger-color);">24/7</div>
                        <p class="text-secondary">Customer Support</p>
                    </div>
                </div>
            </div>
            
            <div class="card">
                <div class="card-body text-center">
                    <h2 class="mb-4">Ready to Ship with CargoFlow?</h2>
                    <p class="mb-6" style="font-size: 1.125rem;">Join millions of satisfied customers who trust us with their valuable cargo.</p>
                    <div style="display: flex; gap: 1rem; justify-content: center;">
                        <a href="${contextPath}/register" class="btn btn-primary">Get Started Today</a>
                        <a href="${contextPath}/contact" class="btn btn-outline">Contact Sales</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>

    <div class="about-container">
        <div class="about-header">
            <h1>About Cargo Management System</h1>
            <p>Your trusted partner in cargo logistics and shipment management</p>
        </div>

        <div class="about-section">
            <h3>Our Mission</h3>
            <p>We are dedicated to providing efficient, reliable, and secure cargo management services. 
               Our advanced tracking system ensures that your shipments are monitored every step of the way, 
               from pickup to delivery.</p>
        </div>

        <div class="about-section">
            <h3>Why Choose Us?</h3>
            <div class="features-grid">
                <div class="feature-card">
                    <h4>🚚 Fast Delivery</h4>
                    <p>Quick and efficient cargo transportation with real-time tracking</p>
                </div>
                <div class="feature-card">
                    <h4>🔒 Secure Handling</h4>
                    <p>Your cargo is handled with utmost care and security protocols</p>
                </div>
                <div class="feature-card">
                    <h4>📱 Real-time Tracking</h4>
                    <p>Track your shipment 24/7 with our advanced tracking system</p>
                </div>
                <div class="feature-card">
                    <h4>💰 Competitive Pricing</h4>
                    <p>Affordable rates without compromising on quality service</p>
                </div>
            </div>
        </div>

        <div class="about-section">
            <h3>Our Services</h3>
            <ul>
                <li><strong>Cargo Registration:</strong> Easy online registration for your shipments</li>
                <li><strong>Package Tracking:</strong> Real-time tracking with detailed status updates</li>
                <li><strong>Multiple Cargo Types:</strong> Support for electronics, furniture, documents, and more</li>
                <li><strong>Insurance Options:</strong> Protect your valuable shipments with our insurance plans</li>
                <li><strong>Express Delivery:</strong> Priority handling for urgent shipments</li>
            </ul>
        </div>

        <div class="about-section">
            <h3>Contact Information</h3>
            <p><strong>Phone:</strong> +977-1-4444444</p>
            <p><strong>Email:</strong> info@cargomanagement.com</p>
            <p><strong>Address:</strong> Kathmandu, Nepal</p>
            <p><strong>Operating Hours:</strong> 24/7 Customer Support</p>
        </div>

    </div>

    <%@ include file="footer.jsp" %>

</body>
</html>
