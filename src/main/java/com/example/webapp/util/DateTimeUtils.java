package com.example.webapp.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

public class DateTimeUtils {
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("MMM d, yyyy", Locale.ENGLISH);
    private static final DateTimeFormatter LONG_DATE_FORMATTER = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy", Locale.ENGLISH);
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);
    
    public static String formatDate(LocalDate date) {
        if (date == null) return "Not available";
        return date.format(DATE_FORMATTER);
    }
    
    public static String formatLongDate(LocalDate date) {
        if (date == null) return "Not available";
        return date.format(LONG_DATE_FORMATTER);
    }
    
    public static String formatTime(LocalTime time) {
        if (time == null) return "Not available";
        return time.format(TIME_FORMATTER);
    }
    
    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) return "Not available";
        return dateTime.format(DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a"));
    }

    public static String formatDateForHtmlInput(LocalDate date) {
        if (date == null) return "";
        return date.format(DateTimeFormatter.ISO_LOCAL_DATE); // This returns yyyy-MM-dd format
    }
}