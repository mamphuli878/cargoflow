<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container" style="max-width: 600px;">
            <div class="page-header">
                <h1 class="page-title">Join CargoFlow</h1>
                <p class="page-subtitle">Create your account and start shipping today</p>
            </div>
            
            <!-- Display Messages -->
            <c:if test="${not empty error}">
                <div style="background-color: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty success}">
                <div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; color: #166534; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                    ${success}
                </div>
            </c:if>
            
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Create Your Account</h2>
                </div>
                <div class="card-body">
                    <form action="${contextPath}/register" method="post">
                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="firstName" class="form-label">First Name *</label>
                                <input type="text" id="firstName" name="firstName" class="form-input" 
                                       required placeholder="Enter your first name" 
                                       value="${param.firstName}" />
                            </div>
                            
                            <div class="form-group">
                                <label for="lastName" class="form-label">Last Name *</label>
                                <input type="text" id="lastName" name="lastName" class="form-input" 
                                       required placeholder="Enter your last name" 
                                       value="${param.lastName}" />
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="username" class="form-label">Username *</label>
                            <input type="text" id="username" name="username" class="form-input" 
                                   required placeholder="Choose a unique username" 
                                   value="${param.username}" />
                            <small style="color: var(--text-secondary);">This will be your login username</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="email" class="form-label">Email Address *</label>
                            <input type="email" id="email" name="email" class="form-input" 
                                   required placeholder="Enter your email address" 
                                   value="${param.email}" />
                        </div>
                        
                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="password" class="form-label">Password *</label>
                                <input type="password" id="password" name="password" class="form-input" 
                                       required placeholder="Create a strong password" />
                                <small style="color: var(--text-secondary);">Minimum 8 characters</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">Confirm Password *</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" 
                                       required placeholder="Confirm your password" />
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="phoneNumber" class="form-label">Phone Number</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" class="form-input" 
                                   placeholder="Enter your phone number" 
                                   value="${param.phoneNumber}" />
                        </div>
                        
                        <div class="form-group">
                            <label for="address" class="form-label">Address</label>
                            <textarea id="address" name="address" rows="3" class="form-textarea" 
                                      placeholder="Enter your full address">${param.address}</textarea>
                        </div>
                        
                        <div class="form-group">
                            <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                <input type="checkbox" name="terms" required style="margin: 0;" />
                                <span>I agree to the 
                                    <a href="#" style="color: var(--primary-color); text-decoration: none;">Terms of Service</a> 
                                    and 
                                    <a href="#" style="color: var(--primary-color); text-decoration: none;">Privacy Policy</a>
                                </span>
                            </label>
                        </div>
                        
                        <div class="form-group">
                            <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                                <input type="checkbox" name="newsletter" style="margin: 0;" />
                                <span>Subscribe to our newsletter for shipping tips and special offers</span>
                            </label>
                        </div>
                        
                        <button type="submit" class="btn btn-primary" style="width: 100%; font-size: 1.125rem;">
                            Create Account
                        </button>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <p style="margin: 0; color: var(--text-secondary);">
                        Already have an account? 
                        <a href="${contextPath}/login" style="color: var(--primary-color); text-decoration: none; font-weight: 500;">
                            Sign in here
                        </a>
                    </p>
                </div>
            </div>
            
            <!-- Benefits Section -->
            <div class="card mt-6">
                <div class="card-body">
                    <h3 class="text-center mb-4">What You Get with CargoFlow</h3>
                    <div class="grid grid-cols-2">
                        <div class="mb-4">
                            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem;">
                                <div style="font-size: 1.5rem; color: var(--success-color);">✓</div>
                                <strong>Free Account Setup</strong>
                            </div>
                            <p style="font-size: 0.875rem; color: var(--text-secondary); margin: 0; padding-left: 2.25rem;">
                                No setup fees or hidden charges
                            </p>
                        </div>
                        <div class="mb-4">
                            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem;">
                                <div style="font-size: 1.5rem; color: var(--success-color);">✓</div>
                                <strong>Real-Time Tracking</strong>
                            </div>
                            <p style="font-size: 0.875rem; color: var(--text-secondary); margin: 0; padding-left: 2.25rem;">
                                Monitor your shipments 24/7
                            </p>
                        </div>
                        <div class="mb-4">
                            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem;">
                                <div style="font-size: 1.5rem; color: var(--success-color);">✓</div>
                                <strong>Global Shipping</strong>
                            </div>
                            <p style="font-size: 0.875rem; color: var(--text-secondary); margin: 0; padding-left: 2.25rem;">
                                Ship to 200+ countries worldwide
                            </p>
                        </div>
                        <div class="mb-4">
                            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem;">
                                <div style="font-size: 1.5rem; color: var(--success-color);">✓</div>
                                <strong>24/7 Support</strong>
                            </div>
                            <p style="font-size: 0.875rem; color: var(--text-secondary); margin: 0; padding-left: 2.25rem;">
                                Expert help whenever you need it
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
