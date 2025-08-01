<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipping History - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
    <style>
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .status-delivered {
            background-color: #d1fae5;
            color: #065f46;
        }
        
        .status-in-transit {
            background-color: #dbeafe;
            color: #1e40af;
        }
        
        .status-processing {
            background-color: #fef3c7;
            color: #92400e;
        }
        
        .status-cancelled {
            background-color: #fee2e2;
            color: #991b1b;
        }
        
        .shipment-row {
            border-bottom: 1px solid var(--border-color);
            transition: background-color 0.2s ease;
        }
        
        .shipment-row:hover {
            background-color: var(--bg-accent);
        }
        
        .shipment-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .shipment-table th,
        .shipment-table td {
            padding: 1rem;
            text-align: left;
            vertical-align: middle;
        }
        
        .shipment-table th {
            background-color: var(--bg-secondary);
            font-weight: 600;
            color: var(--text-primary);
            border-bottom: 2px solid var(--border-color);
        }
        
        .tracking-link {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        
        .tracking-link:hover {
            text-decoration: underline;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .summary-card {
            background: white;
            padding: 1.5rem;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            text-align: center;
            border-left: 4px solid var(--primary-color);
        }
        
        .summary-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .summary-label {
            color: var(--text-secondary);
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }
        
        .pagination a,
        .pagination span {
            padding: 0.5rem 1rem;
            border: 1px solid var(--border-color);
            border-radius: var(--radius-sm);
            text-decoration: none;
            color: var(--text-primary);
        }
        
        .pagination a:hover {
            background-color: var(--bg-accent);
        }
        
        .pagination .current {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        
        .mobile-shipment {
            display: none;
        }
        
        @media (max-width: 768px) {
            .desktop-table {
                display: none;
            }
            
            .mobile-shipment {
                display: block;
            }
            
            .mobile-shipment-card {
                background: white;
                border-radius: var(--radius-md);
                padding: 1rem;
                margin-bottom: 1rem;
                box-shadow: var(--shadow-sm);
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Shipping History</h1>
                <p class="page-subtitle">View and manage all your past shipments</p>
            </div>
            
            <!-- Summary Statistics -->
            <div class="summary-grid">
                <div class="summary-card">
                    <div class="summary-number">${statusCounts.total}</div>
                    <div class="summary-label">Total Shipments</div>
                </div>
                <div class="summary-card" style="border-left-color: #059669;">
                    <div class="summary-number" style="color: #059669;">${statusCounts.delivered}</div>
                    <div class="summary-label">Delivered</div>
                </div>
                <div class="summary-card" style="border-left-color: #2563eb;">
                    <div class="summary-number" style="color: #2563eb;">${statusCounts['in-transit']}</div>
                    <div class="summary-label">In Transit</div>
                </div>
                <div class="summary-card" style="border-left-color: #d97706;">
                    <div class="summary-number" style="color: #d97706;">${statusCounts.processing}</div>
                    <div class="summary-label">Processing</div>
                </div>
            </div>
            
            <!-- Filters -->
            <div class="card mb-6">
                <div class="card-header">
                    <h3 class="card-title">🔍 Filter Shipments</h3>
                </div>
                <div class="card-body">
                    <form action="${contextPath}/shipping-history" method="get">
                        <div class="grid grid-cols-3">
                            <div class="form-group">
                                <label for="status" class="form-label">Status</label>
                                <select id="status" name="status" class="form-select">
                                    <option value="all" ${selectedStatus == 'all' || empty selectedStatus ? 'selected' : ''}>All Statuses</option>
                                    <option value="delivered" ${selectedStatus == 'delivered' ? 'selected' : ''}>Delivered</option>
                                    <option value="in transit" ${selectedStatus == 'in transit' ? 'selected' : ''}>In Transit</option>
                                    <option value="processing" ${selectedStatus == 'processing' ? 'selected' : ''}>Processing</option>
                                    <option value="cancelled" ${selectedStatus == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="timeRange" class="form-label">Time Range</label>
                                <select id="timeRange" name="timeRange" class="form-select">
                                    <option value="all" ${selectedTimeRange == 'all' || empty selectedTimeRange ? 'selected' : ''}>All Time</option>
                                    <option value="last7days" ${selectedTimeRange == 'last7days' ? 'selected' : ''}>Last 7 Days</option>
                                    <option value="last30days" ${selectedTimeRange == 'last30days' ? 'selected' : ''}>Last 30 Days</option>
                                    <option value="last90days" ${selectedTimeRange == 'last90days' ? 'selected' : ''}>Last 90 Days</option>
                                    <option value="lastyear" ${selectedTimeRange == 'lastyear' ? 'selected' : ''}>Last Year</option>
                                </select>
                            </div>
                            
                            <div class="form-group" style="display: flex; align-items: end; gap: 0.5rem;">
                                <button type="submit" class="btn btn-primary">Filter</button>
                                <a href="${contextPath}/shipping-history" class="btn btn-secondary">Clear</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Results Header -->
            <div class="card">
                <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <h3 class="card-title">
                            Shipment History
                            <c:if test="${hasFilters}">
                                <span class="text-secondary">(Filtered Results)</span>
                            </c:if>
                        </h3>
                        <p style="margin: 0; color: var(--text-secondary);">
                            Showing ${shipments.size()} of ${totalItems} shipments
                        </p>
                    </div>
                    <div>
                        <a href="${contextPath}/cargo-registration" class="btn btn-primary">+ New Shipment</a>
                    </div>
                </div>
                
                <div class="card-body" style="padding: 0;">
                    <c:choose>
                        <c:when test="${not empty shipments}">
                            <!-- Desktop Table View -->
                            <div class="desktop-table">
                                <table class="shipment-table">
                                    <thead>
                                        <tr>
                                            <th>Tracking Number</th>
                                            <th>Status</th>
                                            <th>Service</th>
                                            <th>Route</th>
                                            <th>Ship Date</th>
                                            <th>Delivery</th>
                                            <th>Cost</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="shipment" items="${shipments}">
                                            <tr class="shipment-row">
                                                <td>
                                                    <a href="${contextPath}/track?number=${shipment.trackingNumber}" 
                                                       class="tracking-link">${shipment.trackingNumber}</a>
                                                </td>
                                                <td>
                                                    <span class="status-badge status-${shipment.status.toLowerCase().replace(' ', '-')}">
                                                        ${shipment.status}
                                                    </span>
                                                </td>
                                                <td>${shipment.service}</td>
                                                <td>
                                                    <div style="font-size: 0.875rem;">
                                                        <div><strong>From:</strong> ${shipment.origin}</div>
                                                        <div><strong>To:</strong> ${shipment.destination}</div>
                                                    </div>
                                                </td>
                                                <td>${shipment.shipDate}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${shipment.status == 'Delivered'}">
                                                            <span style="color: var(--success-color); font-weight: 500;">
                                                                ${shipment.deliveryDate}
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${shipment.status == 'Cancelled'}">
                                                            <span style="color: var(--danger-color);">Cancelled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="color: var(--text-secondary);">
                                                                Est: ${shipment.deliveryDate}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="font-weight: 500;">${shipment.cost}</td>
                                                <td>
                                                    <div style="display: flex; gap: 0.5rem;">
                                                        <a href="${contextPath}/track?number=${shipment.trackingNumber}" 
                                                           class="btn btn-sm btn-secondary">Track</a>
                                                        <c:if test="${shipment.status == 'Processing'}">
                                                            <button class="btn btn-sm btn-outline-danger">Cancel</button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- Mobile Card View -->
                            <div class="mobile-shipment">
                                <c:forEach var="shipment" items="${shipments}">
                                    <div class="mobile-shipment-card">
                                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                            <div>
                                                <h5 style="margin: 0;">
                                                    <a href="${contextPath}/track?number=${shipment.trackingNumber}" 
                                                       class="tracking-link">${shipment.trackingNumber}</a>
                                                </h5>
                                                <p style="margin: 0.25rem 0; color: var(--text-secondary);">${shipment.service}</p>
                                            </div>
                                            <span class="status-badge status-${shipment.status.toLowerCase().replace(' ', '-')}">
                                                ${shipment.status}
                                            </span>
                                        </div>
                                        
                                        <div style="margin-bottom: 1rem;">
                                            <p style="margin: 0.25rem 0;"><strong>From:</strong> ${shipment.origin}</p>
                                            <p style="margin: 0.25rem 0;"><strong>To:</strong> ${shipment.destination}</p>
                                            <p style="margin: 0.25rem 0;"><strong>Shipped:</strong> ${shipment.shipDate}</p>
                                            <p style="margin: 0.25rem 0;"><strong>Cost:</strong> ${shipment.cost}</p>
                                        </div>
                                        
                                        <div style="display: flex; gap: 0.5rem;">
                                            <a href="${contextPath}/track?number=${shipment.trackingNumber}" 
                                               class="btn btn-sm btn-primary">Track</a>
                                            <c:if test="${shipment.status == 'Processing'}">
                                                <button class="btn btn-sm btn-outline-danger">Cancel</button>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            
                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <div class="pagination">
                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}&status=${selectedStatus}&timeRange=${selectedTimeRange}">
                                            ← Previous
                                        </a>
                                    </c:if>
                                    
                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <span class="current">${i}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="?page=${i}&status=${selectedStatus}&timeRange=${selectedTimeRange}">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    
                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}&status=${selectedStatus}&timeRange=${selectedTimeRange}">
                                            Next →
                                        </a>
                                    </c:if>
                                </div>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 3rem;">
                                <div style="font-size: 4rem; margin-bottom: 1rem;">📦</div>
                                <h3>No Shipments Found</h3>
                                <p style="color: var(--text-secondary); margin-bottom: 2rem;">
                                    <c:choose>
                                        <c:when test="${hasFilters}">
                                            No shipments match your current filters. Try adjusting your search criteria.
                                        </c:when>
                                        <c:otherwise>
                                            You haven't made any shipments yet. Ready to send your first package?
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <a href="${contextPath}/cargo-registration" class="btn btn-primary">Create New Shipment</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
