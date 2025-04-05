<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - HKDC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/static/css/main.css'/>">
    <link rel="stylesheet" href="<c:url value='/static/css/public-site.css'/>">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">
        <div class="container navbarContainer">
            <h2><i class="fas fa-tooth"></i>  
                <a class="navbar-brand" href="<c:url value='/'/>">
                <!-- <img src="<c:url value='/static/image/smile dental logo.png'/>" alt="HK Dental Care Logo" height="40"> -->
                 Dental <span class="main-color" style="color: #8fd7f8;">Care</span>  
             </a>
            </h2>
           
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="<c:url value='/'/>">Home</a>
                    </li>
                   
                </ul>
            </div>
        </div>
    </nav>
    
    <div class="container">
        <h2>Patient Registration</h2>
        
        <c:if test="${param.error == 'username'}">
            <div class="error">
                Username is already taken. Please choose another.
            </div>
        </c:if>
        
        <c:if test="${param.error == 'email'}">
            <div class="error">
                Email is already registered. Please use another email.
            </div>
        </c:if>
        <c:if test="${error != null}">
            <div class="error">
                ${error}
            </div>
        </c:if>
        
        <form:form action="${pageContext.request.contextPath}/register" method="post" modelAttribute="user">
            <!-- Account Information -->
            <h5 class="mb-3 border-bottom pb-2">Account Information</h5>
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            
            <!-- Personal Information -->
            <h5 class="mb-3 mt-4 border-bottom pb-2">Personal Information</h5>
           
                <div class=" mb-3">
                    <label for="firstName" class="form-label">First Name</label>
                    <input type="text" class="form-control" id="firstName" name="firstName" required>
                </div>
                <div class="mb-3">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" class="form-control" id="lastName" name="lastName" required>
                </div>
           
            <div class="mb-3">
                <label for="phoneNumber" class="form-label">Phone Number</label>
                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" required>
            </div>
            <div class="mb-4">
                <label for="dateOfBirth" class="form-label">Date of Birth</label>
                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
            </div>
            
            <!-- CSRF token -->
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">Register</button>
            </div>
            <div>
                <p>Already have an account? <a href="<c:url value='/login'/>">Login now</a></p>
            </div>
        </form:form>
    </div>
    
    <footer>
        <p>© 2023 Hong Kong Dental Care. All rights reserved.</p>
    </footer>
</body>
</html>