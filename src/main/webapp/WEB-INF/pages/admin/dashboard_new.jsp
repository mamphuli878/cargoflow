<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cargo Management Dashboard</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/dashboard.css" />
</head>
<body>

	<div class="container">
		<div class="sidebar">
			<ul class="nav">
				<li><a href="${contextPath}/dashboard"><span class="icon">🏠</span>
						Dashboard</a></li>
				<li><a href="${contextPath}/modifyCargo"><span class="icon">📦</span>
						Cargo List</a></li>
				<li><a href="${contextPath}/cargoUpdate"><span
						class="icon">✏️</span> Update Cargo</a></li>
				<li><a href="${contextPath}/registerCargo"><span class="icon">➕</span>
						Register Cargo</a></li>
				<li><a href="${contextPath}/track"><span class="icon">🔍</span>
						Track Cargo</a></li>
			</ul>
			<div class="logout">
				<form action="${contextPath}/logout" method="post">
					<input type="submit" class="nav-button" value="Logout" />
				</form>
			</div>
		</div>

		<div class="content">
			<div class="header">
				<div class="info-box">
					<h3>Total Cargo</h3>
					<p>${empty total ? 0 : total}</p>
				</div>
				<div class="info-box">
					<h3>Pending</h3>
					<p>${empty pending ? 0 : pending}</p>
				</div>
				<div class="info-box">
					<h3>In Transit</h3>
					<p>${empty inTransit ? 0 : inTransit}</p>
				</div>
				<div class="info-box">
					<h3>Delivered</h3>
					<p>${empty delivered ? 0 : delivered}</p>
				</div>
			</div>

			<div class="card">
				<div>
					<h2>Welcome to Cargo Management System!</h2>
					<p>Administrative Dashboard</p>
					<br /> <br />
					<p>Manage your cargo shipments efficiently and effortlessly with our 
						comprehensive management system. From cargo registration to delivery 
						tracking, everything you need is just a few clicks away.</p>
				</div>
				<img src="${contextPath}/resources/images/system/cargo.jpg"
					alt="cargo" style="max-width: 300px;">
			</div>

			<div class="table-container">
				<h3>Recent Cargo Shipments</h3>
				<table>
					<thead>
						<tr>
							<th>ID</th>
							<th>Cargo Number</th>
							<th>Sender</th>
							<th>Receiver</th>
							<th>Status</th>
						</tr>
					</thead>
					<tbody>
						<!-- Using JSTL forEach loop to display recent cargo data -->
						<c:forEach var="cargo" items="${cargoList}">
							<tr>
								<td>${cargo.cargoId}</td>
								<td>${cargo.cargoNumber}</td>
								<td>${cargo.senderName}</td>
								<td>${cargo.receiverName}</td>
								<td>${cargo.status}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>

</body>
</html>
