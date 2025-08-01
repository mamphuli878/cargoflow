<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">My Profile</h1>
                <p class="page-subtitle">Manage your account information and preferences</p>
            </div>
            
            <!-- Success Message -->
            <c:if test="${not empty successMessage}">
                <div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; color: #166534; padding: 1rem; border-radius: var(--radius-md); margin-bottom: 2rem;">
                    ${successMessage}
                </div>
            </c:if>
            
            <div class="grid grid-cols-3">
                <!-- Profile Overview -->
                <div>
                    <div class="card mb-6">
                        <div class="card-header">
                            <h3 class="card-title">Profile Overview</h3>
                        </div>
                        <div class="card-body text-center">
                            <div style="width: 80px; height: 80px; background: linear-gradient(135deg, var(--primary-color), var(--primary-dark)); border-radius: 50%; margin: 0 auto 1rem; display: flex; align-items: center; justify-content: center; color: white; font-size: 2rem; font-weight: bold;">
                                ${firstName.charAt(0)}${lastName.charAt(0)}
                            </div>
                            <h4 class="text-primary mb-2">${firstName} ${lastName}</h4>
                            <p class="text-secondary mb-4">${email}</p>
                            <div style="background-color: var(--bg-accent); padding: 1rem; border-radius: var(--radius-md);">
                                <div class="grid grid-cols-2" style="gap: 1rem;">
                                    <div>
                                        <div class="text-primary font-bold">${totalShipments}</div>
                                        <div style="font-size: 0.75rem;">Total Shipments</div>
                                    </div>
                                    <div>
                                        <div class="text-success font-bold">${activeShipments}</div>
                                        <div style="font-size: 0.75rem;">Active Orders</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Account Stats -->
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Account Statistics</h3>
                        </div>
                        <div class="card-body">
                            <div class="mb-4">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                    <span>Member Since</span>
                                    <strong>${joinDate}</strong>
                                </div>
                            </div>
                            <div class="mb-4">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                    <span>Account Status</span>
                                    <span class="text-success font-bold">Active</span>
                                </div>
                            </div>
                            <div class="mb-4">
                                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                                    <span>Loyalty Level</span>
                                    <span class="text-warning font-bold">Gold</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Profile Form -->
                <div style="grid-column: span 2;">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">Personal Information</h3>
                        </div>
                        <div class="card-body">
                            <form action="${contextPath}/profile" method="post">
                                <div class="grid grid-cols-2">
                                    <div class="form-group">
                                        <label for="firstName" class="form-label">First Name *</label>
                                        <input type="text" id="firstName" name="firstName" class="form-input" 
                                               value="${firstName}" required>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="lastName" class="form-label">Last Name *</label>
                                        <input type="text" id="lastName" name="lastName" class="form-input" 
                                               value="${lastName}" required>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="email" class="form-label">Email Address *</label>
                                    <input type="email" id="email" name="email" class="form-input" 
                                           value="${email}" required>
                                </div>
                                
                                <div class="form-group">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" id="phone" name="phone" class="form-input" 
                                           value="${phone}">
                                </div>
                                
                                <div class="form-group">
                                    <label for="address" class="form-label">Address</label>
                                    <textarea id="address" name="address" rows="3" class="form-textarea" 
                                        placeholder="123 Main Street, City, State, ZIP">123 Business Ave, Suite 100
New York, NY 10001</textarea>
                                </div>
                                
                                <div class="grid grid-cols-2">
                                    <div class="form-group">
                                        <label for="company" class="form-label">Company</label>
                                        <input type="text" id="company" name="company" class="form-input" 
                                               value="TechCorp Solutions" placeholder="Your company name">
                                    </div>
                                    
                                    <div class="form-group">
                                        <label for="timezone" class="form-label">Timezone</label>
                                        <select id="timezone" name="timezone" class="form-select">
                                            <option value="EST" selected>Eastern Time (EST)</option>
                                            <option value="CST">Central Time (CST)</option>
                                            <option value="MST">Mountain Time (MST)</option>
                                            <option value="PST">Pacific Time (PST)</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label">Notification Preferences</label>
                                    <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                                        <label style="display: flex; align-items: center; gap: 0.5rem;">
                                            <input type="checkbox" name="notifications[]" value="email" checked>
                                            <span>Email notifications for shipment updates</span>
                                        </label>
                                        <label style="display: flex; align-items: center; gap: 0.5rem;">
                                            <input type="checkbox" name="notifications[]" value="sms" checked>
                                            <span>SMS notifications for delivery alerts</span>
                                        </label>
                                        <label style="display: flex; align-items: center; gap: 0.5rem;">
                                            <input type="checkbox" name="notifications[]" value="marketing">
                                            <span>Marketing and promotional emails</span>
                                        </label>
                                    </div>
                                </div>
                                
                                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                    <button type="button" class="btn btn-secondary" onclick="location.reload()">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Security Settings -->
                    <div class="card mt-6">
                        <div class="card-header">
                            <h3 class="card-title">Security Settings</h3>
                        </div>
                        <div class="card-body">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                <div>
                                    <h4>Change Password</h4>
                                    <p class="text-secondary" style="margin: 0;">Update your account password</p>
                                </div>
                                <button class="btn btn-outline">Change Password</button>
                            </div>
                            
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                                <div>
                                    <h4>Two-Factor Authentication</h4>
                                    <p class="text-secondary" style="margin: 0;">Add an extra layer of security</p>
                                </div>
                                <button class="btn btn-success">Enable 2FA</button>
                            </div>
                            
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div>
                                    <h4>Login Sessions</h4>
                                    <p class="text-secondary" style="margin: 0;">Manage active login sessions</p>
                                </div>
                                <button class="btn btn-secondary">View Sessions</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
