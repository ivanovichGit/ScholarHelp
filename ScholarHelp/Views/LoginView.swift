//
//  LoginView.swift
//  ScholarHelp
//
//  Created by Daniel Nuno on 4/19/25.
//

import SwiftUI

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
