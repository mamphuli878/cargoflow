<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container" style="max-width: 600px;">
            <div class="card">
                <div class="card-body text-center p-8">
                    <div style="font-size: 4rem; color: var(--danger-color); margin-bottom: 2rem;">🚫</div>
                    <h1 style="color: var(--danger-color); margin-bottom: 1rem;">Access Denied</h1>
                    <p style="color: var(--text-secondary); margin-bottom: 2rem; font-size: 1.125rem;">
                        You don't have permission to access this feature. Only administrators can create new shipments.
                    </p>
                    
                    <div style="background-color: var(--bg-accent); padding: 1.5rem; border-radius: var(--radius-md); margin-bottom: 2rem;">
                        <h3 style="color: var(--text-primary); margin-bottom: 1rem;">What you can do:</h3>
                        <ul style="text-align: left; color: var(--text-secondary);">
                            <li style="margin-bottom: 0.5rem;">✅ Track existing shipments using tracking numbers</li>
                            <li style="margin-bottom: 0.5rem;">✅ View your dashboard to monitor shipments</li>
                            <li style="margin-bottom: 0.5rem;">✅ Contact support for assistance</li>
                            <li style="margin-bottom: 0.5rem;">✅ Update your profile information</li>
                        </ul>
                    </div>
                    
                    <div style="display: flex; gap: 1rem; justify-content: center;">
                        <a href="${contextPath}/userDashboard" class="btn btn-primary">
                            📊 Go to Dashboard
                        </a>
                        <a href="${contextPath}/track" class="btn btn-outline">
                            🔍 Track Shipments
                        </a>
                        <a href="${contextPath}/contact" class="btn btn-secondary">
                            💬 Contact Support
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
