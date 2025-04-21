//
//  RegisterView.swift
//  ScholarHelp
//
//  Created by Daniel Nuno on 4/19/25.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var userManager = UserManager.shared
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var navigateToTest = false
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: AppTheme.padding) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(AppTheme.textPrimary)
                            .font(.title2)
                    }
                    Spacer()
                    ThemeToggleButton()
                }
                
                Text("Create Account")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.top)
                
                Text("Join ScholarHelp to improve your academic performance")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.bottom, AppTheme.largePadding)
                
                VStack(spacing: AppTheme.padding) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(AppTheme.cardBackground)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(AppTheme.cardBackground)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(AppTheme.cardBackground)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
                
                
                Spacer()
                
                NavigationLink(destination: TestView().environmentObject(userManager), isActive: $navigateToTest) { EmptyView() }
                
                Button {
                    if username.isEmpty || password.isEmpty {
                        errorMessage = "Please fill all fields"
                        showError = true
                        return
                    }
                    if password != confirmPassword {
                        errorMessage = "Passwords don't match"
                        showError = true
                        return
                    }
                    
                    if userManager.register(username: username, password: password) {
                        navigateToTest = true
                    } else {
                        errorMessage = "Username already exists"
                        showError = true
                    }
                } label: {
                    Text("Create Account").fontWeight(.semibold)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top)
                
            }
            .padding()
        }
        .alert(isPresented: $showError) {
                    Alert(
                        title: Text("Registration Error"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("OK")) {
                            showError = false
                        }
                    )
                }
        .navigationBarHidden(true)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}
