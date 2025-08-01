<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Contact CargoFlow</h1>
                <p class="page-subtitle">Get in touch with our team for any inquiries</p>
            </div>
            
            <div class="grid grid-cols-2">
                <!-- Contact Form -->
                <div>
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">Send us a Message</h2>
                        </div>
                        <div class="card-body">
                            <form action="${contextPath}/contact" method="post">
                                <div class="form-group">
                                    <label for="name" class="form-label">Full Name *</label>
                                    <input type="text" id="name" name="name" class="form-input" required>
                                </div>
                                
                                <div class="form-group">
                                    <label for="email" class="form-label">Email Address *</label>
                                    <input type="email" id="email" name="email" class="form-input" required>
                                </div>
                                
                                <div class="form-group">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" id="phone" name="phone" class="form-input">
                                </div>
                                
                                <div class="form-group">
                                    <label for="subject" class="form-label">Subject *</label>
                                    <select id="subject" name="subject" class="form-select" required>
                                        <option value="">Select a topic</option>
                                        <option value="general">General Inquiry</option>
                                        <option value="shipping">Shipping Questions</option>
                                        <option value="tracking">Tracking Issues</option>
                                        <option value="billing">Billing Support</option>
                                        <option value="technical">Technical Support</option>
                                        <option value="partnership">Partnership Opportunities</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="message" class="form-label">Message *</label>
                                    <textarea id="message" name="message" rows="5" class="form-textarea" 
                                        placeholder="Please describe your inquiry in detail..." required></textarea>
                                </div>
                                
                                <button type="submit" class="btn btn-primary" style="width: 100%;">
                                    Send Message
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Contact Information -->
                <div>
                    <div class="card mb-6">
                        <div class="card-header">
                            <h3 class="card-title">Get in Touch</h3>
                        </div>
                        <div class="card-body">
                            <div class="mb-4">
                                <h4 class="text-primary mb-2">📍 Head Office</h4>
                                <p>123 Cargo Street<br>
                                Logistics City, LC 12345<br>
                                United States</p>
                            </div>
                            
                            <div class="mb-4">
                                <h4 class="text-primary mb-2">📞 Phone Support</h4>
                                <p><strong>Main:</strong> +1 (555) 123-4567<br>
                                <strong>Toll Free:</strong> 1-800-CARGO-GO<br>
                                <strong>International:</strong> +1 (555) 123-4568</p>
                            </div>
                            
                            <div class="mb-4">
                                <h4 class="text-primary mb-2">✉️ Email Support</h4>
                                <p><strong>General:</strong> info@cargoflow.com<br>
                                <strong>Support:</strong> support@cargoflow.com<br>
                                <strong>Sales:</strong> sales@cargoflow.com</p>
                            </div>
                            
                            <div class="mb-4">
                                <h4 class="text-primary mb-2">🕒 Business Hours</h4>
                                <p><strong>Monday - Friday:</strong> 8:00 AM - 6:00 PM EST<br>
                                <strong>Saturday:</strong> 9:00 AM - 4:00 PM EST<br>
                                <strong>Sunday:</strong> Emergency support only</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- FAQ Section -->
            <div class="card mb-8">
                <div class="card-header">
                    <h2 class="card-title">Frequently Asked Questions</h2>
                </div>
                <div class="card-body">
                    <div class="grid grid-cols-2">
                        <div>
                            <h4 class="text-primary mb-3">Shipping &amp; Delivery</h4>
                            <div class="mb-4">
                                <strong>Q: How can I track my shipment?</strong>
                                <p>Use our tracking tool with your cargo number, or log into your dashboard for real-time updates.</p>
                            </div>
                            <div class="mb-4">
                                <strong>Q: What are your delivery timeframes?</strong>
                                <p>Domestic: 1-3 business days, International: 3-7 business days, depending on destination.</p>
                            </div>
                        </div>
                        <div>
                            <h4 class="text-success mb-3">Account &amp; Billing</h4>
                            <div class="mb-4">
                                <strong>Q: How do I create an account?</strong>
                                <p>Click 'Register' in the top menu and fill out the simple registration form.</p>
                            </div>
                            <div class="mb-4">
                                <strong>Q: What payment methods do you accept?</strong>
                                <p>We accept all major credit cards, PayPal, bank transfers, and corporate accounts.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Emergency Contact -->
            <div class="card bg-danger" style="background-color: var(--danger-color) !important; color: white;">
                <div class="card-body text-center">
                    <h3 style="color: white; margin-bottom: 1rem;">Emergency Support</h3>
                    <p style="color: white; margin-bottom: 1rem;">
                        For urgent shipment issues or emergencies, contact our 24/7 hotline:
                    </p>
                    <p style="color: white; font-size: 1.5rem; font-weight: bold;">
                        🚨 Emergency: +1 (555) 911-CARGO
                    </p>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
