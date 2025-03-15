package com.example.webapp.service;

import com.example.webapp.model.User;
import java.util.Optional;

public interface UserService {
    User registerNewUser(User user);
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    User save(User user);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
}