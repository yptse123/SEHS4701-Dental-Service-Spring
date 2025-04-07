<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register - HKDC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- <link rel="stylesheet" href="<c:url value='/static/css/main.css'/>"> -->
    <link rel="stylesheet" href="<c:url value='/static/css/public-site.css'/>">
    <link rel="stylesheet" href="<c:url value='/static/css/register.css'/>">
</head>
<body>
    <%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
    <sec:authorize access="isAuthenticated()">
      <% response.sendRedirect(request.getContextPath() + "/dashboard"); %>
    </sec:authorize>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">
      <div class="container">
        <h2>
          <i class="fas fa-tooth"></i>
          <a class="navbar-brand" href="<c:url value='/'/>">
            <!-- <img src="<c:url value='/static/image/smile dental logo.png'/>" alt="HK Dental Care Logo" height="40"> -->
            Dental <span class="main-color" style="color: #8fd7f8">Care</span>
          </a>
        </h2>

        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navbarNav"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav ms-auto">
            <li class="nav-item">
              <a class="nav-link active" href="<c:url value='/'/>">Home</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/#services">Services</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/#about">About Us</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/#dentists">Our Dentists</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/#contact">Contact</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="<c:url value='/login'/>">Login</a>
            </li>
            <li class="nav-item d-block d-lg-none bg-light">
              <a
                class="nav-link text-black fw-bold text-center"
                href="<c:url value='/register'/>"
                >Register</a
              >
            </li>
            <li class="nav-item d-none d-lg-block">
              <a class="btn btn-light ms-2" href="<c:url value='/register'/>"
                >Register</a
              >
            </li>
          </ul>
        </div>
      </div>
    </nav>
    
    <div class="container py-2">
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
    
    <!-- Footer -->
    <footer>
      <div class="container">
        <div class="row">
          <div class="col-lg-4 mb-4 mb-lg-0">
            <h5 class="footer-heading">About HK Dental Clinic</h5>
            <p>
              Providing quality dental care in Hong Kong since 2005. Our
              mission is to help you achieve optimal oral health in a
              comfortable and friendly environment.
            </p>
            <div class="social-icons mt-3">
              <a href="#"><i class="fab fa-facebook-f"></i></a>
              <a href="#"><i class="fab fa-twitter"></i></a>
              <a href="#"><i class="fab fa-instagram"></i></a>
              <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
          </div>

          <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
            <h5 class="footer-heading">Quick Links</h5>
            <ul class="list-unstyled">
              <li class="mb-2"><a href="/" class="footer-link">Home</a></li>
              <li class="mb-2">
                <a href="/#services" class="footer-link">Services</a>
              </li>
              <li class="mb-2">
                <a href="/#about" class="footer-link">About Us</a>
              </li>
              <li class="mb-2">
                <a href="/#dentists" class="footer-link">Dentists</a>
              </li>
              <li class="mb-2">
                <a href="/#contact" class="footer-link">Contact</a>
              </li>
            </ul>
          </div>

          <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
            <h5 class="footer-heading">Services</h5>
            <ul class="list-unstyled">
              <li class="mb-2">
                <a href="/#services" class="footer-link">General Dentistry</a>
              </li>
              <li class="mb-2">
                <a href="/#services" class="footer-link"
                  >Cosmetic Dentistry</a
                >
              </li>
              <li class="mb-2">
                <a href="/#services" class="footer-link">Orthodontics</a>
              </li>
              <li class="mb-2">
                <a href="/#services" class="footer-link">Oral Surgery</a>
              </li>
              <li class="mb-2">
                <a href="/#services" class="footer-link"
                  >Pediatric Dentistry</a
                >
              </li>
            </ul>
          </div>

          <div class="col-lg-3 col-md-6">
            <h5 class="footer-heading">Contact Us</h5>
            <ul class="list-unstyled">
              <li class="mb-2">
                <i class="fas fa-map-marker-alt me-2"></i> 123 Dental Street,
                Central, Hong Kong
              </li>
              <li class="mb-2">
                <i class="fas fa-phone-alt me-2"></i> +852 1234 5678
              </li>
              <li class="mb-2">
                <i class="fas fa-envelope me-2"></i> info@hkdental.me
              </li>
              <li>
                <i class="fas fa-clock me-2"></i> Mon-Fri: 9:00-18:00, Sat:
                9:00-13:00
              </li>
            </ul>
          </div>
        </div>

        <hr class="mt-4 mb-3" style="background-color: #495057" />

        <div class="row">
          <div class="col-md-6 text-center text-md-start">
            <p class="mb-2 mb-md-0">
              © 2025 HK Dental Clinic. All rights reserved.
            </p>
          </div>
          <div class="col-md-6 text-center text-md-end">
            <a href="#" class="footer-link me-3">Privacy Policy</a>
            <a href="#" class="footer-link">Terms of Service</a>
          </div>
        </div>
      </div>
    </footer>

      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
      <script>
        // Add scroll behavior for navigation links
        document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
          anchor.addEventListener("click", function (e) {
            e.preventDefault();
            document.querySelector(this.getAttribute("href")).scrollIntoView({
              behavior: "smooth",
            });
          });
        });
      </script>
</body>
</html>