//
//  SignInViewModel.swift
//  skillmate
//
//  Created by Gui Maggiorini on 15/11/25.
//

import Foundation
import Observation

enum SignInField {
    case email
    case password
}

@Observable
class SignInViewModel {
    // Input
    var email: String = ""
    var password: String = ""
    
    // UI state
    var isLoading: Bool = false
    var isPasswordVisible: Bool = false
    
    // Errors
    var errorEmail: String? = nil
    var errorPassword: String? = nil
    var authError: String? = nil
    
    var isFormValid: Bool {
        AuthValidation.validateEmail(email) == nil &&
        AuthValidation.validatePassword(password) == nil
    }
    
    // MARK: - Input handlers
    
    func onEmailChange(_ newValue: String) {
        email = newValue
        errorEmail = nil
        authError = nil
    }
    
    func onPasswordChange(_ newValue: String) {
        password = newValue
        errorPassword = nil
        authError = nil
    }
    
    // MARK: - Actions
    
    func signIn(
        authService: AuthService,
        onFieldError: (SignInField) -> Void
    ) {
        authError = nil
        
        let trimmedEmail = email.trimmed
        
        if let emailError = AuthValidation.validateEmail(trimmedEmail) {
            errorEmail = emailError
            onFieldError(.email)
            return
        }
        
        if let passwordError = AuthValidation.validatePassword(password) {
            errorPassword = passwordError
            onFieldError(.password)
            return
        }
        
        isLoading = true
        
        authService.signIn(email: trimmedEmail, password: password) { [weak self] error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isLoading = false
                
                if let error {
                    self.authError = AuthValidation.mapAuthError(error)
                } else {
                    self.errorEmail = nil
                    self.errorPassword = nil
                    self.authError = nil
                }
            }
        }
    }
}
