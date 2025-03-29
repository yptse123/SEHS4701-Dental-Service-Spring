package com.example.webapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "index";  // This will resolve to /WEB-INF/jsp/index.jsp
    }
    
    @GetMapping("/home")
    public String homePage() {
        return "index";
    }
    
    // Add any additional public pages here
    @GetMapping("/services")
    public String services() {
        return "services";
    }
    
    @GetMapping("/about")
    public String about() {
        return "about";
    }
    
    @GetMapping("/contact")
    public String contact() {
        return "contact";
    }
}