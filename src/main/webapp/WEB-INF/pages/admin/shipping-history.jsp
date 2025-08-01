<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipping History - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
    <style>
        .history-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        .history-table th,
        .history-table td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
            font-size: 0.9rem;
        }
        .history-table th {
            background-color: var(--bg-accent);
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        .history-table tr:hover {
            background-color: var(--bg-accent);
        }
        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: var(--radius-sm);
            font-size: 0.7rem;
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
        .status-cancelled {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .stats-card {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border: none;
            text-align: center;
        }
        .stats-card.pending {
            background: linear-gradient(135deg, var(--warning-color), #f59e0b);
        }
        .stats-card.in-transit {
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
        }
        .stats-card.delivered {
            background: linear-gradient(135deg, var(--success-color), #16a34a);
        }
        .stats-card.cancelled {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }
        .table-container {
            max-height: 600px;
            overflow-y: auto;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-md);
        }
        .filter-controls {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
            align-items: center;
        }
        .filter-controls select,
        .filter-controls input {
            min-width: 150px;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">📋 Shipping History</h1>
                <p class="page-subtitle">Complete record of all cargo shipments</p>
                <div style="margin-top: 1rem;">
                    <a href="${contextPath}/dashboard" class="btn btn-outline">← Back to Dashboard</a>
                </div>
            </div>
            
            <!-- Display Messages -->
            <c:if test="${not empty error}">
                <div style="background-color: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                    ${error}
                </div>
            </c:if>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="card stats-card">
                    <div class="card-body">
                        <div style="font-size: 2rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${totalShipments}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">Total Shipments</p>
                    </div>
                </div>
                
                <div class="card stats-card pending">
                    <div class="card-body">
                        <div style="font-size: 2rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${pendingCount}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">Pending</p>
                    </div>
                </div>
                
                <div class="card stats-card in-transit">
                    <div class="card-body">
                        <div style="font-size: 2rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${inTransitCount}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">In Transit</p>
                    </div>
                </div>
                
                <div class="card stats-card delivered">
                    <div class="card-body">
                        <div style="font-size: 2rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${deliveredCount}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">Delivered</p>
                    </div>
                </div>
                
                <div class="card stats-card cancelled">
                    <div class="card-body">
                        <div style="font-size: 2rem; font-weight: bold; margin-bottom: 0.5rem;">
                            ${cancelledCount}
                        </div>
                        <p style="margin: 0; opacity: 0.9;">Cancelled</p>
                    </div>
                </div>
            </div>
            
            <!-- Shipping History Table -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">All Shipments</h2>
                </div>
                <div class="card-body">
                    <!-- Filter Controls -->
                    <div class="filter-controls">
                        <label>Filter by Status:</label>
                        <select id="statusFilter" class="form-input">
                            <option value="">All Statuses</option>
                            <option value="Pending">Pending</option>
                            <option value="In Transit">In Transit</option>
                            <option value="Delivered">Delivered</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                        
                        <label>Search:</label>
                        <input type="text" id="searchInput" class="form-input" placeholder="Search cargo number, sender, receiver...">
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty allCargo}">
                            <div class="table-container">
                                <table class="history-table" id="historyTable">
                                    <thead>
                                        <tr>
                                            <th>Cargo Number</th>
                                            <th>Tracking Number</th>
                                            <th>Sender</th>
                                            <th>Receiver</th>
                                            <th>Description</th>
                                            <th>Status</th>
                                            <th>Shipment Date</th>
                                            <th>Expected Delivery</th>
                                            <th>Cost</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cargo" items="${allCargo}">
                                            <tr>
                                                <td>
                                                    <strong style="color: var(--primary-color);">
                                                        ${cargo.cargoNumber}
                                                    </strong>
                                                </td>
                                                <td>
                                                    <code style="background-color: var(--bg-accent); padding: 0.25rem; border-radius: 3px;">
                                                        ${cargo.trackingNumber}
                                                    </code>
                                                </td>
                                                <td>
                                                    <div>
                                                        <strong>${cargo.senderName}</strong><br>
                                                        <small style="color: var(--text-secondary);">${cargo.senderPhone}</small>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div>
                                                        <strong>${cargo.receiverName}</strong><br>
                                                        <small style="color: var(--text-secondary);">${cargo.receiverPhone}</small>
                                                    </div>
                                                </td>
                                                <td style="max-width: 200px;">
                                                    <div style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" 
                                                         title="${cargo.description}">
                                                        ${cargo.description}
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
                                                        <c:when test="${cargo.status eq 'Cancelled'}">
                                                            <span class="status-badge status-cancelled">${cargo.status}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge">${cargo.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty cargo.shipmentDate}">
                                                            ${cargo.shipmentDate}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-secondary);">-</span>
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
                                                    <strong>$${cargo.shippingCost}</strong>
                                                </td>
                                                <td>
                                                    <div style="display: flex; gap: 0.25rem; flex-direction: column;">
                                                        <a href="${contextPath}/track?trackingNumber=${cargo.cargoNumber}" 
                                                           class="btn btn-outline btn-sm">
                                                            🔍 View
                                                        </a>
                                                        <a href="${contextPath}/cargoUpdate?cargoId=${cargo.cargoId}" 
                                                           class="btn btn-outline btn-sm">
                                                            ✏️ Edit
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center p-8">
                                <div style="font-size: 4rem; color: var(--text-light); margin-bottom: 1rem;">📋</div>
                                <h3 style="color: var(--text-secondary); margin-bottom: 1rem;">No Shipping Records Found</h3>
                                <p style="color: var(--text-secondary);">
                                    No cargo shipments have been registered yet.
                                </p>
                                <div style="margin-top: 2rem;">
                                    <a href="${contextPath}/registerCargo" class="btn btn-primary">
                                        ➕ Register First Cargo
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="../footer.jsp" %>
    
    <script>
        // Filter functionality
        document.getElementById('statusFilter').addEventListener('change', filterTable);
        document.getElementById('searchInput').addEventListener('input', filterTable);
        
        function filterTable() {
            const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const table = document.getElementById('historyTable');
            const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                
                // Get text content from relevant cells
                const cargoNumber = cells[0].textContent.toLowerCase();
                const trackingNumber = cells[1].textContent.toLowerCase();
                const sender = cells[2].textContent.toLowerCase();
                const receiver = cells[3].textContent.toLowerCase();
                const description = cells[4].textContent.toLowerCase();
                const status = cells[5].textContent.toLowerCase();
                
                // Check status filter
                const statusMatch = !statusFilter || status.includes(statusFilter);
                
                // Check search term
                const searchMatch = !searchTerm || 
                    cargoNumber.includes(searchTerm) ||
                    trackingNumber.includes(searchTerm) ||
                    sender.includes(searchTerm) ||
                    receiver.includes(searchTerm) ||
                    description.includes(searchTerm);
                
                // Show/hide row
                row.style.display = (statusMatch && searchMatch) ? '' : 'none';
            }
        }
    </script>
</body>
</html>
