<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help Center - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
    <style>
        .faq-item {
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
            margin-bottom: 1rem;
            overflow: hidden;
        }
        
        .faq-question {
            background-color: var(--bg-secondary);
            padding: 1rem;
            cursor: pointer;
            user-select: none;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 500;
        }
        
        .faq-question:hover {
            background-color: var(--bg-accent);
        }
        
        .faq-answer {
            padding: 1rem;
            background-color: white;
            border-top: 1px solid var(--border-color);
            display: none;
            line-height: 1.6;
        }
        
        .faq-answer.active {
            display: block;
        }
        
        .faq-toggle {
            transition: transform 0.2s ease;
        }
        
        .faq-toggle.active {
            transform: rotate(180deg);
        }
        
        .help-section {
            padding: 2rem;
            text-align: center;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: var(--radius-lg);
            margin-bottom: 2rem;
        }
        
        .help-section h1 {
            color: white;
            margin-bottom: 1rem;
        }
        
        .quick-links {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .quick-link {
            background: white;
            padding: 1.5rem;
            border-radius: var(--radius-md);
            text-decoration: none;
            color: var(--text-primary);
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
            text-align: center;
        }
        
        .quick-link:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            text-decoration: none;
            color: var(--primary-color);
        }
        
        .quick-link-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <!-- Help Header -->
            <div class="help-section">
                <h1>How Can We Help You?</h1>
                <p>Find answers to common questions or contact our support team for personalized assistance.</p>
            </div>
            
            <!-- Display Messages -->
            <c:if test="${not empty sessionScope.helpMessage}">
                <div class="alert alert-${sessionScope.helpMessageType} mb-6">
                    <c:out value="${sessionScope.helpMessage}"/>
                </div>
                <%-- Clear the message after displaying --%>
                <c:remove var="helpMessage" scope="session"/>
                <c:remove var="helpMessageType" scope="session"/>
            </c:if>
            
            <!-- Quick Links -->
            <div class="quick-links">
                <a href="${contextPath}/track" class="quick-link">
                    <div class="quick-link-icon">📦</div>
                    <h4>Track Package</h4>
                    <p>Find your shipment status</p>
                </a>
                
                <a href="${contextPath}/shipping-quote" class="quick-link">
                    <div class="quick-link-icon">💰</div>
                    <h4>Get Quote</h4>
                    <p>Calculate shipping costs</p>
                </a>
                
                <a href="${contextPath}/locations" class="quick-link">
                    <div class="quick-link-icon">📍</div>
                    <h4>Find Locations</h4>
                    <p>Service centers near you</p>
                </a>
                
                <a href="${contextPath}/contact" class="quick-link">
                    <div class="quick-link-icon">📞</div>
                    <h4>Contact Support</h4>
                    <p>Speak with our team</p>
                </a>
            </div>
            
            <!-- Search and Filter -->
            <div class="card mb-6">
                <div class="card-header">
                    <h3 class="card-title">🔍 Search Help Topics</h3>
                </div>
                <div class="card-body">
                    <form action="${contextPath}/help" method="get">
                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="search" class="form-label">Search FAQs</label>
                                <input type="text" id="search" name="search" class="form-input" 
                                       value="${searchQuery}" placeholder="Enter keywords...">
                            </div>
                            
                            <div class="form-group">
                                <label for="category" class="form-label">Category</label>
                                <select id="category" name="category" class="form-select">
                                    <option value="all" ${selectedCategory == 'all' || empty selectedCategory ? 'selected' : ''}>All Categories</option>
                                    <option value="shipping" ${selectedCategory == 'shipping' ? 'selected' : ''}>Shipping & Delivery</option>
                                    <option value="pricing" ${selectedCategory == 'pricing' ? 'selected' : ''}>Pricing & Billing</option>
                                    <option value="account" ${selectedCategory == 'account' ? 'selected' : ''}>Account Management</option>
                                    <option value="delivery" ${selectedCategory == 'delivery' ? 'selected' : ''}>Delivery Options</option>
                                    <option value="claims" ${selectedCategory == 'claims' ? 'selected' : ''}>Claims & Issues</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <button type="submit" class="btn btn-primary mr-2">Search</button>
                            <a href="${contextPath}/help" class="btn btn-secondary">Clear</a>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- FAQ Results -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">
                        <c:choose>
                            <c:when test="${searchPerformed}">
                                Search Results (${faqs.size()} found)
                            </c:when>
                            <c:otherwise>
                                Frequently Asked Questions
                            </c:otherwise>
                        </c:choose>
                    </h3>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty faqs}">
                            <div id="faq-container">
                                <c:forEach var="faq" items="${faqs}" varStatus="status">
                                    <div class="faq-item">
                                        <div class="faq-question" onclick="toggleFAQ('${status.index}')">
                                            <span><c:out value="${faq.question}"/></span>
                                            <span class="faq-toggle" id="toggle-${status.index}">▼</span>
                                        </div>
                                        <div class="faq-answer" id="answer-${status.index}">
                                            <c:out value="${faq.answer}"/>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-8">
                                <p class="mb-4">No FAQs found matching your search criteria.</p>
                                <a href="${contextPath}/help" class="btn btn-primary">View All FAQs</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Contact Form -->
            <div class="card mt-8">
                <div class="card-header">
                    <h3 class="card-title">📧 Still Need Help?</h3>
                </div>
                <div class="card-body">
                    <p class="mb-6">Can't find what you're looking for? Send us a message and our support team will get back to you within 24 hours.</p>
                    
                    <form action="${contextPath}/help" method="post">
                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="name" class="form-label">Name *</label>
                                <input type="text" id="name" name="name" class="form-input" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="email" class="form-label">Email *</label>
                                <input type="email" id="email" name="email" class="form-input" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="subject" class="form-label">Subject *</label>
                            <select id="subject" name="subject" class="form-select" required>
                                <option value="">Select a subject</option>
                                <option value="shipping">Shipping Question</option>
                                <option value="tracking">Tracking Issue</option>
                                <option value="billing">Billing Question</option>
                                <option value="account">Account Problem</option>
                                <option value="damage">Damage Claim</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="message" class="form-label">Message *</label>
                            <textarea id="message" name="message" rows="5" class="form-input" 
                                      placeholder="Please describe your question or issue in detail..." required></textarea>
                        </div>
                        
                        <button type="submit" class="btn btn-primary">Send Message</button>
                    </form>
                </div>
            </div>
            
            <!-- Support Hours -->
            <div class="card mt-8" style="background: var(--bg-accent);">
                <div class="card-body text-center">
                    <h4 class="mb-4">🕒 Support Hours</h4>
                    <div class="grid grid-cols-3">
                        <div>
                            <h5>Phone Support</h5>
                            <p>Monday - Friday: 8 AM - 8 PM<br>Saturday: 9 AM - 5 PM<br>Sunday: Closed</p>
                        </div>
                        <div>
                            <h5>Live Chat</h5>
                            <p>Monday - Friday: 8 AM - 6 PM<br>Response within 2 hours</p>
                        </div>
                        <div>
                            <h5>Email Support</h5>
                            <p>24/7 Response<br>Typical response: 4-8 hours</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
    
    <script>
        function toggleFAQ(index) {
            const answer = document.getElementById('answer-' + index);
            const toggle = document.getElementById('toggle-' + index);
            
            if (answer.classList.contains('active')) {
                answer.classList.remove('active');
                toggle.classList.remove('active');
            } else {
                // Close all other FAQs
                document.querySelectorAll('.faq-answer').forEach(item => {
                    item.classList.remove('active');
                });
                document.querySelectorAll('.faq-toggle').forEach(item => {
                    item.classList.remove('active');
                });
                
                // Open this FAQ
                answer.classList.add('active');
                toggle.classList.add('active');
            }
        }
        
        // Auto-expand first FAQ if no search performed
        document.addEventListener('DOMContentLoaded', function() {
            <c:if test="${not searchPerformed and not empty faqs}">
                toggleFAQ('0');
            </c:if>
        });
    </script>
</body>
</html>
