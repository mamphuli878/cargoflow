<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portfolio - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Our Portfolio</h1>
                <p class="page-subtitle">Showcasing our success stories and global reach</p>
            </div>
            
            <!-- Statistics Section -->
            <div class="grid grid-cols-4 mb-8">
                <div class="card text-center" style="background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)); color: white;">
                    <div class="card-body">
                        <h3 style="font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem; color: white;">15,000+</h3>
                        <p style="color: rgba(255,255,255,0.9);">Shipments Delivered</p>
                    </div>
                </div>
                <div class="card text-center" style="background: linear-gradient(135deg, var(--success-color), #16a34a); color: white;">
                    <div class="card-body">
                        <h3 style="font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem; color: white;">50+</h3>
                        <p style="color: rgba(255,255,255,0.9);">Countries Served</p>
                    </div>
                </div>
                <div class="card text-center" style="background: linear-gradient(135deg, var(--warning-color), #f59e0b); color: white;">
                    <div class="card-body">
                        <h3 style="font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem; color: white;">99.8%</h3>
                        <p style="color: rgba(255,255,255,0.9);">On-Time Delivery</p>
                    </div>
                </div>
                <div class="card text-center" style="background: linear-gradient(135deg, var(--accent-color), #059669); color: white;">
                    <div class="card-body">
                        <h3 style="font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem; color: white;">24/7</h3>
                        <p style="color: rgba(255,255,255,0.9);">Customer Support</p>
                    </div>
                </div>
            </div>
            
            <!-- Services Grid -->
            <div class="card mb-8">
                <div class="card-header">
                    <h2 class="card-title">Our Services</h2>
                </div>
                <div class="card-body">
                    <div class="grid grid-cols-3">
                        <div class="text-center p-6">
                            <div style="font-size: 3rem; margin-bottom: 1rem;">🚚</div>
                            <h4 class="text-primary mb-3">Ground Shipping</h4>
                            <p>Fast and reliable ground transportation for domestic deliveries with real-time tracking and secure handling.</p>
                        </div>
                        <div class="text-center p-6">
                            <div style="font-size: 3rem; margin-bottom: 1rem;">✈️</div>
                            <h4 class="text-primary mb-3">Air Freight</h4>
                            <p>Express air shipping for urgent deliveries worldwide. Perfect for time-sensitive cargo and international shipments.</p>
                        </div>
                        <div class="text-center p-6">
                            <div style="font-size: 3rem; margin-bottom: 1rem;">🚢</div>
                            <h4 class="text-primary mb-3">Ocean Freight</h4>
                            <p>Cost-effective sea transportation for large shipments. Ideal for bulk cargo and long-distance international trade.</p>
                        </div>
                        <div class="text-center p-6">
                            <div style="font-size: 3rem; margin-bottom: 1rem;">📦</div>
                            <h4 class="text-primary mb-3">Warehousing</h4>
                            <p>Secure storage solutions with climate control and 24/7 monitoring. Professional handling and inventory management.</p>
                        </div>
                        <div class="text-center p-6">
                            <div style="font-size: 3rem; margin-bottom: 1rem;">🌍</div>
                            <h4 class="text-primary mb-3">Global Logistics</h4>
                            <p>Comprehensive international shipping solutions with customs clearance and door-to-door delivery services.</p>
                        </div>
                        <div class="text-center p-6">
                            <div style="font-size: 3rem; margin-bottom: 1rem;">📱</div>
                            <h4 class="text-primary mb-3">Track &amp; Trace</h4>
                            <p>Advanced tracking technology providing real-time updates and delivery notifications for complete transparency.</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Testimonials Section -->
            <div class="card mb-8" style="background-color: var(--bg-accent);">
                <div class="card-header">
                    <h2 class="card-title">Client Testimonials</h2>
                </div>
                <div class="card-body">
                    <div class="grid grid-cols-2">
                        <div class="card mb-4" style="border-left: 4px solid var(--primary-color);">
                            <div class="card-body">
                                <p style="font-style: italic; margin-bottom: 1rem;">
                                    "CargoFlow has transformed our supply chain operations. Their reliability and professional service have helped us expand our global reach significantly."
                                </p>
                                <div style="font-weight: bold; color: var(--primary-color);">
                                    - Sarah Johnson, CEO of TechCorp International
                                </div>
                            </div>
                        </div>
                        <div class="card mb-4" style="border-left: 4px solid var(--success-color);">
                            <div class="card-body">
                                <p style="font-style: italic; margin-bottom: 1rem;">
                                    "Outstanding service and competitive rates. The tracking system is excellent and gives us complete visibility of our shipments."
                                </p>
                                <div style="font-weight: bold; color: var(--success-color);">
                                    - Michael Chen, Logistics Manager at Global Electronics
                                </div>
                            </div>
                        </div>
                        <div class="card mb-4" style="border-left: 4px solid var(--warning-color);">
                            <div class="card-body">
                                <p style="font-style: italic; margin-bottom: 1rem;">
                                    "We've been using CargoFlow for 5 years. Their customer support is exceptional and they always deliver on time."
                                </p>
                                <div style="font-weight: bold; color: var(--warning-color);">
                                    - Emma Rodriguez, Operations Director at Fashion Forward
                                </div>
                            </div>
                        </div>
                        <div class="card mb-4" style="border-left: 4px solid var(--accent-color);">
                            <div class="card-body">
                                <p style="font-style: italic; margin-bottom: 1rem;">
                                    "The best logistics partner we've worked with. Professional, efficient, and cost-effective solutions for all our shipping needs."
                                </p>
                                <div style="font-weight: bold; color: var(--accent-color);">
                                    - David Thompson, Supply Chain Manager at AutoParts Plus
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Global Reach Section -->
            <div class="card mb-8">
                <div class="card-header">
                    <h2 class="card-title">Global Network</h2>
                </div>
                <div class="card-body">
                    <div class="grid grid-cols-3">
                        <div>
                            <h4 class="text-primary mb-3">🇺🇸 North America</h4>
                            <ul style="list-style: none; padding: 0;">
                                <li>✓ United States - 15 distribution centers</li>
                                <li>✓ Canada - 3 major hubs</li>
                                <li>✓ Mexico - 2 strategic locations</li>
                            </ul>
                        </div>
                        <div>
                            <h4 class="text-primary mb-3">🇪🇺 Europe</h4>
                            <ul style="list-style: none; padding: 0;">
                                <li>✓ Germany - Central European hub</li>
                                <li>✓ United Kingdom - 4 facilities</li>
                                <li>✓ France - 3 distribution centers</li>
                                <li>✓ Netherlands - Major port facility</li>
                            </ul>
                        </div>
                        <div>
                            <h4 class="text-primary mb-3">🌏 Asia Pacific</h4>
                            <ul style="list-style: none; padding: 0;">
                                <li>✓ China - 8 strategic locations</li>
                                <li>✓ Japan - 2 major facilities</li>
                                <li>✓ Singapore - Regional hub</li>
                                <li>✓ Australia - 3 distribution centers</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Call to Action -->
            <div class="card text-center" style="background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)); color: white;">
                <div class="card-body">
                    <h2 style="color: white; margin-bottom: 1rem;">Ready to Ship with CargoFlow?</h2>
                    <p style="color: rgba(255,255,255,0.9); margin-bottom: 2rem; font-size: 1.125rem;">
                        Join thousands of satisfied customers who trust us with their logistics needs.
                    </p>
                    <div style="display: flex; gap: 1rem; justify-content: center;">
                        <a href="${contextPath}/register" class="btn btn-secondary">Get Started Today</a>
                        <a href="${contextPath}/contact" class="btn btn-outline" style="border-color: white; color: white;">Contact Sales</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
