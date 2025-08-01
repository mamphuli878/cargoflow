<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="cargo" value="${requestScope.cargo}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Cargo - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <jsp:include page="../header.jsp" />
    
    <div class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Update Cargo Information</h1>
                <p class="page-subtitle">Modify cargo details and shipping information</p>
            </div>

            <!-- Display error message if available -->
            <c:if test="${not empty error}">
                <div class="card mb-4" style="border-left: 4px solid var(--danger-color);">
                    <div class="card-body">
                        <p style="color: var(--danger-color); margin: 0;">${error}</p>
                    </div>
                </div>
            </c:if>

            <!-- Display success message if available -->
            <c:if test="${not empty success}">
                <div class="card mb-4" style="border-left: 4px solid var(--success-color);">
                    <div class="card-body">
                        <p style="color: var(--success-color); margin: 0;">${success}</p>
                    </div>
                </div>
            </c:if>

            <!-- Show form only if cargo data is available -->
            <c:choose>
                <c:when test="${not empty cargo}">
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">Update Cargo Details</h2>
                            <p style="color: var(--text-secondary); margin-top: 0.5rem;">
                                Editing Cargo ID: <strong style="color: var(--primary-color);">#${cargo.cargoId}</strong> 
                                <span style="margin-left: 1rem;">Tracking: <strong>${cargo.cargoNumber}</strong></span>
                                <span style="margin-left: 1rem;">Current Status: <strong>${cargo.status}</strong></span>
                            </p>
                        </div>
                <div class="card-body">
                    <form action="${contextPath}/cargoUpdate" method="post" onsubmit="return validateForm()">
                        <!-- Hidden cargo ID that cannot be changed -->
                        <input type="hidden" name="cargoId" value="${cargo.cargoId}">

                        <!-- Cargo ID Display (Read-only) -->
                        <div class="form-group">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color); border-bottom: 2px solid var(--border-color); padding-bottom: 0.5rem;">
                                🆔 Cargo Identification (Read-Only)
                            </h3>
                        </div>

                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="cargoIdDisplay" class="form-label">Cargo ID</label>
                                <input type="text" id="cargoIdDisplay" name="cargoIdDisplay" 
                                       value="${cargo.cargoId}" class="form-input" 
                                       readonly style="background-color: var(--bg-accent); color: var(--text-secondary);">
                                <small style="color: var(--text-secondary);">This ID cannot be changed</small>
                            </div>
                            <div class="form-group">
                                <label for="cargoNumberDisplay" class="form-label">Cargo Number</label>
                                <input type="text" id="cargoNumberDisplay" name="cargoNumberDisplay" 
                                       value="${cargo.cargoNumber}" class="form-input"
                                       readonly style="background-color: var(--bg-accent); color: var(--text-secondary);">
                                <small style="color: var(--text-secondary);">Cargo number cannot be changed</small>
                                <!-- Hidden field for form submission -->
                                <input type="hidden" name="cargoNumber" value="${cargo.cargoNumber}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="trackingNumberDisplay" class="form-label">Tracking Number</label>
                            <input type="text" id="trackingNumberDisplay" name="trackingNumberDisplay" 
                                   value="${not empty cargo.trackingNumber ? cargo.trackingNumber : 'Auto-generated'}" class="form-input"
                                   readonly style="background-color: var(--bg-accent); color: var(--text-secondary);">
                            <small style="color: var(--text-secondary);">Tracking number cannot be changed</small>
                            <!-- Hidden field for form submission -->
                            <input type="hidden" name="trackingNumber" value="${cargo.trackingNumber}">
                        </div>

                        <!-- Basic Cargo Information -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color); border-bottom: 2px solid var(--border-color); padding-bottom: 0.5rem;">
                                📦 Basic Information
                            </h3>
                        </div>

                        <div class="grid grid-cols-1">
                            <div class="form-group">
                                <label for="cargoType" class="form-label">Cargo Type *</label>
                                <select id="cargoType" name="cargoType" class="form-select" required>
                                    <option value="">Select cargo type</option>
                                    <option value="Electronics" ${cargo.cargoType.name == 'Electronics' ? 'selected' : ''}>📱 Electronics</option>
                                    <option value="Furniture" ${cargo.cargoType.name == 'Furniture' ? 'selected' : ''}>🪑 Furniture</option>
                                    <option value="Documents" ${cargo.cargoType.name == 'Documents' ? 'selected' : ''}>📄 Documents</option>
                                    <option value="Clothing" ${cargo.cargoType.name == 'Clothing' ? 'selected' : ''}>👕 Clothing</option>
                                    <option value="Food" ${cargo.cargoType.name == 'Food' ? 'selected' : ''}>🍎 Food & Beverages</option>
                                    <option value="Medical" ${cargo.cargoType.name == 'Medical' ? 'selected' : ''}>💊 Medical Supplies</option>
                                    <option value="Other" ${cargo.cargoType.name == 'Other' ? 'selected' : ''}>📦 Other</option>
                                </select>
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.cargoType.name}">
                                        Current: <strong>${cargo.cargoType.name}</strong>
                                    </c:if>
                                </small>
                            </div>
                        </div>

                        <!-- Sender Information -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color); border-bottom: 2px solid var(--border-color); padding-bottom: 0.5rem;">
                                � Sender Information
                            </h3>
                        </div>

                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="senderName" class="form-label">Sender Name *</label>
                                <input type="text" id="senderName" name="senderName" 
                                       value="${cargo.senderName}" class="form-input" required
                                       placeholder="Full name of sender">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.senderName}">
                                        Current: <strong>${cargo.senderName}</strong>
                                    </c:if>
                                </small>
                            </div>
                            <div class="form-group">
                                <label for="senderPhone" class="form-label">Sender Phone</label>
                                <input type="tel" id="senderPhone" name="senderPhone" 
                                       value="${cargo.senderPhone}" class="form-input"
                                       placeholder="Phone number">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.senderPhone}">
                                        Current: <strong>${cargo.senderPhone}</strong>
                                    </c:if>
                                </small>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="senderAddress" class="form-label">Sender Address</label>
                            <textarea id="senderAddress" name="senderAddress" class="form-textarea" 
                                      rows="2" placeholder="Complete pickup address">${cargo.senderAddress}</textarea>
                            <small style="color: var(--text-secondary);">
                                <c:if test="${not empty cargo.senderAddress}">
                                    Current: <strong>${cargo.senderAddress}</strong>
                                </c:if>
                            </small>
                        </div>

                        <!-- Receiver Information -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color); border-bottom: 2px solid var(--border-color); padding-bottom: 0.5rem;">
                                📥 Receiver Information
                            </h3>
                        </div>

                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="receiverName" class="form-label">Receiver Name *</label>
                                <input type="text" id="receiverName" name="receiverName" 
                                       value="${cargo.receiverName}" class="form-input" required
                                       placeholder="Full name of receiver">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.receiverName}">
                                        Current: <strong>${cargo.receiverName}</strong>
                                    </c:if>
                                </small>
                            </div>
                            <div class="form-group">
                                <label for="receiverPhone" class="form-label">Receiver Phone</label>
                                <input type="tel" id="receiverPhone" name="receiverPhone" 
                                       value="${cargo.receiverPhone}" class="form-input"
                                       placeholder="Phone number">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.receiverPhone}">
                                        Current: <strong>${cargo.receiverPhone}</strong>
                                    </c:if>
                                </small>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="receiverAddress" class="form-label">Receiver Address</label>
                            <textarea id="receiverAddress" name="receiverAddress" class="form-textarea" 
                                      rows="2" placeholder="Complete delivery address">${cargo.receiverAddress}</textarea>
                            <small style="color: var(--text-secondary);">
                                <c:if test="${not empty cargo.receiverAddress}">
                                    Current: <strong>${cargo.receiverAddress}</strong>
                                </c:if>
                            </small>
                        </div>

                        <!-- Cargo Details -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color); border-bottom: 2px solid var(--border-color); padding-bottom: 0.5rem;">
                                📋 Cargo Details
                            </h3>
                        </div>

                        <div class="form-group">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-textarea" 
                                      rows="3" placeholder="Describe the cargo contents, special handling instructions, etc.">${cargo.description}</textarea>
                            <small style="color: var(--text-secondary);">
                                <c:if test="${not empty cargo.description}">
                                    Current: <strong>${cargo.description}</strong>
                                </c:if>
                            </small>
                        </div>

                        <div class="grid grid-cols-3">
                            <div class="form-group">
                                <label for="weight" class="form-label">Weight (kg) *</label>
                                <input type="number" id="weight" name="weight" step="0.01" min="0.01"
                                       value="${cargo.weight}" class="form-input" required
                                       placeholder="0.00">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.weight}">
                                        Current: <strong>${cargo.weight} kg</strong>
                                    </c:if>
                                </small>
                            </div>
                            <div class="form-group">
                                <label for="dimensions" class="form-label">Dimensions (LxWxH)</label>
                                <input type="text" id="dimensions" name="dimensions" 
                                       value="${cargo.dimensions}" class="form-input"
                                       placeholder="e.g., 30x20x15 cm">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.dimensions}">
                                        Current: <strong>${cargo.dimensions}</strong>
                                    </c:if>
                                </small>
                            </div>
                            <div class="form-group">
                                <label for="shippingCost" class="form-label">Shipping Cost ($) *</label>
                                <input type="number" id="shippingCost" name="shippingCost" step="0.01" min="0"
                                       value="${cargo.shippingCost}" class="form-input" required
                                       placeholder="0.00">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.shippingCost}">
                                        Current: <strong>$${cargo.shippingCost}</strong>
                                    </c:if>
                                </small>
                            </div>
                        </div>

                        <!-- Status and Dates -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color); border-bottom: 2px solid var(--border-color); padding-bottom: 0.5rem;">
                                📅 Status & Dates
                            </h3>
                        </div>

                        <div class="grid grid-cols-3">
                            <div class="form-group">
                                <label for="status" class="form-label">Status *</label>
                                <select id="status" name="status" class="form-select" required>
                                    <option value="">Select status</option>
                                    <option value="Pending" ${cargo.status == 'Pending' ? 'selected' : ''}>⏳ Pending</option>
                                    <option value="In Transit" ${cargo.status == 'In Transit' ? 'selected' : ''}>🚛 In Transit</option>
                                    <option value="Out for Delivery" ${cargo.status == 'Out for Delivery' ? 'selected' : ''}>🚚 Out for Delivery</option>
                                    <option value="Delivered" ${cargo.status == 'Delivered' ? 'selected' : ''}>✅ Delivered</option>
                                    <option value="Cancelled" ${cargo.status == 'Cancelled' ? 'selected' : ''}>❌ Cancelled</option>
                                    <option value="On Hold" ${cargo.status == 'On Hold' ? 'selected' : ''}>⏸️ On Hold</option>
                                </select>
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.status}">
                                        Current: <strong>${cargo.status}</strong>
                                    </c:if>
                                </small>
                            </div>
                            <div class="form-group">
                                <label for="shipmentDate" class="form-label">Shipment Date</label>
                                <input type="date" id="shipmentDate" name="shipmentDate" 
                                       value="${cargo.shipmentDate}" class="form-input">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.shipmentDate}">
                                        Current: <strong>${cargo.shipmentDate}</strong>
                                    </c:if>
                                </small>
                            </div>
                            <div class="form-group">
                                <label for="expectedDeliveryDate" class="form-label">Expected Delivery</label>
                                <input type="date" id="expectedDeliveryDate" name="expectedDeliveryDate" 
                                       value="${cargo.expectedDeliveryDate}" class="form-input">
                                <small style="color: var(--text-secondary);">
                                    <c:if test="${not empty cargo.expectedDeliveryDate}">
                                        Current: <strong>${cargo.expectedDeliveryDate}</strong>
                                    </c:if>
                                </small>
                            </div>
                        </div>

                        <!-- Additional Information -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color); border-bottom: 2px solid var(--border-color); padding-bottom: 0.5rem;">
                                📝 Additional Information
                            </h3>
                        </div>

                        <div class="form-group">
                            <label for="notes" class="form-label">Notes</label>
                            <textarea id="notes" name="notes" class="form-textarea" 
                                      rows="3" placeholder="Additional notes or special instructions">${cargo.notes}</textarea>
                            <small style="color: var(--text-secondary);">
                                <c:if test="${not empty cargo.notes}">
                                    Current: <strong>${cargo.notes}</strong>
                                </c:if>
                            </small>
                        </div>

                        <div class="card-footer">
                            <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                                <a href="${contextPath}/modifyCargo" class="btn btn-secondary">❌ Cancel</a>
                                <button type="submit" class="btn btn-primary">💾 Update Cargo</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Validation and Information -->
            <div class="card mt-6">
                <div class="card-header">
                    <h3 class="card-title">📋 Update Guidelines</h3>
                </div>
                <div class="card-body">
                    <div class="grid grid-cols-2">
                        <div>
                            <h4 style="margin-bottom: 1rem; color: var(--text-primary);">Required Fields</h4>
                            <ul style="list-style-type: disc; margin-left: 1.5rem; color: var(--text-secondary);">
                                <li>Cargo Number (must be unique)</li>
                                <li>Cargo Type (select appropriate category)</li>
                                <li>Sender and Receiver Names</li>
                                <li>Weight (minimum 0.01 kg)</li>
                                <li>Status (current shipment status)</li>
                                <li>Shipping Cost (minimum $0.00)</li>
                            </ul>
                        </div>
                        <div>
                            <h4 style="margin-bottom: 1rem; color: var(--text-primary);">Status Meanings</h4>
                            <ul style="list-style-type: disc; margin-left: 1.5rem; color: var(--text-secondary);">
                                <li><strong>Pending:</strong> Awaiting pickup or processing</li>
                                <li><strong>In Transit:</strong> Currently being transported</li>
                                <li><strong>Out for Delivery:</strong> Ready for final delivery</li>
                                <li><strong>Delivered:</strong> Successfully delivered to receiver</li>
                                <li><strong>On Hold:</strong> Temporarily delayed</li>
                                <li><strong>Cancelled:</strong> Shipment cancelled</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
                </c:when>
                <c:otherwise>
                    <!-- No cargo data available -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title" style="color: var(--danger-color);">⚠️ No Cargo Data Available</h2>
                        </div>
                        <div class="card-body text-center">
                            <p style="font-size: 1.1rem; color: var(--text-secondary); margin-bottom: 2rem;">
                                Unable to load cargo information. This could be due to:
                            </p>
                            <ul style="list-style: none; margin-bottom: 2rem; color: var(--text-secondary);">
                                <li style="margin-bottom: 0.5rem;">• Invalid cargo ID provided</li>
                                <li style="margin-bottom: 0.5rem;">• Cargo record not found in database</li>
                                <li style="margin-bottom: 0.5rem;">• Database connection issues</li>
                            </ul>
                            <div style="margin-top: 2rem;">
                                <a href="${contextPath}/modifyCargo" class="btn btn-primary">
                                    ← Back to Cargo Management
                                </a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <script>
                function validateForm() {
                    var weight = document.getElementById('weight').value;
                    var shippingCost = document.getElementById('shippingCost').value;
                    var cargoNumber = document.getElementById('cargoNumber').value;
                    var senderName = document.getElementById('senderName').value;
                    var receiverName = document.getElementById('receiverName').value;
                    var status = document.getElementById('status').value;
                    var cargoType = document.getElementById('cargoType').value;

                    if (!cargoNumber.trim()) {
                        alert('Cargo number is required.');
                        return false;
                    }

                    if (!cargoType) {
                        alert('Please select a cargo type.');
                        return false;
                    }

                    if (!senderName.trim()) {
                        alert('Sender name is required.');
                        return false;
                    }

                    if (!receiverName.trim()) {
                        alert('Receiver name is required.');
                        return false;
                    }

                    if (!weight || parseFloat(weight) <= 0) {
                        alert('Please enter a valid weight (must be greater than 0).');
                        return false;
                    }

                    if (!shippingCost || parseFloat(shippingCost) < 0) {
                        alert('Please enter a valid shipping cost (must be 0 or greater).');
                        return false;
                    }

                    if (!status) {
                        alert('Please select a status.');
                        return false;
                    }

                    return true;
                }

                // Add real-time validation feedback
                document.addEventListener('DOMContentLoaded', function() {
                    var inputs = document.querySelectorAll('.form-input, .form-select');
                    inputs.forEach(function(input) {
                        input.addEventListener('blur', function() {
                            if (this.hasAttribute('required') && !this.value.trim()) {
                                this.style.borderColor = 'var(--danger-color)';
                            } else {
                                this.style.borderColor = 'var(--border-color)';
                            }
                        });
                    });
                });
            </script>
        </div>
    </div>

    <jsp:include page="../footer.jsp" />
</body>
</html>
