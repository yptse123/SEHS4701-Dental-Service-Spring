package com.example.webapp.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.rememberme.AbstractRememberMeServices;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class LogoutController {

    // This handles GET requests to /logout-page
    @GetMapping("/logout-page")
    public String logoutPage(HttpServletRequest request, HttpServletResponse response) {
        return performLogout(request, response);
    }
    
    // This ensures POST requests to /logout are also handled here
    @PostMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        return performLogout(request, response);
    }
    
    // Common logout logic
    private String performLogout(HttpServletRequest request, HttpServletResponse response) {
        // Get current authentication
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        // If authenticated, log the user out
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        
        // Clear security context
        SecurityContextHolder.clearContext();
        
        // Invalidate session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Delete cookies
        deleteCookies(request, response);
        
        // Redirect to login page with logout parameter
        return "redirect:/login?logout=true";
    }
    
    // Helper to delete all cookies
    private void deleteCookies(HttpServletRequest request, HttpServletResponse response) {
        // Delete JSESSIONID
        Cookie cookie = new Cookie("JSESSIONID", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
        
        // Delete remember-me cookie
        cookie = new Cookie(AbstractRememberMeServices.SPRING_SECURITY_REMEMBER_ME_COOKIE_KEY, null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
        
        // Delete any other cookies you might have
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().toLowerCase().contains("token") || 
                    c.getName().toLowerCase().contains("auth") ||
                    c.getName().toLowerCase().contains("session")) {
                    
                    Cookie clearCookie = new Cookie(c.getName(), null);
                    clearCookie.setMaxAge(0);
                    clearCookie.setPath("/");
                    response.addCookie(clearCookie);
                }
            }
        }
    }
}