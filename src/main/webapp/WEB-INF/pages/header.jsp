<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%@ page import="jakarta.servlet.http.HttpServletRequest"%>

<%
// Initialize necessary objects and variables
HttpSession userSession = request.getSession(false);
String currentUser = (String) (userSession != null ? userSession.getAttribute("username") : null);
String userRole = null;
if (userSession != null) {
    userRole = (String) userSession.getAttribute("role");
}
// Get current page URL for navigation highlighting
String currentPath = request.getRequestURI();
String contextPath = request.getContextPath();
if (currentPath.startsWith(contextPath)) {
    currentPath = currentPath.substring(contextPath.length());
}

// need to add data in attribute to select it in JSP code using JSTL core tag
pageContext.setAttribute("currentUser", currentUser);
pageContext.setAttribute("userRole", userRole);
pageContext.setAttribute("currentPath", currentPath);
%>

<!-- Set contextPath variable -->
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<header class="header">
    <div class="container">
        <div class="header-content">
            <a href="${contextPath}/home" class="logo">
                CargoFlow
            </a>
            
            <nav>
                <ul class="main-nav">
                    <li class="nav-item">
                        <a href="${contextPath}/home" class="nav-link ${currentPath == '/home' || currentPath == '/' ? 'active' : ''}">Home</a>
                    </li>
                    <li class="nav-item">
                        <a href="${contextPath}/about" class="nav-link ${currentPath == '/about' ? 'active' : ''}">About</a>
                    </li>
                    <li class="nav-item">
                        <a href="${contextPath}/portfolio" class="nav-link ${currentPath == '/portfolio' ? 'active' : ''}">Services</a>
                    </li>
                    <li class="nav-item">
                        <a href="${contextPath}/track" class="nav-link ${currentPath == '/track' ? 'active' : ''}">Track Cargo</a>
                    </li>
                    <li class="nav-item">
                        <a href="${contextPath}/contact" class="nav-link ${currentPath == '/contact' ? 'active' : ''}">Contact</a>
                    </li>
                    
                    <c:choose>
                        <c:when test="${not empty currentUser}">
                            <!-- User Dashboard Link -->
                    <c:choose>
                        <c:when test="${userRole eq 'admin' or userRole eq 'employee'}">
                            <li class="nav-item">
                                <a href="${contextPath}/dashboard" class="nav-link ${currentPath == '/dashboard' ? 'active' : ''}">Admin Dashboard</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item dropdown">
                                <a href="#" class="nav-link dropdown-toggle ${currentPath == '/userDashboard' || currentPath == '/user-profile' || currentPath == '/shipping-history' || currentPath == '/registerCargo' ? 'active' : ''}">My Account ▼</a>
                                <ul class="dropdown-menu">
                                    <li><a href="${contextPath}/userDashboard" class="dropdown-link ${currentPath == '/userDashboard' ? 'active' : ''}">Dashboard</a></li>
                                    <li><a href="${contextPath}/track" class="dropdown-link ${currentPath == '/track' ? 'active' : ''}">Track Cargo</a></li>
                                    <li><a href="${contextPath}/contact" class="dropdown-link ${currentPath == '/contact' ? 'active' : ''}">Support</a></li>
                                </ul>
                            </li>
                        </c:otherwise>
                    </c:choose>                            <!-- User Info & Logout -->
                            <li class="nav-item">
                                <span class="nav-link" style="color: var(--primary-color); font-weight: 600;">
                                    Welcome, ${currentUser}
                                </span>
                            </li>
                            <li class="nav-item">
                                <form action="${contextPath}/logout" method="post" style="display: inline;">
                                    <button type="submit" class="btn btn-outline">Logout</button>
                                </form>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <!-- Guest User -->
                            <li class="nav-item">
                                <a href="${contextPath}/register" class="btn btn-outline">Register</a>
                            </li>
                            <li class="nav-item">
                                <a href="${contextPath}/login" class="btn btn-primary">Login</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </nav>
        </div>
    </div>
</header>
