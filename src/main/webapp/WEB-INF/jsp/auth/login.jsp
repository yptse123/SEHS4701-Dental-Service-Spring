<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <title>Login - HKDC</title>
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
        <h2>Login</h2>
        
        <c:if test="${param.error != null}">
            <div class="error">
                Invalid username or password.
            </div>
        </c:if>
        
        <c:if test="${param.logout != null}">
            <div class="success">
                You have been logged out.
            </div>
        </c:if>
        
        <c:if test="${param.registered != null}">
            <div class="success">
                Registration successful! Please login.
            </div>
        </c:if>
        
        <form action="<c:url value='/login'/>" method="post">
            <div>
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            
            <div class="remember-me">
                <input type="checkbox" id="remember-me" name="remember-me">
                <label for="remember-me">Remember me</label>
            </div>
            
            <div>
                <button type="submit">Login</button>
            </div>
            
            <div class="register-link">
                <p>Don't have an account? <a href="<c:url value='/register'/>">Register now</a></p>
            </div>
        </form>
    </div>
    
    <footer>
        <p>© 2023 Hong Kong Dental Care. All rights reserved.</p>
    </footer>
</body>
</html>