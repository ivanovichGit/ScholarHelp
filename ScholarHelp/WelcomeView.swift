//
//  WelcomeView.swift
//  ScholarHelp
//
//  Created by Daniel Nuno on 4/18/25.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                VStack(spacing: AppTheme.largePadding) {
                    HStack {
                        Spacer()
                        ThemeToggleButton()
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    VStack(spacing: AppTheme.smallPadding) {
                        Image(systemName: "graduationcap.fill")
                            .font(.system(size: 80))
                            .foregroundColor(AppTheme.primary)
                        
                        Text("ScholarHelp")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    
                    VStack(spacing: AppTheme.padding) {
                        Text("Unlock Your Academic Potential")
                            .font(.title2.weight(.semibold))
                            .foregroundColor(AppTheme.textPrimary)
                            .multilineTextAlignment(.center)
                        
                        Text("Many students struggle with their grades and academic performance. ScholarHelp uses advanced AI to predict your academic path and connect you with resources for success.")
                            .font(.body)
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: -15) {
                        ForEach(1...3, id: \.self) { i in
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(i == 1 ? AppTheme.primary : (i == 2 ? AppTheme.secondary : AppTheme.accent))
                                .overlay(
                                    Circle().stroke(AppTheme.background, lineWidth: 2)
                                )
                        }
                    }
                    
                    Text("Join thousands of students improving their grades")
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                    
                    Spacer()
                    
                    VStack(spacing: AppTheme.padding) {
                        NavigationLink { LoginView() } label: {
                            Text("Login")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.primary)
                                .foregroundColor(.white)
                                .cornerRadius(AppTheme.cornerRadius)
                        }
                        
                        NavigationLink { RegisterView() } label: {
                            Text("Create Account")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.clear)
                                .foregroundColor(AppTheme.primary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                        .stroke(AppTheme.primary, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationBarHidden(true)
            .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        }
    }
}

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var userManager = UserManager.shared
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var username = ""
    @State private var password = ""
    @State private var showAuthError = false
    @State private var navigateToTest = false
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: AppTheme.padding) {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(AppTheme.textPrimary)
                            .font(.title2)
                    }
                    Spacer()
                    ThemeToggleButton()
                }
                
                Text("Welcome Back")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.top)
                
                Text("Log in to continue your academic journey")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.bottom, AppTheme.largePadding)
                
                VStack(spacing: AppTheme.padding) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(AppTheme.cardBackground)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                 .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 1))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(AppTheme.cardBackground)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                 .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 1))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
                
                Spacer()
                
                NavigationLink(destination: TestView().environmentObject(userManager),
                               isActive: $navigateToTest) { EmptyView() }
                
                Button {
                    if userManager.login(username: username, password: password) {
                        navigateToTest = true
                    } else {
                        showAuthError = true
                    }
                } label: {
                    Text("Login").fontWeight(.semibold)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
        .alert("Invalid username or password", isPresented: $showAuthError) {
            Button("OK", role: .cancel) { }
        }
    }
}

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
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(AppTheme.accent)
                        .padding(.top, 8)
                }
                
                Spacer()
                
                NavigationLink(destination: TestView().environmentObject(userManager), isActive: $navigateToTest) { EmptyView() }
                
                Button {
                    if username.isEmpty || password.isEmpty {
                        errorMessage = "Please fill all fields"; showError = true; return }
                    if password != confirmPassword {
                        errorMessage = "Passwords don't match"; showError = true; return }
                    
                    if userManager.register(username: username, password: password) {
                        navigateToTest = true
                    } else {
                        errorMessage = "Username already exists"; showError = true
                    }
                } label: {
                    Text("Create Account").fontWeight(.semibold)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.top)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}
