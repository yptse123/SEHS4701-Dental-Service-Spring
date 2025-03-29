<!-- filepath: /Users/yptse/Documents/poly/SEHS4701-Dental-Service-Spring/src/main/webapp/WEB-INF/jsp/index.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hong Kong Dental Clinic - Professional Dental Care</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/css/public-site.css'/>">
    <style>
        /* Hero section */
        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('<c:url value="/images/dental-hero.jpg"/>') no-repeat center;
            background-size: cover;
            color: white;
            padding: 120px 0;
            margin-bottom: 2rem;
        }
        
        /* Service cards */
        .service-card {
            border: none;
            border-radius: 8px;
            transition: transform 0.3s, box-shadow 0.3s;
            margin-bottom: 1.5rem;
        }
        
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .service-icon {
            font-size: 2.5rem;
            color: #0d6efd;
            margin-bottom: 1rem;
        }
        
        /* Testimonials */
        .testimonial-card {
            border-radius: 15px;
            margin: 20px 10px;
        }
        
        .testimonial-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        /* Call to action */
        .cta-section {
            background-color: #f8f9fa;
            padding: 80px 0;
        }
        
        /* Footer */
        footer {
            background-color: #212529;
            color: white;
            padding: 60px 0 20px;
        }
        
        .footer-heading {
            font-size: 1.2rem;
            margin-bottom: 20px;
            color: #fff;
        }
        
        .footer-link {
            color: #adb5bd;
            text-decoration: none;
            transition: color 0.3s;
        }
        
        .footer-link:hover {
            color: white;
        }
        
        .social-icons a {
            display: inline-block;
            margin-right: 15px;
            color: #adb5bd;
            font-size: 1.2rem;
            transition: color 0.3s;
        }
        
        .social-icons a:hover {
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">
        <div class="container">
            <a class="navbar-brand" href="<c:url value='/'/>">
                <img src="<c:url value='/images/logo.png'/>" alt="HK Dental Logo" height="40">
                HK Dental Clinic
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
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
                    <li class="nav-item">
                        <a class="btn btn-light ms-2" href="<c:url value='/register'/>">Register</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-4 fw-bold">Professional Dental Care in Hong Kong</h1>
            <p class="lead mb-4">Quality dental services with modern facilities and experienced professionals</p>
            <a href="<c:url value='/patient/book'/>" class="btn btn-primary btn-lg">Book an Appointment</a>
            <a href="#services" class="btn btn-outline-light btn-lg ms-3">Our Services</a>
        </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold">Our Dental Services</h2>
                <p class="text-muted">We provide comprehensive dental care for the whole family</p>
            </div>
            
            <div class="row">
                <div class="col-md-4">
                    <div class="card service-card h-100 p-4 text-center">
                        <div class="card-body">
                            <div class="service-icon">
                                <i class="fas fa-teeth"></i>
                            </div>
                            <h4>General Dentistry</h4>
                            <p class="text-muted">Comprehensive check-ups, cleanings, fillings, and preventative care for your overall oral health.</p>
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
                            <p class="text-muted">Enhance your smile with our whitening treatments, veneers, and cosmetic bonding services.</p>
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
                            <p class="text-muted">Straighten your teeth with traditional braces or clear aligners for a confident smile.</p>
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
                            <p class="text-muted">Professional tooth extractions, wisdom teeth removal, and other surgical procedures.</p>
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
                            <p class="text-muted">Advanced digital x-ray technology for accurate diagnostics with minimal radiation.</p>
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
                            <p class="text-muted">Child-friendly dental care to ensure your children develop healthy oral habits early.</p>
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
                    <img src="<c:url value='/images/clinic-interior.jpg'/>" alt="Clinic Interior" class="img-fluid rounded-3 shadow">
                </div>
                <div class="col-lg-6">
                    <h2 class="fw-bold mb-4">About Our Clinic</h2>
                    <p class="lead">We've been providing exceptional dental care in Hong Kong since 2005.</p>
                    <p>At Hong Kong Dental Clinic, we believe in providing patient-centered care in a comfortable environment. Our state-of-the-art facilities and experienced team ensure that you receive the highest quality dental services.</p>
                    <p>We use the latest technology and techniques to make your dental visits as comfortable and effective as possible.</p>
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
                <p class="text-muted">Our team of experienced and caring dental professionals</p>
            </div>
            
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="<c:url value='/images/dentist1.jpg'/>" class="card-img-top" alt="Dr. Wei Chen">
                        <div class="card-body text-center">
                            <h5 class="card-title">Dr. Wei Chen</h5>
                            <p class="text-muted">General Dentist</p>
                            <p class="card-text">Dr. Chen has over 15 years of experience in general dentistry, focusing on preventive care and patient education.</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="<c:url value='/images/dentist2.jpg'/>" class="card-img-top" alt="Dr. Sarah Wong">
                        <div class="card-body text-center">
                            <h5 class="card-title">Dr. Sarah Wong</h5>
                            <p class="text-muted">Orthodontist</p>
                            <p class="card-text">Specializing in orthodontics, Dr. Wong helps patients achieve beautiful, straight smiles with personalized treatment plans.</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="<c:url value='/images/dentist3.jpg'/>" class="card-img-top" alt="Dr. James Lam">
                        <div class="card-body text-center">
                            <h5 class="card-title">Dr. James Lam</h5>
                            <p class="text-muted">Cosmetic Dentist</p>
                            <p class="card-text">Dr. Lam specializes in cosmetic procedures, helping patients transform their smiles and boost their confidence.</p>
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
                                <img src="<c:url value='/images/patient1.jpg'/>" alt="Patient 1" class="testimonial-img me-3">
                                <div>
                                    <h5 class="mb-0">Michelle Tan</h5>
                                    <p class="text-muted mb-0">Patient since 2019</p>
                                </div>
                            </div>
                            <p>"I was always afraid of dental visits until I came to HK Dental Clinic. Dr. Chen is so gentle and reassuring. I now look forward to my check-ups!"</p>
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
                                <img src="<c:url value='/images/patient2.jpg'/>" alt="Patient 2" class="testimonial-img me-3">
                                <div>
                                    <h5 class="mb-0">John Lee</h5>
                                    <p class="text-muted mb-0">Patient since 2020</p>
                                </div>
                            </div>
                            <p>"My experience with Dr. Wong for my braces treatment was exceptional. The staff is friendly, and the results are better than I expected!"</p>
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
                                <img src="<c:url value='/images/patient3.jpg'/>" alt="Patient 3" class="testimonial-img me-3">
                                <div>
                                    <h5 class="mb-0">Emma Cheung</h5>
                                    <p class="text-muted mb-0">Patient since 2018</p>
                                </div>
                            </div>
                            <p>"I had my teeth whitened by Dr. Lam and couldn't be happier with the results! The entire process was comfortable, and the staff was attentive."</p>
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
                <a href="<c:url value='/patient/book'/>" class="btn btn-primary btn-lg me-3 mb-2">Book Online</a>
                <a href="tel:+85212345678" class="btn btn-outline-primary btn-lg mb-2">Call: +852 1234 5678</a>
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
                            <form>
                                <div class="mb-3">
                                    <label for="name" class="form-label">Your Name</label>
                                    <input type="text" class="form-control" id="name" required>
                                </div>
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" required>
                                </div>
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phone">
                                </div>
                                <div class="mb-3">
                                    <label for="message" class="form-label">Message</label>
                                    <textarea class="form-control" id="message" rows="4" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">Send Message</button>
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
                                    <p class="mb-0">info@hkdentalclinic.com</p>
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
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d59073.44023932723!2d114.14986544863281!3d22.28496!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3403e2eda332980f%3A0xf08ab3badbeac97c!2sHong%20Kong!5e0!3m2!1sen!2s!4v1648279915217!5m2!1sen!2s" 
                    width="100%" 
                    height="400" 
                    style="border:0;" 
                    allowfullscreen="" 
                    loading="lazy"></iframe>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-4 mb-4 mb-lg-0">
                    <h5 class="footer-heading">About HK Dental Clinic</h5>
                    <p>Providing quality dental care in Hong Kong since 2005. Our mission is to help you achieve optimal oral health in a comfortable and friendly environment.</p>
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
                        <li class="mb-2"><a href="#services" class="footer-link">Services</a></li>
                        <li class="mb-2"><a href="#about" class="footer-link">About Us</a></li>
                        <li class="mb-2"><a href="#dentists" class="footer-link">Dentists</a></li>
                        <li class="mb-2"><a href="#contact" class="footer-link">Contact</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-4 mb-md-0">
                    <h5 class="footer-heading">Services</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#" class="footer-link">General Dentistry</a></li>
                        <li class="mb-2"><a href="#" class="footer-link">Cosmetic Dentistry</a></li>
                        <li class="mb-2"><a href="#" class="footer-link">Orthodontics</a></li>
                        <li class="mb-2"><a href="#" class="footer-link">Oral Surgery</a></li>
                        <li class="mb-2"><a href="#" class="footer-link">Pediatric Dentistry</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-3 col-md-6">
                    <h5 class="footer-heading">Contact Us</h5>
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="fas fa-map-marker-alt me-2"></i> 123 Dental Street, Central, Hong Kong
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-phone-alt me-2"></i> +852 1234 5678
                        </li>
                        <li class="mb-2">
                            <i class="fas fa-envelope me-2"></i> info@hkdentalclinic.com
                        </li>
                        <li>
                            <i class="fas fa-clock me-2"></i> Mon-Fri: 9:00-18:00, Sat: 9:00-13:00
                        </li>
                    </ul>
                </div>
            </div>
            
            <hr class="mt-4 mb-3" style="background-color: #495057;">
            
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <p class="mb-2 mb-md-0">© 2025 HK Dental Clinic. All rights reserved.</p>
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
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>