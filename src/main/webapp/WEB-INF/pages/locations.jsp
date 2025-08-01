<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Locations - CargoFlow Management System</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/main.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <main class="page-container">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Our Locations</h1>
                <p class="page-subtitle">Find CargoFlow service centers and distribution hubs worldwide</p>
            </div>
            
            <!-- Search Section -->
            <div class="card mb-8">
                <div class="card-header">
                    <h3 class="card-title">🔍 Find a Location Near You</h3>
                </div>
                <div class="card-body">
                    <form action="${contextPath}/locations" method="get">
                        <div class="grid grid-cols-3">
                            <div class="form-group">
                                <label for="city" class="form-label">City</label>
                                <input type="text" id="city" name="city" class="form-input" 
                                       value="${searchCity}" placeholder="Enter city name">
                            </div>
                            
                            <div class="form-group">
                                <label for="country" class="form-label">Country</label>
                                <select id="country" name="country" class="form-select">
                                    <option value="">All Countries</option>
                                    <option value="United States" ${searchCountry == 'United States' ? 'selected' : ''}>United States</option>
                                    <option value="Canada" ${searchCountry == 'Canada' ? 'selected' : ''}>Canada</option>
                                    <option value="United Kingdom" ${searchCountry == 'United Kingdom' ? 'selected' : ''}>United Kingdom</option>
                                    <option value="Germany" ${searchCountry == 'Germany' ? 'selected' : ''}>Germany</option>
                                    <option value="France" ${searchCountry == 'France' ? 'selected' : ''}>France</option>
                                    <option value="China" ${searchCountry == 'China' ? 'selected' : ''}>China</option>
                                    <option value="Japan" ${searchCountry == 'Japan' ? 'selected' : ''}>Japan</option>
                                    <option value="Australia" ${searchCountry == 'Australia' ? 'selected' : ''}>Australia</option>
                                </select>
                            </div>
                            
                            <div class="form-group" style="display: flex; align-items: end;">
                                <button type="submit" class="btn btn-primary" style="width: 100%;">Search Locations</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Search Results -->
            <c:if test="${searchPerformed}">
                <div class="card mb-8">
                    <div class="card-header">
                        <h3 class="card-title">Search Results</h3>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty searchResults}">
                                <p class="mb-4">Found ${searchResults.size()} location(s) matching your search:</p>
                                <div class="grid grid-cols-2">
                                    <c:forEach var="location" items="${searchResults}">
                                        <div class="card mb-4">
                                            <div class="card-body">
                                                <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                                    <h4 class="text-primary">${location.name}</h4>
                                                    <span class="text-xs" style="background-color: var(--bg-accent); padding: 0.25rem 0.5rem; border-radius: var(--radius-sm); text-transform: capitalize;">
                                                        ${location.type}
                                                    </span>
                                                </div>
                                                <p style="margin-bottom: 0.5rem;">📍 ${location.address}</p>
                                                <p style="margin-bottom: 0.5rem;">${location.city}<c:if test="${not empty location.state}">, ${location.state}</c:if>, ${location.country} ${location.zip}</p>
                                                <p style="margin-bottom: 0.5rem;">📞 ${location.phone}</p>
                                                <p class="text-secondary">🕒 ${location.hours}</p>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 2rem;">
                                    <p>No locations found matching your search criteria.</p>
                                    <button onclick="location.href='${contextPath}/locations'" class="btn btn-secondary mt-4">View All Locations</button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
            
            <!-- Location Categories -->
            <div class="grid grid-cols-4 mb-8">
                <div class="card text-center">
                    <div class="card-body">
                        <div style="font-size: 3rem; margin-bottom: 1rem;">🏢</div>
                        <h4 class="text-primary mb-2">Regional Hubs</h4>
                        <p>Major distribution centers with full services</p>
                    </div>
                </div>
                
                <div class="card text-center">
                    <div class="card-body">
                        <div style="font-size: 3rem; margin-bottom: 1rem;">📦</div>
                        <h4 class="text-primary mb-2">Distribution Centers</h4>
                        <p>Local facilities for package sorting</p>
                    </div>
                </div>
                
                <div class="card text-center">
                    <div class="card-body">
                        <div style="font-size: 3rem; margin-bottom: 1rem;">🚢</div>
                        <h4 class="text-primary mb-2">Port Facilities</h4>
                        <p>International shipping and customs</p>
                    </div>
                </div>
                
                <div class="card text-center">
                    <div class="card-body">
                        <div style="font-size: 3rem; margin-bottom: 1rem;">🏪</div>
                        <h4 class="text-primary mb-2">Service Centers</h4>
                        <p>Customer service and pickup points</p>
                    </div>
                </div>
            </div>
            
            <!-- All Locations by Region -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">🌍 All Locations</h3>
                </div>
                <div class="card-body">
                    <!-- North America -->
                    <div class="mb-6">
                        <h4 class="text-primary mb-3">🇺🇸 North America</h4>
                        <div class="grid grid-cols-2">
                            <c:forEach var="location" items="${locations}">
                                <c:if test="${location.country == 'United States' || location.country == 'Canada'}">
                                    <div class="card mb-4" style="border-left: 4px solid var(--primary-color);">
                                        <div class="card-body">
                                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                                <h5 class="text-primary">${location.name}</h5>
                                                <span class="text-xs" style="background-color: var(--primary-color); color: white; padding: 0.25rem 0.5rem; border-radius: var(--radius-sm); text-transform: capitalize;">
                                                    ${location.type}
                                                </span>
                                            </div>
                                            <p style="margin-bottom: 0.5rem;">📍 ${location.address}</p>
                                            <p style="margin-bottom: 0.5rem;">${location.city}<c:if test="${not empty location.state}">, ${location.state}</c:if>, ${location.country} ${location.zip}</p>
                                            <p style="margin-bottom: 0.5rem;">📞 ${location.phone}</p>
                                            <p class="text-secondary">🕒 ${location.hours}</p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <!-- Europe -->
                    <div class="mb-6">
                        <h4 class="text-success mb-3">🇪🇺 Europe</h4>
                        <div class="grid grid-cols-2">
                            <c:forEach var="location" items="${locations}">
                                <c:if test="${location.country == 'United Kingdom' || location.country == 'Germany' || location.country == 'France'}">
                                    <div class="card mb-4" style="border-left: 4px solid var(--success-color);">
                                        <div class="card-body">
                                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                                <h5 class="text-success">${location.name}</h5>
                                                <span class="text-xs" style="background-color: var(--success-color); color: white; padding: 0.25rem 0.5rem; border-radius: var(--radius-sm); text-transform: capitalize;">
                                                    ${location.type}
                                                </span>
                                            </div>
                                            <p style="margin-bottom: 0.5rem;">📍 ${location.address}</p>
                                            <p style="margin-bottom: 0.5rem;">${location.city}<c:if test="${not empty location.state}">, ${location.state}</c:if>, ${location.country} ${location.zip}</p>
                                            <p style="margin-bottom: 0.5rem;">📞 ${location.phone}</p>
                                            <p class="text-secondary">🕒 ${location.hours}</p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <!-- Asia Pacific -->
                    <div class="mb-6">
                        <h4 class="text-warning mb-3">🌏 Asia Pacific</h4>
                        <div class="grid grid-cols-2">
                            <c:forEach var="location" items="${locations}">
                                <c:if test="${location.country == 'China' || location.country == 'Japan' || location.country == 'Australia'}">
                                    <div class="card mb-4" style="border-left: 4px solid var(--warning-color);">
                                        <div class="card-body">
                                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                                                <h5 class="text-warning">${location.name}</h5>
                                                <span class="text-xs" style="background-color: var(--warning-color); color: white; padding: 0.25rem 0.5rem; border-radius: var(--radius-sm); text-transform: capitalize;">
                                                    ${location.type}
                                                </span>
                                            </div>
                                            <p style="margin-bottom: 0.5rem;">📍 ${location.address}</p>
                                            <p style="margin-bottom: 0.5rem;">${location.city}<c:if test="${not empty location.state}">, ${location.state}</c:if>, ${location.country} ${location.zip}</p>
                                            <p style="margin-bottom: 0.5rem;">📞 ${location.phone}</p>
                                            <p class="text-secondary">🕒 ${location.hours}</p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Contact CTA -->
            <div class="card mt-8 text-center" style="background: linear-gradient(135deg, var(--accent-color), #059669); color: white;">
                <div class="card-body">
                    <h3 style="color: white; margin-bottom: 1rem;">Need a Custom Solution?</h3>
                    <p style="color: rgba(255,255,255,0.9); margin-bottom: 2rem;">
                        Don't see a location near you? Contact us to discuss custom pickup and delivery solutions.
                    </p>
                    <a href="${contextPath}/contact" class="btn btn-secondary">Contact Our Team</a>
                </div>
            </div>
        </div>
    </main>
    
    <%@ include file="footer.jsp" %>
</body>
</html>
