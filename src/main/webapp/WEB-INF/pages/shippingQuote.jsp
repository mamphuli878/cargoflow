<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shipping Quote - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Get Shipping Quote</h1>
                <p class="page-subtitle">Calculate shipping costs and delivery times for your cargo</p>
            </div>
            
            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div style="background-color: #fef2f2; border: 1px solid #fecaca; color: #991b1b; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 2rem;">
                    ${errorMessage}
                </div>
            </c:if>
            
            <div class="grid grid-cols-2">
                <!-- Quote Form -->
                <div>
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">📦 Shipment Details</h3>
                        </div>
                        <div class="card-body">
                            <form action="${contextPath}/quote" method="post">
                                <!-- Origin and Destination -->
                                <div class="grid grid-cols-2">
                                    <div class="form-group">
                                        <label for="fromCountry" class="form-label">From Country *</label>
                                        <select id="fromCountry" name="fromCountry" class="form-select" required>
                                            <option value="">Select country</option>
                                            <option value="United States" ${fromCountry == 'United States' ? 'selected' : ''}>United States</option>
                                            <option value="Canada" ${fromCountry == 'Canada' ? 'selected' : ''}>Canada</option>
                                            <option value="Mexico" ${fromCountry == 'Mexico' ? 'selected' : ''}>Mexico</option>
                                            <option value="United Kingdom" ${fromCountry == 'United Kingdom' ? 'selected' : ''}>United Kingdom</option>
                                            <option value="Germany" ${fromCountry == 'Germany' ? 'selected' : ''}>Germany</option>
                                            <option value="France" ${fromCountry == 'France' ? 'selected' : ''}>France</option>
                                            <option value="China" ${fromCountry == 'China' ? 'selected' : ''}>China</option>
                                            <option value="Japan" ${fromCountry == 'Japan' ? 'selected' : ''}>Japan</option>
                                            <option value="Australia" ${fromCountry == 'Australia' ? 'selected' : ''}>Australia</option>
                                        </select>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="toCountry" class="form-label">To Country *</label>
                                        <select id="toCountry" name="toCountry" class="form-select" required>
                                            <option value="">Select country</option>
                                            <option value="United States" ${toCountry == 'United States' ? 'selected' : ''}>United States</option>
                                            <option value="Canada" ${toCountry == 'Canada' ? 'selected' : ''}>Canada</option>
                                            <option value="Mexico" ${toCountry == 'Mexico' ? 'selected' : ''}>Mexico</option>
                                            <option value="United Kingdom" ${toCountry == 'United Kingdom' ? 'selected' : ''}>United Kingdom</option>
                                            <option value="Germany" ${toCountry == 'Germany' ? 'selected' : ''}>Germany</option>
                                            <option value="France" ${toCountry == 'France' ? 'selected' : ''}>France</option>
                                            <option value="China" ${toCountry == 'China' ? 'selected' : ''}>China</option>
                                            <option value="Japan" ${toCountry == 'Japan' ? 'selected' : ''}>Japan</option>
                                            <option value="Australia" ${toCountry == 'Australia' ? 'selected' : ''}>Australia</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="grid grid-cols-2">
                                    <div class="form-group">
                                        <label for="fromCity" class="form-label">From City *</label>
                                        <input type="text" id="fromCity" name="fromCity" class="form-input" 
                                               value="${fromCity}" placeholder="e.g., New York" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="toCity" class="form-label">To City *</label>
                                        <input type="text" id="toCity" name="toCity" class="form-input" 
                                               value="${toCity}" placeholder="e.g., Los Angeles" required>
                                    </div>
                                </div>
                                
                                <!-- Shipping Type -->
                                <div class="form-group">
                                    <label for="shippingType" class="form-label">Shipping Service *</label>
                                    <select id="shippingType" name="shippingType" class="form-select" required>
                                        <option value="">Select service</option>
                                        <option value="ground" ${selectedShippingType == 'ground' ? 'selected' : ''}>Ground Shipping (2-5 days)</option>
                                        <option value="express" ${selectedShippingType == 'express' ? 'selected' : ''}>Express Shipping (1-3 days)</option>
                                        <option value="overnight" ${selectedShippingType == 'overnight' ? 'selected' : ''}>Overnight Delivery</option>
                                        <option value="international" ${selectedShippingType == 'international' ? 'selected' : ''}>International Shipping</option>
                                    </select>
                                </div>
                                
                                <!-- Package Details -->
                                <div class="form-group">
                                    <label for="weight" class="form-label">Weight (kg) *</label>
                                    <input type="number" id="weight" name="weight" class="form-input" 
                                           value="${originalWeight}" step="0.1" min="0.1" max="1000" placeholder="e.g., 5.5" required>
                                </div>
                                
                                <div class="grid grid-cols-3">
                                    <div class="form-group">
                                        <label for="length" class="form-label">Length (cm) *</label>
                                        <input type="number" id="length" name="length" class="form-input" 
                                               value="${originalLength}" step="0.1" min="1" max="200" placeholder="50" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="width" class="form-label">Width (cm) *</label>
                                        <input type="number" id="width" name="width" class="form-input" 
                                               value="${originalWidth}" step="0.1" min="1" max="200" placeholder="30" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="height" class="form-label">Height (cm) *</label>
                                        <input type="number" id="height" name="height" class="form-input" 
                                               value="${originalHeight}" step="0.1" min="1" max="200" placeholder="20" required>
                                    </div>
                                </div>
                                
                                <button type="submit" class="btn btn-primary" style="width: 100%;">
                                    Calculate Quote
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                
                <!-- Quote Results or Info -->
                <div>
                    <c:choose>
                        <c:when test="${quoteCalculated}">
                            <!-- Quote Results -->
                            <div class="card mb-6">
                                <div class="card-header" style="background: linear-gradient(135deg, var(--success-color), #16a34a); color: white;">
                                    <h3 style="color: white; margin: 0;">✅ Quote Calculated</h3>
                                </div>
                                <div class="card-body">
                                    <div class="mb-4">
                                        <h4 class="text-primary mb-2">Route</h4>
                                        <p><strong>From:</strong> ${fromLocation}</p>
                                        <p><strong>To:</strong> ${toLocation}</p>
                                        <p><strong>Service:</strong> ${shippingType}</p>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <h4 class="text-primary mb-2">Package Details</h4>
                                        <p><strong>Weight:</strong> ${weight} kg</p>
                                        <p><strong>Dimensions:</strong> ${dimensions}</p>
                                        <p><strong>Volume:</strong> ${volume} L</p>
                                        <p><strong>Chargeable Weight:</strong> ${chargeableWeight} kg</p>
                                    </div>
                                    
                                    <div style="background-color: var(--bg-accent); padding: 1.5rem; border-radius: var(--radius-md); margin-bottom: 1rem;">
                                        <div style="display: flex; justify-content: space-between; align-items: center;">
                                            <span style="font-size: 1.125rem; font-weight: 600;">Total Cost:</span>
                                            <span style="font-size: 2rem; font-weight: bold; color: var(--primary-color);">$${totalCost}</span>
                                        </div>
                                        <div style="display: flex; justify-content: space-between; margin-top: 0.5rem;">
                                            <span>Estimated Delivery:</span>
                                            <strong>${deliveryMin}-${deliveryMax} business days</strong>
                                        </div>
                                    </div>
                                    
                                    <div style="display: flex; gap: 1rem;">
                                        <a href="${contextPath}/register" class="btn btn-primary" style="flex: 1;">Book Shipment</a>
                                        <button onclick="window.print()" class="btn btn-secondary">Print Quote</button>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Information Card -->
                            <div class="card mb-6">
                                <div class="card-header">
                                    <h3 class="card-title">💡 Shipping Information</h3>
                                </div>
                                <div class="card-body">
                                    <div class="mb-4">
                                        <h4 class="text-primary mb-2">Service Types</h4>
                                        <ul style="list-style: none; padding: 0;">
                                            <li style="margin-bottom: 0.5rem;">🚚 <strong>Ground:</strong> Cost-effective for non-urgent shipments</li>
                                            <li style="margin-bottom: 0.5rem;">⚡ <strong>Express:</strong> Faster delivery for important packages</li>
                                            <li style="margin-bottom: 0.5rem;">🚀 <strong>Overnight:</strong> Next-day delivery available</li>
                                            <li style="margin-bottom: 0.5rem;">🌍 <strong>International:</strong> Worldwide shipping with customs clearance</li>
                                        </ul>
                                    </div>
                                    
                                    <div class="mb-4">
                                        <h4 class="text-primary mb-2">Pricing Factors</h4>
                                        <ul style="list-style: none; padding: 0;">
                                            <li style="margin-bottom: 0.5rem;">📏 Package dimensions and weight</li>
                                            <li style="margin-bottom: 0.5rem;">📍 Distance and destination</li>
                                            <li style="margin-bottom: 0.5rem;">⏱️ Delivery speed selected</li>
                                            <li style="margin-bottom: 0.5rem;">🛡️ Insurance and handling requirements</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Quick Tips -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">💡 Shipping Tips</h3>
                        </div>
                        <div class="card-body">
                            <ul style="list-style: none; padding: 0;">
                                <li style="margin-bottom: 1rem;">
                                    <strong>📦 Package Properly:</strong> Use adequate padding and sturdy boxes to prevent damage during transit.
                                </li>
                                <li style="margin-bottom: 1rem;">
                                    <strong>📋 Label Clearly:</strong> Ensure addresses are complete and legible for smooth delivery.
                                </li>
                                <li style="margin-bottom: 1rem;">
                                    <strong>🛡️ Consider Insurance:</strong> Protect valuable items with our comprehensive insurance options.
                                </li>
                                <li>
                                    <strong>📱 Track Your Shipment:</strong> Use our real-time tracking for peace of mind.
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
