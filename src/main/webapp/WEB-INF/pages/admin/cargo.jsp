<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cargo Management - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <jsp:include page="../header.jsp" />
    
    <div class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Cargo Management</h1>
                <p class="page-subtitle">Manage and track all cargo shipments</p>
            </div>

            <!-- Statistics Cards -->
            <div class="grid grid-cols-4 mb-6">
                <div class="card">
                    <div class="card-body text-center">
                        <h3 class="text-primary font-bold" style="font-size: 2rem; margin-bottom: 0.5rem;">
                            ${empty total ? 0 : total}
                        </h3>
                        <p class="text-secondary">Total Cargo</p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-body text-center">
                        <h3 class="text-warning font-bold" style="font-size: 2rem; margin-bottom: 0.5rem;">
                            ${empty pending ? 0 : pending}
                        </h3>
                        <p class="text-secondary">Pending</p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-body text-center">
                        <h3 class="text-primary font-bold" style="font-size: 2rem; margin-bottom: 0.5rem;">
                            ${empty inTransit ? 0 : inTransit}
                        </h3>
                        <p class="text-secondary">In Transit</p>
                    </div>
                </div>
                <div class="card">
                    <div class="card-body text-center">
                        <h3 class="text-success font-bold" style="font-size: 2rem; margin-bottom: 0.5rem;">
                            ${empty delivered ? 0 : delivered}
                        </h3>
                        <p class="text-secondary">Delivered</p>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="grid grid-cols-3 mb-6">
                <a href="${contextPath}/registerCargo" class="card" style="text-decoration: none; color: inherit;">
                    <div class="card-body text-center">
                        <div style="font-size: 3rem; margin-bottom: 1rem;">📦</div>
                        <h3 class="card-title">Register New Cargo</h3>
                        <p class="text-secondary">Add a new shipment to the system</p>
                    </div>
                </a>
                <a href="${contextPath}/track" class="card" style="text-decoration: none; color: inherit;">
                    <div class="card-body text-center">
                        <div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
                        <h3 class="card-title">Track Cargo</h3>
                        <p class="text-secondary">Search and track shipment status</p>
                    </div>
                </a>
                <a href="${contextPath}/dashboard" class="card" style="text-decoration: none; color: inherit;">
                    <div class="card-body text-center">
                        <div style="font-size: 3rem; margin-bottom: 1rem;">📊</div>
                        <h3 class="card-title">Dashboard</h3>
                        <p class="text-secondary">View system overview</p>
                    </div>
                </a>
            </div>

            <!-- Messages -->
            <c:if test="${not empty error}">
                <div class="card mb-4" style="border-left: 4px solid var(--danger-color);">
                    <div class="card-body">
                        <p style="color: var(--danger-color); margin: 0;">${error}</p>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="card mb-4" style="border-left: 4px solid var(--success-color);">
                    <div class="card-body">
                        <p style="color: var(--success-color); margin: 0;">${success}</p>
                    </div>
                </div>
            </c:if>

            <!-- Cargo List -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">All Cargo Shipments</h2>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty cargoList}">
                            <div style="overflow-x: auto;">
                                <table style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr style="background-color: var(--bg-accent);">
                                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 600;">ID</th>
                                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 600;">Cargo Number</th>
                                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 600;">Sender</th>
                                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 600;">Receiver</th>
                                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 600;">Type</th>
                                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 600;">Status</th>
                                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 600;">Cost</th>
                                            <th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color); font-weight: 600;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cargo" items="${cargoList}">
                                            <tr style="border-bottom: 1px solid var(--border-light);">
                                                <td style="padding: 1rem;">${cargo.cargoId}</td>
                                                <td style="padding: 1rem; font-weight: 500;">${cargo.cargoNumber}</td>
                                                <td style="padding: 1rem;">${cargo.senderName}</td>
                                                <td style="padding: 1rem;">${cargo.receiverName}</td>
                                                <td style="padding: 1rem;">${cargo.cargoType.name}</td>
                                                <td style="padding: 1rem;">
                                                    <c:choose>
                                                        <c:when test="${cargo.status eq 'Pending'}">
                                                            <span style="background: var(--warning-color); color: white; padding: 0.25rem 0.75rem; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 500;">${cargo.status}</span>
                                                        </c:when>
                                                        <c:when test="${cargo.status eq 'In Transit'}">
                                                            <span style="background: var(--primary-color); color: white; padding: 0.25rem 0.75rem; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 500;">${cargo.status}</span>
                                                        </c:when>
                                                        <c:when test="${cargo.status eq 'Delivered'}">
                                                            <span style="background: var(--success-color); color: white; padding: 0.25rem 0.75rem; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 500;">${cargo.status}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="background: var(--secondary-color); color: white; padding: 0.25rem 0.75rem; border-radius: var(--radius-sm); font-size: 0.75rem; font-weight: 500;">${cargo.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="padding: 1rem; font-weight: 500;">$${cargo.shippingCost}</td>
                                                <td style="padding: 1rem;">
                                                    <div style="display: flex; gap: 0.5rem;">
                                                        <form action="${contextPath}/modifyCargo" method="post" style="display: inline;">
                                                            <input type="hidden" name="cargoId" value="${cargo.cargoId}">
                                                            <input type="hidden" name="action" value="updateForm">
                                                            <button class="btn btn-sm btn-primary" type="submit">Edit</button>
                                                        </form>
                                                        <form action="${contextPath}/modifyCargo" method="post" style="display: inline;">
                                                            <input type="hidden" name="cargoId" value="${cargo.cargoId}">
                                                            <input type="hidden" name="action" value="delete">
                                                            <button class="btn btn-sm btn-outline-danger" type="submit" 
                                                                    onclick="return confirm('Are you sure you want to delete this cargo?')">Delete</button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center" style="padding: 3rem 0;">
                                <div style="font-size: 4rem; margin-bottom: 1rem; color: var(--text-light);">📦</div>
                                <h3 style="margin-bottom: 1rem; color: var(--text-secondary);">No Cargo Found</h3>
                                <p style="color: var(--text-light); margin-bottom: 2rem;">Start by registering your first cargo shipment.</p>
                                <a href="${contextPath}/registerCargo" class="btn btn-primary">Register New Cargo</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../footer.jsp" />
</body>
</html>
