package com.example.webapp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;
import org.thymeleaf.templateresolver.ITemplateResolver;

/**
 * Configuration for email templates.
 */
@Configuration
public class EmailConfig {

    /**
     * Creates a template resolver for email templates.
     */
    @Bean
    public ITemplateResolver emailTemplateResolver() {
        ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
        resolver.setPrefix("templates/emails/");
        resolver.setSuffix(".html");
        resolver.setTemplateMode(TemplateMode.HTML);
        resolver.setCharacterEncoding("UTF-8");
        resolver.setCheckExistence(true);
        resolver.setCacheable(false);
        resolver.setOrder(1);
        return resolver;
    }

    /**
     * Creates a template engine specifically for email templates
     */
    @Bean
    @Primary
    public SpringTemplateEngine emailTemplateEngine() {
        SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.addTemplateResolver(emailTemplateResolver());
        return engine;
    }
}