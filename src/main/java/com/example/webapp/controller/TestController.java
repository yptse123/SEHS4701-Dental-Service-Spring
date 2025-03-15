package com.example.webapp.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TestController {

    @GetMapping("/test")
    @ResponseBody
    public String test() {
        return "Application is running correctly";
    }
    
    @GetMapping("/testpage")
    public String testPage() {
        return "test";  // Should render a simple test.jsp page
    }
}