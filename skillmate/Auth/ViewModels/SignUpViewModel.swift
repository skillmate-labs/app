//
//  SignUpViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 15/11/25.
//

import Foundation
import Observation

enum SignUpField {
    case fullName
    case email
    case password
    case confirmPassword
}

@Observable
class SignUpViewModel {
    // Inputs
    var fullName: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    // UI state
    var isLoading: Bool = false
    var isPasswordVisible: Bool = false
    var isConfirmPasswordVisible: Bool = false
    
    // Errors
    var errorFullName: String? = nil
    var errorEmail: String? = nil
    var errorPassword: String? = nil
    var errorConfirmPassword: String? = nil
    var authError: String? = nil
    
    var isFormValid: Bool {
        AuthValidation.validateFullName(fullName) == nil &&
        AuthValidation.validateEmail(email) == nil &&
        AuthValidation.validatePassword(password) == nil &&
        AuthValidation.validateConfirmPassword(password, confirmPassword) == nil
    }
    
    // MARK: - Input handlers
    
    func onFullNameChange(_ newValue: String) {
        fullName = newValue
        errorFullName = nil
        authError = nil
    }
    
    func onEmailChange(_ newValue: String) {
        email = newValue
        errorEmail = nil
        authError = nil
    }
    
    func onPasswordChange(_ newValue: String) {
        password = newValue
        errorPassword = nil
        authError = nil
        
        if !confirmPassword.isEmpty {
            errorConfirmPassword = nil
        }
    }
    
    func onConfirmPasswordChange(_ newValue: String) {
        confirmPassword = newValue
        errorConfirmPassword = nil
        authError = nil
    }
    
    // MARK: - Actions
    
    func signUp(
        authService: AuthService,
        onFieldError: (SignUpField) -> Void
    ) {
        authError = nil
        
        let trimmedEmail = email.trimmed
        
        // Full name
        errorFullName = AuthValidation.validateFullName(fullName)
        if errorFullName != nil {
            onFieldError(.fullName)
            return
        }
        
        // Email
        if let emailError = AuthValidation.validateEmail(trimmedEmail) {
            errorEmail = emailError
            onFieldError(.email)
            return
        }
        
        // Password
        if let passwordError = AuthValidation.validatePassword(password) {
            errorPassword = passwordError
            onFieldError(.password)
            return
        }
        
        // Confirm password
        if let confirmError = AuthValidation.validateConfirmPassword(password, confirmPassword) {
            errorConfirmPassword = confirmError
            onFieldError(.confirmPassword)
            return
        }
        
        isLoading = true
        
        authService.signUp(fullName: fullName, email: trimmedEmail, password: password) { [weak self] error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                
                if let error {
                    self.authError = AuthValidation.mapAuthError(error)
                } else {
                    self.errorFullName = nil
                    self.errorEmail = nil
                    self.errorPassword = nil
                    self.errorConfirmPassword = nil
                    self.authError = nil
                }
            }
        }
    }
}
