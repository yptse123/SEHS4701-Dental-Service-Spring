package com.example.webapp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.util.matcher.RequestMatcher;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;

import java.io.IOException;
import java.util.Collection;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

        private final UserDetailsService userDetailsService;

        public SecurityConfig(UserDetailsService userDetailsService) {
                this.userDetailsService = userDetailsService;
        }

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                // Create a custom request matcher that ignores forward dispatches
                RequestMatcher notForwarded = new RequestMatcher() {
                        @Override
                        public boolean matches(HttpServletRequest request) {
                                return request.getDispatcherType() != DispatcherType.FORWARD;
                        }
                };
                http
                                // Add this line to make Spring Security ignore forwarded requests
                                .securityMatcher(notForwarded)
                                .authorizeHttpRequests(authorize -> authorize
                                                .requestMatchers("/", "/index", "/home", "/about", "/services",
                                                                "/contact", "/register", "/login", "/contact/send")
                                                .permitAll()
                                                .requestMatchers("/images/**", "/css/**", "/js/**", "/static/**",
                                                                "/testpage", "/test", "/error/**")
                                                .permitAll())
                                .securityContext((securityContext) -> securityContext
                                                .requireExplicitSave(false))
                                .authorizeHttpRequests(authorizeRequests -> authorizeRequests
                                                .requestMatchers("/admin/**").hasAuthority("ROLE_ADMIN")
                                                .requestMatchers("/patient/**").hasAuthority("ROLE_PATIENT")
                                                .requestMatchers("/dentist/**").hasAuthority("ROLE_DENTIST")
                                                .requestMatchers("/WEB-INF/jsp/auth/**").permitAll()
                                                .anyRequest().authenticated())
                                // Add custom access denied handler
                                .exceptionHandling(exceptionHandling -> exceptionHandling
                                                .accessDeniedHandler(customAccessDeniedHandler()))
                                .formLogin(login -> login
                                                .loginPage("/login")
                                                .defaultSuccessUrl("/dashboard")
                                                .failureUrl("/login?error=true")
                                                .permitAll())
                                .logout(logout -> logout
                                                .logoutUrl("/logout")
                                                .logoutSuccessUrl("/login?logout=true")
                                                .invalidateHttpSession(true)
                                                .deleteCookies("JSESSIONID", "remember-me")
                                                .clearAuthentication(true)
                                                .permitAll())
                                .rememberMe(remember -> remember
                                                .key("uniqueAndSecretKey")
                                                .tokenValiditySeconds(86400)
                                                .userDetailsService(userDetailsService))
                                .csrf(csrf -> csrf
                                                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse()))
                                .headers(headers -> headers
                                                .httpStrictTransportSecurity().disable())
                                .requiresChannel(channel -> channel
                                                .anyRequest().requiresInsecure());

                return http.build();
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }
        
        @Bean
        public AccessDeniedHandler customAccessDeniedHandler() {
                return new CustomAccessDeniedHandler();
        }
        
        // Custom AccessDeniedHandler implementation
        public static class CustomAccessDeniedHandler implements AccessDeniedHandler {
                @Override
                public void handle(HttpServletRequest request, HttpServletResponse response, 
                                 AccessDeniedException accessDeniedException) throws IOException, ServletException {
                        
                        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
                        String targetUrl = request.getRequestURI();
                        
                        if (auth != null) {
                                Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();
                                boolean isAdmin = authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
                                boolean isDentist = authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_DENTIST"));
                                boolean isPatient = authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_PATIENT"));
                                
                                String redirectUrl;
                                if (isAdmin) {
                                        redirectUrl = "/dashboard?accessDenied=true&targetUrl=" + targetUrl;
                                } else if (isDentist) {
                                        redirectUrl = "/dashboard?accessDenied=true&targetUrl=" + targetUrl;
                                } else if (isPatient) {
                                        redirectUrl = "/dashboard?accessDenied=true&targetUrl=" + targetUrl;
                                } else {
                                        redirectUrl = "/dashboard?accessDenied=true&targetUrl=" + targetUrl;
                                }
                                
                                response.sendRedirect(request.getContextPath() + redirectUrl);
                        } else {
                                // No authentication - redirect to login
                                response.sendRedirect(request.getContextPath() + "/login?accessDenied=true&targetUrl=" + targetUrl);
                        }
                }
        }
}