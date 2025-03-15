<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - HKDC</title>
    <link rel="stylesheet" href="<c:url value='/static/css/main.css'/>">
</head>
<body>
    <header>
        <h1>Hong Kong Dental Care</h1>
    </header>
    
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
        
        <form:form action="/register" method="post" modelAttribute="user">
            <div>
                <label for="username">Username:</label>
                <form:input path="username" id="username" required="true" />
            </div>
            <div>
                <label for="email">Email:</label>
                <form:input path="email" id="email" type="email" required="true" />
            </div>
            <div>
                <label for="password">Password:</label>
                <form:password path="password" id="password" required="true" />
            </div>
            
            <div>
                <button type="submit">Register</button>
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