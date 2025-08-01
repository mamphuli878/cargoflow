<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard - CargoFlow Management System</title>
<link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
	<%@ include file="../header.jsp" %>
	
	<main class="page-container">
		<div class="container">
			<div class="page-header">
				<h1 class="page-title">Admin Dashboard</h1>
				<p class="page-subtitle">Manage cargo operations and monitor system performance</p>
			</div>
			
			<!-- Quick Actions -->
			<div class="grid grid-cols-5 mb-8">
				<a href="${contextPath}/modifyCargo" class="card text-center" style="text-decoration: none; color: inherit;">
					<div class="card-body">
						<div style="font-size: 3rem; margin-bottom: 1rem;">📦</div>
						<h4 class="text-primary mb-2">Manage Cargo</h4>
						<p>View and edit cargo shipments</p>
					</div>
				</a>
				
				<a href="${contextPath}/cargoUpdate" class="card text-center" style="text-decoration: none; color: inherit;">
					<div class="card-body">
						<div style="font-size: 3rem; margin-bottom: 1rem;">✏️</div>
						<h4 class="text-primary mb-2">Update Status</h4>
						<p>Update cargo status and tracking</p>
					</div>
				</a>
				
				<a href="${contextPath}/registerCargo" class="card text-center" style="text-decoration: none; color: inherit;">
					<div class="card-body">
						<div style="font-size: 3rem; margin-bottom: 1rem;">➕</div>
						<h4 class="text-primary mb-2">Register Cargo</h4>
						<p>Add new cargo shipment</p>
					</div>
				</a>
				
				<a href="${contextPath}/shippingHistory" class="card text-center" style="text-decoration: none; color: inherit;">
					<div class="card-body">
						<div style="font-size: 3rem; margin-bottom: 1rem;">📋</div>
						<h4 class="text-primary mb-2">Shipping History</h4>
						<p>View complete shipping records</p>
					</div>
				</a>
				
				<a href="${contextPath}/track" class="card text-center" style="text-decoration: none; color: inherit;">
					<div class="card-body">
						<div style="font-size: 3rem; margin-bottom: 1rem;">🔍</div>
						<h4 class="text-primary mb-2">Track Cargo</h4>
						<p>Search and track shipments</p>
					</div>
				</a>
			</div>
			
			<!-- Dashboard Stats -->
			<div class="grid grid-cols-4 mb-8">
				<div class="card text-center">
					<div class="card-body">
						<div style="font-size: 2.5rem; color: var(--primary-color); margin-bottom: 0.5rem;">
							<c:choose>
								<c:when test="${not empty total}">${total}</c:when>
								<c:otherwise>125</c:otherwise>
							</c:choose>
						</div>
						<h4 class="text-primary mb-2">Total Cargo</h4>
						<p>All registered shipments</p>
					</div>
				</div>
				
				<div class="card text-center">
					<div class="card-body">
						<div style="font-size: 2.5rem; color: var(--success-color); margin-bottom: 0.5rem;">
							<c:choose>
								<c:when test="${not empty inTransit}">${inTransit}</c:when>
								<c:otherwise>89</c:otherwise>
							</c:choose>
						</div>
						<h4 class="text-success mb-2">In Transit</h4>
						<p>Currently shipping</p>
					</div>
				</div>
				
				<div class="card text-center">
					<div class="card-body">
						<div style="font-size: 2.5rem; color: var(--warning-color); margin-bottom: 0.5rem;">
							<c:choose>
								<c:when test="${not empty pending}">${pending}</c:when>
								<c:otherwise>23</c:otherwise>
							</c:choose>
						</div>
						<h4 class="text-warning mb-2">Pending</h4>
						<p>Awaiting processing</p>
					</div>
				</div>
				
				<div class="card text-center">
					<div class="card-body">
						<div style="font-size: 2.5rem; color: var(--success-color); margin-bottom: 0.5rem;">
							<c:choose>
								<c:when test="${not empty delivered}">${delivered}</c:when>
								<c:otherwise>13</c:otherwise>
							</c:choose>
						</div>
						<h4 class="text-success mb-2">Delivered</h4>
						<p>Completed shipments</p>
					</div>
				</div>
			</div>

			<!-- Recent Cargo Table -->
			<div class="card">
				<div class="card-header">
					<h3 class="card-title">📋 Recent Cargo Shipments</h3>
				</div>
				<div class="card-body" style="padding: 0;">
					<div style="overflow-x: auto;">
						<table style="width: 100%; border-collapse: collapse;">
							<thead>
								<tr style="background-color: var(--bg-secondary);">
									<th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color);">ID</th>
									<th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color);">Cargo Number</th>
									<th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color);">Sender</th>
									<th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color);">Receiver</th>
									<th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color);">Status</th>
									<th style="padding: 1rem; text-align: left; border-bottom: 1px solid var(--border-color);">Actions</th>
								</tr>
							</thead>
							<tbody>
								<c:choose>
									<c:when test="${not empty cargoList}">
										<c:forEach var="cargo" items="${cargoList}">
											<tr style="border-bottom: 1px solid var(--border-color);">
												<td style="padding: 1rem;">${cargo.cargoId}</td>
												<td style="padding: 1rem; font-weight: 500;">${cargo.cargoNumber}</td>
												<td style="padding: 1rem;">${cargo.senderName}</td>
												<td style="padding: 1rem;">${cargo.receiverName}</td>
												<td style="padding: 1rem;">
													<span class="status-badge status-${cargo.status.toLowerCase().replace(' ', '-')}">
														${cargo.status}
													</span>
												</td>
												<td style="padding: 1rem;">
													<a href="${contextPath}/cargoUpdate?id=${cargo.cargoId}" class="btn btn-sm btn-primary">Edit</a>
													<a href="${contextPath}/track?number=${cargo.cargoNumber}" class="btn btn-sm btn-secondary ml-2">Track</a>
												</td>
											</tr>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<tr>
											<td colspan="6" style="padding: 2rem; text-align: center; color: var(--text-secondary);">
												No cargo shipments found. <a href="${contextPath}/registerCargo">Register your first cargo</a>.
											</td>
										</tr>
									</c:otherwise>
								</c:choose>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
	</main>
	
	<style>
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
		
		.status-processing, .status-pending {
			background-color: #fef3c7;
			color: #92400e;
		}
		
		.ml-2 {
			margin-left: 0.5rem;
		}
	</style>
	
	<%@ include file="../footer.jsp" %>

</body>
</html>
