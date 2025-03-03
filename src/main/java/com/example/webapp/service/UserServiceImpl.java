package com.example.webapp.service;

import com.example.webapp.model.User;
import com.example.webapp.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }

    @Override
    public User save(User user) {
        return userRepository.save(user);
    }

    @Override
    public void deleteById(Long id) {
        userRepository.deleteById(id);
    }
    
    @Override
    public List<User> getAllUsers() {
        return findAll();
    }
    
    @Override
    public User getUserById(Long id) {
        return findById(id).orElse(null);
    }
    
    @Override
    public User createUser(User user) {
        return save(user);
    }
    
    @Override
    public User updateUser(Long id, User user) {
        if (findById(id).isPresent()) {
            // Assuming User has a setId method
            user.setId(id);
            return save(user);
        }
        return null;
    }
    
    @Override
    public void deleteUser(Long id) {
        deleteById(id);
    }
}