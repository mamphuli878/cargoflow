<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container" style="max-width: 500px;">
            <div class="page-header">
                <h1 class="page-title">Welcome Back</h1>
                <p class="page-subtitle">Sign in to your CargoFlow account</p>
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
                    <h2 class="card-title">Login to Your Account</h2>
                </div>
                <div class="card-body">
                    <form action="${contextPath}/login" method="post">
                        <div class="form-group">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" id="username" name="username" class="form-input" 
                                   required placeholder="Enter your username" 
                                   value="${param.username}" />
                        </div>
                        
                        <div class="form-group">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" id="password" name="password" class="form-input" 
                                   required placeholder="Enter your password" />
                        </div>
                        
                        <button type="submit" class="btn btn-primary" style="width: 100%; font-size: 1.125rem;">
                            Sign In
                        </button>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <p style="margin: 0; color: var(--text-secondary);">
                        Don't have an account? 
                        <a href="${contextPath}/register" style="color: var(--primary-color); text-decoration: none; font-weight: 500;">
                            Sign up here
                        </a>
                    </p>
                </div>
            </div>
            
            <!-- Additional Info -->
            <div class="card mt-6">
                <div class="card-body text-center">
                    <h3 class="mb-4">Why Choose CargoFlow?</h3>
                    <div class="grid grid-cols-2">
                        <div class="mb-4">
                            <div style="font-size: 2rem; color: var(--primary-color); margin-bottom: 0.5rem;">🚀</div>
                            <strong>Fast &amp; Reliable</strong>
                            <p style="font-size: 0.875rem; color: var(--text-secondary); margin: 0;">Lightning-fast shipping worldwide</p>
                        </div>
                        <div class="mb-4">
                            <div style="font-size: 2rem; color: var(--success-color); margin-bottom: 0.5rem;">🔒</div>
                            <strong>Secure &amp; Safe</strong>
                            <p style="font-size: 0.875rem; color: var(--text-secondary); margin: 0;">Your cargo is protected</p>
                        </div>
                        <div>
                            <div style="font-size: 2rem; color: var(--warning-color); margin-bottom: 0.5rem;">💰</div>
                            <strong>Best Rates</strong>
                            <p style="font-size: 0.875rem; color: var(--text-secondary); margin: 0;">Competitive pricing</p>
                        </div>
                        <div>
                            <div style="font-size: 2rem; color: var(--danger-color); margin-bottom: 0.5rem;">📞</div>
                            <strong>24/7 Support</strong>
                            <p style="font-size: 0.875rem; color: var(--text-secondary); margin: 0;">Always here to help</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
