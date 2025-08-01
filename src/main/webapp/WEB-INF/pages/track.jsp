<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Track Cargo - CargoFlow Management System</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
	<%@ include file="header.jsp" %>
	
	<main class="page-container">
		<div class="container">
			<div class="page-header">
				<h1 class="page-title">Track Your Cargo</h1>
				<p class="page-subtitle">Enter your tracking number to get real-time cargo status updates</p>
			</div>
			
			<!-- Display error message if available -->
			<c:if test="${not empty error}">
				<div class="alert alert-danger mb-6">
					<c:out value="${error}"/>
				</div>
			</c:if>

			<!-- Display success message if available -->
			<c:if test="${not empty success}">
				<div class="alert alert-success mb-6">
					<c:out value="${success}"/>
				</div>
			</c:if>

			<!-- Tracking Form -->
			<div class="card mb-8">
				<div class="card-header">
					<h3 class="card-title">🔍 Enter Tracking Information</h3>
				</div>
				<div class="card-body">
					<form action="${contextPath}/track" method="post">
						<div class="grid grid-cols-2">
							<div class="form-group">
								<label for="trackingNumber" class="form-label">Tracking Number</label>
								<input type="text" id="trackingNumber" name="trackingNumber" 
									   value="${trackingNumber}" placeholder="Enter tracking number (e.g., TN123456789)" 
									   class="form-input" required>
							</div>
							<div class="form-group" style="display: flex; align-items: end;">
								<button type="submit" class="btn btn-primary" style="width: 100%;">Track Cargo</button>
							</div>
						</div>
					</form>
				</div>
			</div>

			<!-- Cargo Details Results -->
			<c:if test="${not empty cargo}">
				<div class="card">
					<div class="card-header">
						<h3 class="card-title">📦 Cargo Details</h3>
					</div>
					<div class="card-body">
						<div class="grid grid-cols-2 mb-6">
							<div>
								<h4 class="text-primary mb-3">Shipment Information</h4>
								<div style="margin-bottom: 1rem;">
									<strong>Cargo Number:</strong> ${cargo.cargoNumber}
								</div>
								<div style="margin-bottom: 1rem;">
									<strong>Description:</strong> ${cargo.description}
								</div>
								<div style="margin-bottom: 1rem;">
									<strong>Type:</strong> ${cargo.cargoType.name}
								</div>
								<div style="margin-bottom: 1rem;">
									<strong>Status:</strong> 
									<span class="status-badge status-${cargo.status.toLowerCase().replace(' ', '-')}">
										${cargo.status}
									</span>
								</div>
							</div>
							
							<div>
								<h4 class="text-primary mb-3">Sender & Receiver</h4>
								<div style="margin-bottom: 1rem;">
									<strong>Sender:</strong> ${cargo.senderName}
								</div>
								<div style="margin-bottom: 1rem;">
									<strong>Receiver:</strong> ${cargo.receiverName}
								</div>
								<div style="margin-bottom: 1rem;">
									<strong>Destination:</strong> ${cargo.receiverAddress}
								</div>
							</div>
						</div>
						
						<!-- Status Timeline -->
						<div style="border-top: 1px solid var(--border-color); padding-top: 1.5rem;">
							<h4 class="text-primary mb-4">📍 Tracking Timeline</h4>
							<div class="timeline">
								<div class="timeline-item completed">
									<div class="timeline-marker"></div>
									<div class="timeline-content">
										<h5>Package Received</h5>
										<p>Your cargo has been received at our facility</p>
										<span class="timeline-date">Today, 9:00 AM</span>
									</div>
								</div>
								<div class="timeline-item ${cargo.status == 'In Transit' or cargo.status == 'Delivered' ? 'completed' : 'pending'}">
									<div class="timeline-marker"></div>
									<div class="timeline-content">
										<h5>In Transit</h5>
										<p>Package is on its way to destination</p>
										<span class="timeline-date">
											<c:choose>
												<c:when test="${cargo.status == 'In Transit' or cargo.status == 'Delivered'}">
													Today, 2:30 PM
												</c:when>
												<c:otherwise>Pending</c:otherwise>
											</c:choose>
										</span>
									</div>
								</div>
								<div class="timeline-item ${cargo.status == 'Delivered' ? 'completed' : 'pending'}">
									<div class="timeline-marker"></div>
									<div class="timeline-content">
										<h5>Delivered</h5>
										<p>Package delivered to recipient</p>
										<span class="timeline-date">
											<c:choose>
												<c:when test="${cargo.status == 'Delivered'}">
													Today, 5:45 PM
												</c:when>
												<c:otherwise>Estimated tomorrow</c:otherwise>
											</c:choose>
										</span>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</c:if>
		</div>
	</main>
	
	<style>
		.alert {
			padding: 1rem;
			border-radius: var(--radius-md);
			margin-bottom: 1rem;
		}
		
		.alert-danger {
			background-color: #fee2e2;
			color: #991b1b;
			border: 1px solid #fecaca;
		}
		
		.alert-success {
			background-color: #d1fae5;
			color: #065f46;
			border: 1px solid #a7f3d0;
		}
		
		.status-badge {
			padding: 0.25rem 0.75rem;
			border-radius: 9999px;
			font-size: 0.75rem;
			font-weight: 500;
			text-transform: uppercase;
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
		
		.timeline {
			position: relative;
			padding-left: 2rem;
		}
		
		.timeline::before {
			content: '';
			position: absolute;
			left: 0.75rem;
			top: 0;
			bottom: 0;
			width: 2px;
			background-color: var(--border-color);
		}
		
		.timeline-item {
			position: relative;
			margin-bottom: 2rem;
		}
		
		.timeline-marker {
			position: absolute;
			left: -2rem;
			top: 0.25rem;
			width: 1rem;
			height: 1rem;
			border-radius: 50%;
			background-color: var(--bg-secondary);
			border: 2px solid var(--border-color);
		}
		
		.timeline-item.completed .timeline-marker {
			background-color: var(--success-color);
			border-color: var(--success-color);
		}
		
		.timeline-content h5 {
			margin-bottom: 0.25rem;
			color: var(--text-primary);
		}
		
		.timeline-content p {
			margin-bottom: 0.5rem;
			color: var(--text-secondary);
		}
		
		.timeline-date {
			font-size: 0.875rem;
			color: var(--text-light);
		}
	</style>
	
	<%@ include file="footer.jsp" %>
</body>
</html>
