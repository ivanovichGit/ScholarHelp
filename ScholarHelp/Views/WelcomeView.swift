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




