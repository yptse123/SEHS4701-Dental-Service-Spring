<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hong Kong Dental Care</title>
    <link rel="stylesheet" href="<c:url value='/static/css/main.css'/>">
    <style>
        .hero {
            background-color: #1976d2;
            color: white;
            padding: 4rem 2rem;
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .hero h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: white;
        }
        
        .hero p {
            font-size: 1.2rem;
            max-width: 700px;
            margin: 0 auto 2rem;
        }
        
        .btn {
            display: inline-block;
            background-color: white;
            color: #1976d2;
            padding: 0.8rem 2rem;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 500;
            margin: 0 0.5rem;
        }
        
        .btn:hover {
            background-color: #f0f0f0;
        }
        
        .features {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 2rem;
            padding: 2rem;
        }
        
        .feature {
            flex: 1;
            min-width: 280px;
            max-width: 400px;
            padding: 1.5rem;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .feature h3 {
            color: #1976d2;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <header>
        <h1>Hong Kong Dental Care</h1>
    </header>
    
    <div class="hero">
        <h2>Your Smile Is Our Priority</h2>
        <p>Hong Kong's premier dental care service with 10 experienced dentists across 5 clinic locations.</p>
        <div>
            <a href="<c:url value='/login'/>" class="btn">Login</a>
            <a href="<c:url value='/register'/>" class="btn">Register</a>
        </div>
    </div>
    
    <div class="features">
        <div class="feature">
            <h3>Easy Online Booking</h3>
            <p>Book your dental appointment online 24/7 with our convenient booking system. Choose your preferred dentist, location, and time.</p>
        </div>
        <div class="feature">
            <h3>Professional Dentists</h3>
            <p>Our team consists of 10 highly qualified dentists with specializations in various fields of dentistry.</p>
        </div>
        <div class="feature">
            <h3>Multiple Locations</h3>
            <p>Visit us at any of our 5 clinics conveniently located across Hong Kong, including TST, Kwai Chung, Central, Causeway Bay, and Mong Kok.</p>
        </div>
    </div>
    
    <footer>
        <p>© 2023 Hong Kong Dental Care. All rights reserved.</p>
    </footer>
</body>
</html>