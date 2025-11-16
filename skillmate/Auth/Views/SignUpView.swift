//
//  SignUpView.swift
//  skillmate
//
//  Created by Gui Maggiorini on 15/11/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthService.self) private var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel = SignUpViewModel()
    @FocusState private var focusedField: Field?
    
    // if I put this placeholder directly into TextField, it will turn the placeholder into a "mailto" link.
    // this is an easy workaround that i've found.
    private let emailPlaceholder: String = "name@example.com"
    
    enum Field {
        case fullName
        case email
        case password
        case confirmPassword
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                header
                fields
                authErrorView
                submitButton
                footer
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
        }
        .onChange(of: authService.isSignedIn) { _, isSignedIn in
            if isSignedIn {
                dismiss()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Get started")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Let's set up your account")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 8)
    }
    
    private var fields: some View {
        VStack(spacing: 14) {
            // Full name
            AuthInputField(title: "Full name", error: viewModel.errorFullName) {
                TextField(
                    "Your full name",
                    text: Binding(
                        get: { viewModel.fullName },
                        set: { viewModel.onFullNameChange($0) }
                    )
                )
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .fullName)
                .submitLabel(.next)
                .onSubmit(submitCurrentField)
            }
            .accessibilityLabel("Full name")
            
            // Email
            AuthInputField(title: "Email", error: viewModel.errorEmail) {
                TextField(
                    emailPlaceholder,
                    text: Binding(
                        get: { viewModel.email },
                        set: { viewModel.onEmailChange($0) }
                    )
                )
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .textContentType(.emailAddress)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit(submitCurrentField)
            }
            .accessibilityLabel("Email")
            
            // Password
            AuthInputField(title: "Password", error: viewModel.errorPassword) {
                HStack(spacing: 8) {
                    Group {
                        if viewModel.isPasswordVisible {
                            TextField(
                                "At least 6 characters",
                                text: Binding(
                                    get: { viewModel.password },
                                    set: { viewModel.onPasswordChange($0) }
                                )
                            )
                            .textContentType(.newPassword)
                        } else {
                            SecureField(
                                "At least 6 characters",
                                text: Binding(
                                    get: { viewModel.password },
                                    set: { viewModel.onPasswordChange($0) }
                                )
                            )
                            .textContentType(.newPassword)
                        }
                    }
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit(submitCurrentField)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            viewModel.isPasswordVisible.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.separator)
                            .contentShape(Rectangle())
                            .accessibilityLabel(viewModel.isPasswordVisible ? "Hide password" : "Show password")
                    }
                }
            }
            .accessibilityLabel("Password")
            
            // Confirm password
            AuthInputField(title: "Confirm password", error: viewModel.errorConfirmPassword) {
                HStack(spacing: 8) {
                    Group {
                        if viewModel.isConfirmPasswordVisible {
                            TextField(
                                "Repeat your password",
                                text: Binding(
                                    get: { viewModel.confirmPassword },
                                    set: { viewModel.onConfirmPasswordChange($0) }
                                )
                            )
                            .textContentType(.newPassword)
                        } else {
                            SecureField(
                                "Repeat your password",
                                text: Binding(
                                    get: { viewModel.confirmPassword },
                                    set: { viewModel.onConfirmPasswordChange($0) }
                                )
                            )
                            .textContentType(.newPassword)
                        }
                    }
                    .focused($focusedField, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit(submitCurrentField)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            viewModel.isConfirmPasswordVisible.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.isConfirmPasswordVisible ? "eye.slash" : "eye")
                            .foregroundStyle(.separator)
                            .contentShape(Rectangle())
                            .accessibilityLabel(
                                viewModel.isConfirmPasswordVisible
                                ? "Hide confirm password"
                                : "Show confirm password"
                            )
                    }
                }
            }
            .accessibilityLabel("Confirm password")
        }
        .padding(.top, 4)
    }
    
    private var authErrorView: some View {
        Group {
            if let authError = viewModel.authError {
                Label(authError, systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.orange)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .accessibilityLabel("Authentication error: \(authError)")
            }
        }
    }
    
    private var submitButton: some View {
        Button(action: handleSignup) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "arrow.right.circle.fill")
                }
                Text("Create account")
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding(7)
        }
        .buttonStyle(.borderedProminent)
        .tint(.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .disabled(viewModel.isLoading)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isFormValid)
        .accessibilityHint("Sign up with email and password")
    }
    
    private var footer: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .foregroundStyle(.secondary)
            NavigationLink("Sign in", destination: SignInView())
                .fontWeight(.semibold)
        }
        .font(.footnote)
        .padding(.top, 4)
    }
    
    // MARK: - Actions
    
    private func submitCurrentField() {
        switch focusedField {
        case .fullName:
            focusedField = .email
        case .email:
            focusedField = .password
        case .password:
            focusedField = .confirmPassword
        case .confirmPassword:
            if viewModel.isFormValid && !viewModel.isLoading {
                handleSignup()
            }
        case .none:
            break
        }
    }
    
    private func handleSignup() {
        viewModel.signUp(authService: authService) { field in
            switch field {
            case .fullName:
                focusedField = .fullName
            case .email:
                focusedField = .email
            case .password:
                focusedField = .password
            case .confirmPassword:
                focusedField = .confirmPassword
            }
        }
    }
}

#Preview {
    SignUpView()
        .environment(AuthService())
}
