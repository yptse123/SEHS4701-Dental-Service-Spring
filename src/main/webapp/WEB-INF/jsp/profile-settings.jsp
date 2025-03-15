<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Account Settings - HKDC</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/dashboard.css'/>">
    <link rel="stylesheet" href="<c:url value='/css/profile-settings.css'/>">
</head>
<body>
    <div class="dashboard-container">
        <!-- Include sidebar partial -->
        <jsp:include page="partials/sidebar.jsp" />
        
        <!-- Main Content -->
        <main class="main-content">
            <!-- Include header partial -->
            <jsp:include page="partials/header.jsp" />
            
            <div class="content-wrapper">
                <div class="page-header">
                    <h1>Account Settings</h1>
                    <p>Manage your account information and security settings</p>
                </div>
                
                <div class="settings-container">
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">
                            ${successMessage}
                        </div>
                    </c:if>
                    
                    <!-- Update Email Card -->
                    <div class="settings-card">
                        <!-- Email settings content -->
                        <!-- ... as in previous example ... -->
                    </div>
                    
                    <!-- Update Password Card -->
                    <div class="settings-card">
                        <!-- Password settings content -->
                        <!-- ... as in previous example ... -->
                    </div>
                </div>
            </div>
        </main>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize dropdown and sidebar functionality
            // ... as in previous example ...
        });
    </script>
</body>
</html>