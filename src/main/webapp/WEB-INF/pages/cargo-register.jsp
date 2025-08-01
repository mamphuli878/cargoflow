<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register New Cargo - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Ship New Cargo</h1>
                <p class="page-subtitle">Register a new cargo shipment for secure and reliable delivery</p>
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

            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Cargo Registration Form</h2>
                </div>
                <div class="card-body">
                    <form action="${contextPath}/registerCargo" method="post">
                        <!-- Cargo Information -->
                        <div class="form-group">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color);">📦 Cargo Information</h3>
                        </div>

                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="cargoNumber" class="form-label">Cargo Number (Auto-Generated) *</label>
                                <div style="display: flex; gap: 0.5rem; align-items: center;">
                                    <input type="text" id="cargoNumber" name="cargoNumber" class="form-input" 
                                           readonly value="${generatedCargoNumber}" 
                                           style="background-color: var(--bg-accent); color: var(--text-secondary); cursor: not-allowed; flex: 1;">
                                    <button type="button" onclick="generateNewCargoNumber()" class="btn btn-secondary btn-sm" 
                                            style="padding: 0.75rem; font-size: 0.75rem;" title="Generate New Cargo Number">
                                        🔄
                                    </button>
                                </div>
                                <small style="color: var(--text-secondary); font-style: italic;">
                                    🔄 This number is automatically generated and unique
                                </small>
                            </div>
                            <div class="form-group">
                                <label for="cargoType" class="form-label">Cargo Type *</label>
                                <select id="cargoType" name="cargoType" class="form-select" required>
                                    <option value="">Select cargo type</option>
                                    <option value="Electronics" ${param.cargoType == 'Electronics' ? 'selected' : ''}>Electronics</option>
                                    <option value="Furniture" ${param.cargoType == 'Furniture' ? 'selected' : ''}>Furniture</option>
                                    <option value="Documents" ${param.cargoType == 'Documents' ? 'selected' : ''}>Documents</option>
                                    <option value="Clothing" ${param.cargoType == 'Clothing' ? 'selected' : ''}>Clothing</option>
                                    <option value="Food" ${param.cargoType == 'Food' ? 'selected' : ''}>Food & Beverages</option>
                                    <option value="Medical" ${param.cargoType == 'Medical' ? 'selected' : ''}>Medical Supplies</option>
                                    <option value="Other" ${param.cargoType == 'Other' ? 'selected' : ''}>Other</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="description" class="form-label">Description</label>
                            <textarea id="description" name="description" class="form-textarea" 
                                      rows="3" placeholder="Describe the cargo contents, special handling instructions, etc.">${param.description}</textarea>
                        </div>

                        <div class="grid grid-cols-3">
                            <div class="form-group">
                                <label for="weight" class="form-label">Weight (kg) *</label>
                                <input type="number" id="weight" name="weight" step="0.01" min="0.01"
                                       class="form-input" required placeholder="0.00" value="${param.weight}">
                            </div>
                            <div class="form-group">
                                <label for="dimensions" class="form-label">Dimensions (LxWxH cm)</label>
                                <input type="text" id="dimensions" name="dimensions" class="form-input" 
                                       placeholder="e.g., 30x20x15" value="${param.dimensions}">
                            </div>
                            <div class="form-group">
                                <label for="shippingCost" class="form-label">Shipping Cost ($) *</label>
                                <input type="number" id="shippingCost" name="shippingCost" step="0.01" min="0"
                                       class="form-input" required placeholder="0.00" value="${param.shippingCost}">
                            </div>
                        </div>

                        <!-- Sender Information -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color);">📤 Sender Information</h3>
                        </div>

                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="senderName" class="form-label">Sender Name *</label>
                                <input type="text" id="senderName" name="senderName" class="form-input" 
                                       required placeholder="Full name" value="${param.senderName}">
                            </div>
                            <div class="form-group">
                                <label for="senderPhone" class="form-label">Phone Number *</label>
                                <input type="tel" id="senderPhone" name="senderPhone" class="form-input" 
                                       required placeholder="+1 (555) 123-4567" value="${param.senderPhone}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="senderAddress" class="form-label">Sender Address *</label>
                            <textarea id="senderAddress" name="senderAddress" class="form-textarea" 
                                      rows="2" required placeholder="Complete pickup address">${param.senderAddress}</textarea>
                        </div>

                        <!-- Receiver Information -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color);">📥 Receiver Information</h3>
                        </div>

                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="receiverName" class="form-label">Receiver Name *</label>
                                <input type="text" id="receiverName" name="receiverName" class="form-input" 
                                       required placeholder="Full name" value="${param.receiverName}">
                            </div>
                            <div class="form-group">
                                <label for="receiverPhone" class="form-label">Phone Number *</label>
                                <input type="tel" id="receiverPhone" name="receiverPhone" class="form-input" 
                                       required placeholder="+1 (555) 123-4567" value="${param.receiverPhone}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="receiverAddress" class="form-label">Receiver Address *</label>
                            <textarea id="receiverAddress" name="receiverAddress" class="form-textarea" 
                                      rows="2" required placeholder="Complete delivery address">${param.receiverAddress}</textarea>
                        </div>

                        <!-- Shipping Details -->
                        <div class="form-group mt-6">
                            <h3 style="margin-bottom: 1rem; color: var(--primary-color);">🚚 Shipping Details</h3>
                        </div>

                        <div class="grid grid-cols-2">
                            <div class="form-group">
                                <label for="shipmentDate" class="form-label">Shipment Date</label>
                                <input type="date" id="shipmentDate" name="shipmentDate" class="form-input" 
                                       value="${param.shipmentDate}">
                            </div>
                            <div class="form-group">
                                <label for="expectedDeliveryDate" class="form-label">Expected Delivery Date</label>
                                <input type="date" id="expectedDeliveryDate" name="expectedDeliveryDate" class="form-input" 
                                       value="${param.expectedDeliveryDate}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="status" class="form-label">Initial Status</label>
                            <select id="status" name="status" class="form-select">
                                <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                <option value="Ready for Pickup" ${param.status == 'Ready for Pickup' ? 'selected' : ''}>Ready for Pickup</option>
                            </select>
                        </div>

                        <div class="card-footer">
                            <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                                <a href="${contextPath}/userDashboard" class="btn btn-secondary">Cancel</a>
                                <button type="submit" class="btn btn-primary">Register Cargo</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Shipping Guidelines -->
            <div class="card mt-6">
                <div class="card-header">
                    <h3 class="card-title">📋 Shipping Guidelines</h3>
                </div>
                <div class="card-body">
                    <div class="grid grid-cols-2">
                        <div>
                            <h4 style="margin-bottom: 1rem; color: var(--text-primary);">Prohibited Items</h4>
                            <ul style="list-style-type: disc; margin-left: 1.5rem; color: var(--text-secondary);">
                                <li>Hazardous materials</li>
                                <li>Illegal substances</li>
                                <li>Perishable food items (unless refrigerated shipping)</li>
                                <li>Live animals</li>
                                <li>Valuable items over $10,000 (requires special insurance)</li>
                            </ul>
                        </div>
                        <div>
                            <h4 style="margin-bottom: 1rem; color: var(--text-primary);">Packaging Requirements</h4>
                            <ul style="list-style-type: disc; margin-left: 1.5rem; color: var(--text-secondary);">
                                <li>Use sturdy, appropriate packaging</li>
                                <li>Fragile items must be clearly marked</li>
                                <li>Electronics should be in anti-static packaging</li>
                                <li>Liquids must be sealed and in waterproof containers</li>
                                <li>Weight limit: 70kg per package</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        /**
         * Generates a new cargo number preview without checking database uniqueness.
         * The actual unique generation will be done server-side when the form is submitted.
         */
        function generateNewCargoNumber() {
            const currentYear = new Date().getFullYear();
            const randomNumber = String(Math.floor(Math.random() * 9999) + 1).padStart(4, '0');
            const newCargoNumber = `CG-${currentYear}-${randomNumber}`;
            
            document.getElementById('cargoNumber').value = newCargoNumber;
            
            // Show a brief animation to indicate the number was refreshed
            const cargoInput = document.getElementById('cargoNumber');
            cargoInput.style.transition = 'all 0.3s ease';
            cargoInput.style.backgroundColor = 'var(--success-color)';
            cargoInput.style.color = 'white';
            
            setTimeout(() => {
                cargoInput.style.backgroundColor = 'var(--bg-accent)';
                cargoInput.style.color = 'var(--text-secondary)';
            }, 500);
        }
    </script>

    <jsp:include page="footer.jsp" />
</body>
</html>
