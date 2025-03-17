package com.example.webapp.util;

import com.example.webapp.model.Appointment;

/**
 * Utility class to handle status formatting for JSP pages
 */
public class StatusUtils {
    
    /**
     * Convert enum status to lowercase for CSS class names
     * 
     * @param status The appointment status
     * @return String representing the lowercase status for CSS usage
     */
    public static String toLowerCaseString(Appointment.Status status) {
        if (status == null) {
            return "";
        }
        return status.name().toLowerCase();
    }
    
    /**
     * Format the status for display by converting it to title case
     * and replacing underscores with spaces
     * 
     * @param status The appointment status
     * @return Formatted status string for display
     */
    public static String formatForDisplay(Appointment.Status status) {
        if (status == null) {
            return "";
        }
        String lowercase = status.name().toLowerCase();
        String withSpaces = lowercase.replace('_', ' ');
        
        // Convert to title case
        StringBuilder titleCase = new StringBuilder(withSpaces.length());
        boolean capitalizeNext = true;
        
        for (char c : withSpaces.toCharArray()) {
            if (Character.isSpaceChar(c)) {
                capitalizeNext = true;
                titleCase.append(c);
            } else if (capitalizeNext) {
                titleCase.append(Character.toUpperCase(c));
                capitalizeNext = false;
            } else {
                titleCase.append(c);
            }
        }
        
        return titleCase.toString();
    }
}