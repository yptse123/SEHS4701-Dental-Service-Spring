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
    <link rel="stylesheet" href="<c:url value='/static/css/main.css'/>">
</head>
<body>
    <header>
        <h1>Hong Kong Dental Care</h1>
    </header>
    
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