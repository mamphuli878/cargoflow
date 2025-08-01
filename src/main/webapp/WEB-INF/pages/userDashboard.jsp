<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>          

         
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
    <style>
        .stats-card {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border: none;
        }
        .stats-card.pending {
            background: linear-gradient(135deg, var(--warning-color), #f59e0b);
        }
        .stats-card.in-transit {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
        }
        .stats-card.delivered {
            background: linear-gradient(135deg, var(--success-color), #16a34a);
        }
        .cargo-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        .cargo-table th,
        .cargo-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        .cargo-table th {
            background-color: var(--bg-accent);
            font-weight: 600;
        }
        .cargo-table tr:hover {
            background-color: var(--bg-accent);
        }
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
        }
        .status-pending {
            background-color: #fef3c7;
            color: #92400e;
        }
        .status-in-transit {
            background-color: #dbeafe;
            color: #1e40af;
        }
        .status-delivered {
            background-color: #d1fae5;
            color: #065f46;
        }
        .quick-actions {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Welcome back, ${username}!</h1>
                <p class="page-subtitle">Track your shipments and monitor cargo status</p>
            </div>
            
            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="${contextPath}/track" class="btn btn-primary">
                    ï¿½ Track Shipments
                </a>
                <a href="${contextPath}/contact" class="btn btn-outline">
                    ï¿½ Contact Support
                </a>
                <a href="tel:+15551234567" class="btn btn-secondary">
                    ï¿½ Call Support
                </a>
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

            <!-- Quick Tracking Section -->
            <div class="card mb-6">
                <div class="card-header">
                    <h2 class="card-title">Quick Track</h2>
                </div>
                <div class="card-body">
                    <form action="${contextPath}/userDashboard" method="post">
                        <input type="hidden" name="action" value="addTracking">
                        <div style="display: flex; gap: 1rem; align-items: end;">
                            <div style="flex: 1;">
                                <label for="trackingNumber" class="form-label">Enter Tracking Number</label>
                                <input type="text" id="trackingNumber" name="trackingNumber" class="form-input" 
                                       placeholder="Enter tracking number (e.g., TRK-2025-0001)" 
                                       value="${param.trackingNumber}" required />
                                <small style="color: var(--text-secondary); margin-top: 0.25rem; display: block;">
                                    Get tracking numbers from your shipping administrator
                                </small>
                            </div>
                            <button type="submit" class="btn btn-primary">Add to Watchlist</button>
                        </div>
                    </form>
                    
                    <!-- Display tracked cargo info if found -->
                    <c:if test="${not empty trackedCargo}">
                        <div style="margin-top: 1.5rem; padding: 1rem; background-color: var(--bg-accent); border-radius: var(--radius-md);">
                            <h4 style="color: var(--success-color); margin-bottom: 1rem;">â Cargo Found!</h4>
                            <div class="grid grid-cols-2">
                                <div>
                                    <strong>Cargo Number:</strong> ${trackedCargo.cargoNumber}<br>
                                    <strong>From:</strong> ${trackedCargo.senderName}<br>
                                    <strong>To:</strong> ${trackedCargo.receiverName}<br>
                                    <strong>Status:</strong> 
                                    <c:choose>
                                        <c:when test="${trackedCargo.status eq 'Pending'}">
                                            <span class="status-badge status-pending">${trackedCargo.status}</span>
                                        </c:when>
                                        <c:when test="${trackedCargo.status eq 'In Transit'}">
                                            <span class="status-badge status-in-transit">${trackedCargo.status}</span>
                                        </c:when>
                                        <c:when test="${trackedCargo.status eq 'Delivered'}">
                                            <span class="status-badge status-delivered">${trackedCargo.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">${trackedCargo.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <strong>Destination:</strong> ${trackedCargo.receiverAddress}<br>
                                    <strong>Expected Delivery:</strong> 
                                    <c:choose>
                                        <c:when test="${not empty trackedCargo.expectedDeliveryDate}">
                                            <fmt:formatDate value="${trackedCargo.expectedDeliveryDate}" pattern="MMM dd, yyyy" />
                                        </c:when>
                                        <c:otherwise>TBD</c:otherwise>
                                    </c:choose><br>
                                    <strong>Tracking Number:</strong> ${trackedCargo.trackingNumber}
                                </div>
                            </div>
                            <div style="margin-top: 1rem;">
                                <a href="${contextPath}/track?cargo=${trackedCargo.cargoNumber}" class="btn btn-outline btn-sm">
                                    View Full Tracking Details
                                </a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="grid grid-cols-4 mb-8">
                <div class="card stats-card">
                    <div class="card-body text-center">
                        <div style="font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${totalTracked}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">Tracked Shipments</p>
                    </div>
                </div>
                
                <div class="card stats-card pending">
                    <div class="card-body text-center">
                        <div style="font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${pendingShipments}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">Pending</p>
                    </div>
                </div>
                
                <div class="card stats-card in-transit">
                    <div class="card-body text-center">
                        <div style="font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${inTransitShipments}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">In Transit</p>
                    </div>
                </div>
                
                <div class="card stats-card delivered">
                    <div class="card-body text-center">
                        <div style="font-size: 2.5rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${deliveredShipments}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">Delivered</p>
                    </div>
                </div>
            </div>
            
            <!-- Your Tracking Watchlist -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Your Tracking Watchlist</h2>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty userWatchlist}">
                            <table class="cargo-table">
                                <thead>
                                    <tr>
                                        <th>Tracking Number</th>
                                        <th>Cargo Number</th>
                                        <th>From To</th>
                                        <th>Status</th>
                                        <th>Expected Delivery</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cargo" items="${userWatchlist}">
                                        <tr>
                                            <td>
                                                <strong style="color: var(--primary-color);">
                                                    <c:choose>
                                                        <c:when test="${not empty cargo.trackingNumber}">
                                                            ${cargo.trackingNumber}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${cargo.cargoNumber}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </td>
                                            <td>
                                                <strong style="color: var(--secondary-color);">
                                                    <c:choose>
                                                        <c:when test="${not empty cargo.cargoNumber}">
                                                            ${cargo.cargoNumber}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-secondary);">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </strong>
                                            </td>
                                            <td>
                                                <div style="max-width: 250px;">
                                                    <c:choose>
                                                        <c:when test="${not empty cargo.senderName and not empty cargo.receiverName}">
                                                            <strong>${cargo.senderName}</strong><br>
                                                            <small style="color: var(--text-secondary);">${cargo.senderAddress}</small>
                                                            <div style="margin: 0.25rem 0; color: var(--text-light);">â</div>
                                                            <strong>${cargo.receiverName}</strong><br>
                                                            <small style="color: var(--text-secondary);">${cargo.receiverAddress}</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-secondary);">
                                                                <em>Details not available</em>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${cargo.status eq 'Pending'}">
                                                        <span class="status-badge status-pending">${cargo.status}</span>
                                                    </c:when>
                                                    <c:when test="${cargo.status eq 'In Transit'}">
                                                        <span class="status-badge status-in-transit">${cargo.status}</span>
                                                    </c:when>
                                                    <c:when test="${cargo.status eq 'Delivered'}">
                                                        <span class="status-badge status-delivered">${cargo.status}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge">${cargo.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty cargo.expectedDeliveryDate}">
                                                        ${cargo.expectedDeliveryDate}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: var(--text-secondary);">TBD</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                                                    <c:choose>
                                                        <c:when test="${not empty cargo.cargoNumber and cargo.cargoNumber ne 'N/A'}">
                                                            <a href="${contextPath}/track?trackingNumber=${cargo.cargoNumber}" 
                                                               class="btn btn-outline btn-sm">
                                                                ð Details
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="btn btn-outline btn-sm" style="opacity: 0.5; cursor: not-allowed;">
                                                                ð Details
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <form action="${contextPath}/userDashboard" method="post" style="display: inline;">
                                                        <input type="hidden" name="action" value="removeTracking">
                                                        <input type="hidden" name="trackingNumber" value="${not empty cargo.trackingNumber ? cargo.trackingNumber : cargo.cargoNumber}">
                                                        <button type="submit" class="btn btn-outline-danger btn-sm" 
                                                                onclick="return confirm('Remove this tracking number from your watchlist?')"
                                                                title="Remove from watchlist">
                                                            â Remove
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center p-8">
                                <div style="font-size: 4rem; color: var(--text-light); margin-bottom: 1rem;">ï¿½</div>
                                <h3 style="color: var(--text-secondary); margin-bottom: 1rem;">No Tracking Numbers Added</h3>
                                <p style="color: var(--text-secondary); margin-bottom: 2rem;">
                                    You haven't added any tracking numbers to your watchlist yet. Use the quick track section above to add tracking numbers and monitor shipments.
                                </p>
                                <div style="background-color: var(--bg-accent); padding: 1.5rem; border-radius: var(--radius-md);">
                                    <h4 style="color: var(--text-primary); margin-bottom: 1rem;">ð¡ How to track shipments:</h4>
                                    <ol style="text-align: left; color: var(--text-secondary);">
                                        <li style="margin-bottom: 0.5rem;">Get a tracking number from the shipping admin</li>
                                        <li style="margin-bottom: 0.5rem;">Enter the tracking number in the "Quick Track" section above</li>
                                        <li style="margin-bottom: 0.5rem;">The shipment will be added to your watchlist automatically</li>
                                        <li style="margin-bottom: 0.5rem;">Monitor status updates and delivery progress from your dashboard</li>
                                    </ol>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Help & Support Section -->
            <div class="grid grid-cols-2 mt-8">
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Need Help?</h3>
                    </div>
                    <div class="card-body">
                        <p class="mb-4">Our support team is here to assist you 24/7.</p>
                        <div style="display: flex; gap: 1rem;">
                            <a href="${contextPath}/contact" class="btn btn-outline">Contact Support</a>
                            <a href="tel:+15551234567" class="btn btn-secondary">Call Now</a>
                        </div>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Quick Tips</h3>
                    </div>
                    <div class="card-body">
                        <ul style="list-style: none; padding: 0;">
                            <li style="margin-bottom: 0.5rem;">Keep your tracking number handy</li>
                            <li style="margin-bottom: 0.5rem;">Ensure accurate receiver information</li>
                            <li style="margin-bottom: 0.5rem;">Consider cargo insurance for valuable items</li>
                            <li style="margin-bottom: 0.5rem;">Contact us immediately for any issues</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
