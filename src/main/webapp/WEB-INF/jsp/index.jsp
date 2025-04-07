<!-- filepath: /Users/yptse/Documents/poly/SEHS4701-Dental-Service-Spring/src/main/webapp/WEB-INF/jsp/index.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hong Kong Dental Clinic - Professional Dental Care</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="<c:url value='/static/css/public-site.css'/>"
    />
    <style></style>
  </head>
  <body>
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
              <a class="nav-link" href="#services">Services</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#about">About Us</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#dentists">Our Dentists</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#contact">Contact</a>
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

    <!-- Hero Section -->
    <section class="hero-section">
      <div class="hero-overlay">
        <div class="container">
          <div class="hero-container text-white">
            <h1 class="display-4 fw-bold">
              We Care About Your Brightest Smile
            </h1>
            <p class="lead mb-4">
              We're committed to providing personalized dental care that
              enhances your oral health and keeps your smile radiant for a
              lifetime
            </p>
            <a
              href="<c:url value='/patient/book'/>"
              class="btn btn-primary btn-lg"
              >Book an Appointment</a
            >
            <a href="#services" class="btn btn-outline-light btn-lg ms-3"
              >Our Services</a
            >
          </div>
        </div>
      </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="py-5">
      <div class="container">
        <div class="text-center mb-5">
          <h2 class="fw-bold">Our Dental Services</h2>
          <p class="text-muted">
            We provide comprehensive dental care for the whole family
          </p>
        </div>

        <div class="row">
          <div class="col-md-4">
            <div class="card service-card h-100 p-4 text-center">
              <div class="card-body">
                <div class="service-icon">
                  <i class="fas fa-teeth"></i>
                </div>
                <h4>General Dentistry</h4>
                <p class="text-muted">
                  Comprehensive check-ups, cleanings, fillings, and preventative
                  care for your overall oral health.
                </p>
              </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class="card service-card h-100 p-4 text-center">
              <div class="card-body">
                <div class="service-icon">
                  <i class="fas fa-tooth"></i>
                </div>
                <h4>Cosmetic Dentistry</h4>
                <p class="text-muted">
                  Enhance your smile with our whitening treatments, veneers, and
                  cosmetic bonding services.
                </p>
              </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class="card service-card h-100 p-4 text-center">
              <div class="card-body">
                <div class="service-icon">
                  <i class="fas fa-teeth-open"></i>
                </div>
                <h4>Orthodontics</h4>
                <p class="text-muted">
                  Straighten your teeth with traditional braces or clear
                  aligners for a confident smile.
                </p>
              </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class="card service-card h-100 p-4 text-center">
              <div class="card-body">
                <div class="service-icon">
                  <i class="fas fa-procedures"></i>
                </div>
                <h4>Oral Surgery</h4>
                <p class="text-muted">
                  Professional tooth extractions, wisdom teeth removal, and
                  other surgical procedures.
                </p>
              </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class="card service-card h-100 p-4 text-center">
              <div class="card-body">
                <div class="service-icon">
                  <i class="fas fa-x-ray"></i>
                </div>
                <h4>Digital X-Rays</h4>
                <p class="text-muted">
                  Advanced digital x-ray technology for accurate diagnostics
                  with minimal radiation.
                </p>
              </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class="card service-card h-100 p-4 text-center">
              <div class="card-body">
                <div class="service-icon">
                  <i class="fas fa-child"></i>
                </div>
                <h4>Pediatric Dentistry</h4>
                <p class="text-muted">
                  Child-friendly dental care to ensure your children develop
                  healthy oral habits early.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- About Section -->
    <section id="about" class="py-5 bg-light">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-lg-6 mb-4 mb-lg-0">
            <img
              src="<c:url value='/static/image/home/clinic-interior.jpg'/>"
              alt="Clinic Interior"
              class="img-fluid rounded-3 shadow"
            />
          </div>
          <div class="col-lg-6">
            <h2 class="fw-bold mb-4">About Our Clinic</h2>
            <p class="lead">
              We've been providing exceptional dental care in Hong Kong since
              2005.
            </p>
            <p>
              At Hong Kong Dental Clinic, we believe in providing
              patient-centered care in a comfortable environment. Our
              state-of-the-art facilities and experienced team ensure that you
              receive the highest quality dental services.
            </p>
            <p>
              We use the latest technology and techniques to make your dental
              visits as comfortable and effective as possible.
            </p>
            <a href="#contact" class="btn btn-primary mt-3">Contact Us</a>
          </div>
        </div>
      </div>
    </section>

    <!-- Dentists Section -->
    <section id="dentists" class="py-5">
      <div class="container">
        <div class="text-center mb-5">
          <h2 class="fw-bold">Meet Our Dentists</h2>
          <p class="text-muted">
            Our team of experienced and caring dental professionals
          </p>
        </div>

        <div class="row">
          <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
              <img
                src="<c:url value='/static/image/dentist/dentist1.jpg'/>"
                class="card-img-top"
                alt="Dr. Wei Chen"
              />
              <div class="card-body text-center">
                <h5 class="card-title">Dr. Wei Chen</h5>
                <p class="text-muted">General Dentist</p>
                <p class="card-text">
                  Dr. Chen has over 15 years of experience in general dentistry,
                  focusing on preventive care and patient education.
                </p>
              </div>
            </div>
          </div>

          <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
              <img
                src="<c:url value='/static/image/dentist/dentist2.jpg'/>"
                class="card-img-top"
                alt="Dr. Sarah Wong"
              />
              <div class="card-body text-center">
                <h5 class="card-title">Dr. Sarah Wong</h5>
                <p class="text-muted">Orthodontist</p>
                <p class="card-text">
                  Specializing in orthodontics, Dr. Wong helps patients achieve
                  beautiful, straight smiles with personalized treatment plans.
                </p>
              </div>
            </div>
          </div>

          <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
              <img
                src="<c:url value='/static/image/dentist/dentist3.jpg'/>"
                class="card-img-top"
                alt="Dr. James Lam"
              />
              <div class="card-body text-center">
                <h5 class="card-title">Dr. James Lam</h5>
                <p class="text-muted">Cosmetic Dentist</p>
                <p class="card-text">
                  Dr. Lam specializes in cosmetic procedures, helping patients
                  transform their smiles and boost their confidence.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Testimonials Section -->
    <section class="py-5 bg-light">
      <div class="container">
        <div class="text-center mb-5">
          <h2 class="fw-bold">Patient Testimonials</h2>
          <p class="text-muted">What our patients say about us</p>
        </div>

        <div class="row">
          <div class="col-md-4 mb-4">
            <div class="card testimonial-card h-100 p-4">
              <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                  <img
                    src="<c:url value='/static/image/patient/patient1.jpg'/>"
                    alt="Patient 1"
                    class="testimonial-img me-3"
                  />
                  <div>
                    <h5 class="mb-0">Michelle Tan</h5>
                    <p class="text-muted mb-0">Patient since 2019</p>
                  </div>
                </div>
                <p>
                  "I was always afraid of dental visits until I came to HK
                  Dental Clinic. Dr. Chen is so gentle and reassuring. I now
                  look forward to my check-ups!"
                </p>
                <div class="text-warning">
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                </div>
              </div>
            </div>
          </div>

          <div class="col-md-4 mb-4">
            <div class="card testimonial-card h-100 p-4">
              <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                  <img
                    src="<c:url value='/static/image/patient/patient2.jpg'/>"
                    alt="Patient 2"
                    class="testimonial-img me-3"
                  />
                  <div>
                    <h5 class="mb-0">John Lee</h5>
                    <p class="text-muted mb-0">Patient since 2020</p>
                  </div>
                </div>
                <p>
                  "My experience with Dr. Wong for my braces treatment was
                  exceptional. The staff is friendly, and the results are better
                  than I expected!"
                </p>
                <div class="text-warning">
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                </div>
              </div>
            </div>
          </div>

          <div class="col-md-4 mb-4">
            <div class="card testimonial-card h-100 p-4">
              <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                  <img
                    src="<c:url value='/static/image/patient/patient3.jpg'/>"
                    alt="Patient 3"
                    class="testimonial-img me-3"
                  />
                  <div>
                    <h5 class="mb-0">Emma Cheung</h5>
                    <p class="text-muted mb-0">Patient since 2018</p>
                  </div>
                </div>
                <p>
                  "I had my teeth whitened by Dr. Lam and couldn't be happier
                  with the results! The entire process was comfortable, and the
                  staff was attentive."
                </p>
                <div class="text-warning">
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star"></i>
                  <i class="fas fa-star-half-alt"></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section text-center">
      <div class="container">
        <h2 class="fw-bold mb-4">Ready to Schedule Your Visit?</h2>
        <p class="lead mb-4">Book an appointment online or call us today!</p>
        <div class="d-flex justify-content-center flex-wrap">
          <a
            href="<c:url value='/patient/book'/>"
            class="btn btn-primary btn-lg me-3 s-me-3 mb-2"
            >Book Online</a
          >
          <a href="tel:+85212345678" class="btn btn-outline-primary btn-lg mb-2"
            >Call: +852 1234 5678</a
          >
        </div>
      </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="py-5">
      <div class="container">
        <div class="text-center mb-5">
          <h2 class="fw-bold">Contact Us</h2>
          <p class="text-muted">We're here to answer your questions</p>
        </div>

        <div class="row">
          <div class="col-lg-6 mb-4 mb-lg-0">
            <div class="card border-0 shadow-sm h-100">
              <div class="card-body p-4">
                <h4 class="mb-4">Send Us a Message</h4>

                <c:if test="${param.success eq 'true'}">
                    <div class="alert alert-success alert-dismissible fade show mb-4">
                        <i class="fas fa-check-circle me-2"></i> Thank you for your message! We will get back to you shortly.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${param.error eq 'true'}">
                    <div class="alert alert-danger alert-dismissible fade show mb-4">
                        <i class="fas fa-exclamation-circle me-2"></i> Sorry, there was a problem sending your message. Please try again.
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="<c:url value='/contact/send'/>" method="post">
                    <div class="mb-3">
                        <label for="name" class="form-label">Your Name</label>
                        <input type="text" class="form-control" id="name" name="name" required />
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" required />
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="tel" class="form-control" id="phone" name="phone" />
                    </div>
                    <div class="mb-3">
                        <label for="message" class="form-label">Message</label>
                        <textarea class="form-control" id="message" name="message" rows="4" required></textarea>
                    </div>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane me-2"></i> Send Message
                    </button>
                </form>
              </div>
            </div>
          </div>

          <div class="col-lg-6">
            <div class="card border-0 shadow-sm h-100">
              <div class="card-body p-4">
                <h4 class="mb-4">Clinic Information</h4>

                <div class="d-flex mb-4">
                  <div class="flex-shrink-0 text-primary me-3">
                    <i class="fas fa-map-marker-alt fa-2x"></i>
                  </div>
                  <div>
                    <h5>Address</h5>
                    <p class="mb-0">123 Dental Street, Central, Hong Kong</p>
                  </div>
                </div>

                <div class="d-flex mb-4">
                  <div class="flex-shrink-0 text-primary me-3">
                    <i class="fas fa-phone-alt fa-2x"></i>
                  </div>
                  <div>
                    <h5>Phone</h5>
                    <p class="mb-0">+852 1234 5678</p>
                  </div>
                </div>

                <div class="d-flex mb-4">
                  <div class="flex-shrink-0 text-primary me-3">
                    <i class="fas fa-envelope fa-2x"></i>
                  </div>
                  <div>
                    <h5>Email</h5>
                    <p class="mb-0">info@hkdental.me</p>
                  </div>
                </div>

                <div class="d-flex">
                  <div class="flex-shrink-0 text-primary me-3">
                    <i class="fas fa-clock fa-2x"></i>
                  </div>
                  <div>
                    <h5>Office Hours</h5>
                    <p class="mb-1">Monday - Friday: 9:00 AM - 6:00 PM</p>
                    <p class="mb-0">Saturday: 9:00 AM - 1:00 PM</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Map Section -->
    <div class="container-fluid p-0">
        <div class="map-container">
            <div id="clinicMap" style="width:100%; height:400px;"></div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
      <div class="container">
        <div class="row">
          <div class="col-lg-4 mb-4 mb-lg-0">
            <h5 class="footer-heading">About HK Dental Clinic</h5>
            <p>
              Providing quality dental care in Hong Kong since 2005. Our mission
              is to help you achieve optimal oral health in a comfortable and
              friendly environment.
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
              <li class="mb-2"><a href="#" class="footer-link">Home</a></li>
              <li class="mb-2">
                <a href="#services" class="footer-link">Services</a>
              </li>
              <li class="mb-2">
                <a href="#about" class="footer-link">About Us</a>
              </li>
              <li class="mb-2">
                <a href="#dentists" class="footer-link">Dentists</a>
              </li>
              <li class="mb-2">
                <a href="#contact" class="footer-link">Contact</a>
              </li>
            </ul>
          </div>

          <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
            <h5 class="footer-heading">Services</h5>
            <ul class="list-unstyled">
              <li class="mb-2">
                <a href="#services" class="footer-link">General Dentistry</a>
              </li>
              <li class="mb-2">
                <a href="#services" class="footer-link">Cosmetic Dentistry</a>
              </li>
              <li class="mb-2">
                <a href="#services" class="footer-link">Orthodontics</a>
              </li>
              <li class="mb-2">
                <a href="#services" class="footer-link">Oral Surgery</a>
              </li>
              <li class="mb-2">
                <a href="#services" class="footer-link">Pediatric Dentistry</a>
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

      document.addEventListener('DOMContentLoaded', function() {
          // Check for contact form submission feedback
          const urlParams = new URLSearchParams(window.location.search);
          if (urlParams.has('success') || urlParams.has('error')) {
              // Scroll to contact section smoothly
              setTimeout(function() {
                  document.getElementById('contact').scrollIntoView({
                      behavior: 'smooth'
                  });
              }, 300);
          }
          
          // Auto-hide alerts after 5 seconds
          setTimeout(function() {
              const alerts = document.querySelectorAll('.alert');
              alerts.forEach(alert => {
                  const bsAlert = new bootstrap.Alert(alert);
                  bsAlert.close();
              });
          }, 5000);
      });

      // Initialize the map
      function initMap() {
        // Center on Hong Kong
        const hongKong = { lat: 22.3193, lng: 114.1694 };
        
        // Create the map
        const map = new google.maps.Map(document.getElementById("clinicMap"), {
            zoom: 12,
            center: hongKong,
            mapTypeControl: true,
            streetViewControl: true,
            fullscreenControl: true
        });
        
        // Define clinic locations
        const clinics = [
            {
                name: "Central Dental Clinic",
                position: { lat: 22.2828, lng: 114.1548 },
                address: "123 Dental Street, Central, Hong Kong",
                phone: "+852 1234 5678"
            },
            {
                name: "Tsim Sha Tsui Clinic",
                position: { lat: 22.2988, lng: 114.1722 },
                address: "45 Nathan Road, Tsim Sha Tsui, Kowloon",
                phone: "+852 2345 6789"
            },
            {
                name: "Causeway Bay Clinic",
                position: { lat: 22.2808, lng: 114.1837 },
                address: "67 Yee Wo Street, Causeway Bay, Hong Kong",
                phone: "+852 3456 7890"
            },
            {
                name: "Mong Kok Clinic",
                position: { lat: 22.3203, lng: 114.1694 },
                address: "88 Argyle Street, Mong Kok, Kowloon",
                phone: "+852 4567 8901"
            },
            {
                name: "Sha Tin Clinic",
                position: { lat: 22.3833, lng: 114.1890 },
                address: "123 Sha Tin Centre, New Territories",
                phone: "+852 5678 9012"
            }
        ];
        
        // Create an info window to share between markers
        const infoWindow = new google.maps.InfoWindow();
        
        // Create the markers
        clinics.forEach((clinic) => {
            const marker = new google.maps.Marker({
                position: clinic.position,
                map: map,
                title: clinic.name,
                animation: google.maps.Animation.DROP
            });
            
            // Create info window content - using concatenation instead of template literals
            const content = 
                '<div class="clinic-info" style="padding: 10px; max-width: 300px;">' +
                    '<h5 style="margin-top: 0; margin-bottom: 10px; color: #0d6efd;">' + clinic.name + '</h5>' +
                    '<p style="margin-bottom: 5px;"><i class="fas fa-map-marker-alt" style="color: #dc3545;"></i> ' + 
                        clinic.address + '</p>' +
                    '<p style="margin-bottom: 10px;"><i class="fas fa-phone" style="color: #0d6efd;"></i> ' + 
                        clinic.phone + '</p>' +
                    '<a href="/patient/book" class="btn btn-sm btn-primary" style="background-color: #0d6efd; ' +
                        'color: white; text-decoration: none; padding: 5px 10px; border-radius: 4px;">Book Appointment</a>' +
                '</div>';
            
            // Add click event to show info window
            marker.addListener("click", () => {
                // Close any open info window first
                infoWindow.close();
                // Set content and open
                infoWindow.setContent(content);
                infoWindow.open({
                    anchor: marker,
                    map,
                    shouldFocus: false,
                });
                
                // Bounce the marker
                if (marker.getAnimation() !== null) {
                    marker.setAnimation(null);
                } else {
                    marker.setAnimation(google.maps.Animation.BOUNCE);
                    setTimeout(() => {
                        marker.setAnimation(null);
                    }, 750);
                }
            });
            
            // Also open first clinic's info window by default
            if (clinic === clinics[0]) {
                google.maps.event.addListenerOnce(map, 'idle', function() {
                    infoWindow.setContent(content);
                    infoWindow.open(map, marker);
                });
            }
        });
        
        // Add some additional styling
        const styles = `
            .clinic-info h5 {
                font-weight: bold;
                color: #0d6efd;
            }
            .clinic-info p {
                margin-bottom: 8px;
            }
            .clinic-info .btn {
                display: inline-block;
                font-weight: 500;
                text-align: center;
            }
        `;
        
        const styleSheet = document.createElement("style");
        styleSheet.type = "text/css";
        styleSheet.innerText = styles;
        document.head.appendChild(styleSheet);
    }
    </script>
    <!-- Load Google Maps JavaScript API with your API key -->
    <script async defer
      src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDewRVkvQ9vrv1Ky80wl5N1IAmH0xUZ_7U&callback=initMap">
    </script>
  </body>
</html>
