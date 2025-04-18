//
//  ResultsView.swift
//  ScholarHelp
//
//  Created by Daniel Nuno on 4/18/25.
//

import SwiftUI

struct ResultsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userManager = UserManager.shared
    let gradeClass: Int
    
    @State private var showingHelpersList = false
    @State private var showingNeedHelpList = false
    @State private var offerHelp = false
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: AppTheme.smallPadding) {
                    Text("Your Academic Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Based on your responses")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(AppTheme.largePadding)
                .background(getGradeBackgroundColor())
                
                ScrollView {
                    VStack(spacing: AppTheme.padding) {
                        gradeCard
                        
                        gradeDetailsCard
                        
                        recommendationsCard
                        
                        connectCard
                    }
                    .padding()
                }
            }
            
            NavigationLink(destination: HelpersListView(), isActive: $showingHelpersList) {
                EmptyView()
            }
            
            NavigationLink(destination: NeedHelpListView(), isActive: $showingNeedHelpList) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { dismiss() }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
                .font(.title3)
        })
    }
    
    var gradeCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.padding) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(getGradeTitle())
                        .font(.headline)
                        .foregroundColor(AppTheme.textPrimary)
                    
                    Text(getGradeDescription())
                        .font(.subheadline)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(getGradeColor())
                        .frame(width: 60, height: 60)
                    
                    Text(getGradeLetter())
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .cardStyle()
    }
    
    var gradeDetailsCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.padding) {
            Text("Performance Breakdown")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            VStack(spacing: AppTheme.smallPadding) {
                performanceBar(title: "Study Habits", value: getStudyHabitsScore())
                performanceBar(title: "Engagement", value: getEngagementScore())
                performanceBar(title: "Support Systems", value: getSupportScore())
                performanceBar(title: "Academic Skills", value: getAcademicSkillsScore())
            }
        }
        .cardStyle()
    }
    
    var recommendationsCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.padding) {
            Text("Personalized Recommendations")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            VStack(alignment: .leading, spacing: AppTheme.padding) {
                ForEach(getRecommendations(), id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: AppTheme.smallPadding) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppTheme.primary)
                            .font(.title3)
                        
                        Text(recommendation)
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }
            }
        }
        .cardStyle()
    }
    
    var connectCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.padding) {
            Text("Connect With Others")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
            
            Text("ScholarHelp connects students who can help each other succeed.")
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
            
            HStack(spacing: AppTheme.padding) {
                if gradeClass <= 2 {
                    Button(action: {
                        offerHelp.toggle()
                        userManager.setUserAsHelper(isHelper: offerHelp)
                    }) {
                        HStack {
                            Image(systemName: offerHelp ? "hand.raised.fill" : "hand.raised")
                            Text(offerHelp ? "Helping Others" : "Offer Help")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle(backgroundColor: offerHelp ? AppTheme.secondary : AppTheme.primary))
                    
                    Button(action: {
                        showingNeedHelpList = true
                    }) {
                        HStack {
                            Image(systemName: "person.2")
                            Text("Struggling Students")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle(backgroundColor: AppTheme.textSecondary))
                } else {
                    Button(action: {
                        showingHelpersList = true
                    }) {
                        HStack {
                            Image(systemName: "person.2")
                            Text("Find Helpers")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
        }
        .cardStyle()
    }
    
    func performanceBar(title: String, value: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                
                Spacer()
                
                Text("\(Int(value * 100))%")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(getGradeColor())
                        .frame(width: geometry.size.width * value, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
    
    func getGradeBackgroundColor() -> Color {
        switch gradeClass {
        case 0:
            return AppTheme.primary
        case 1:
            return AppTheme.secondary
        case 2:
            return AppTheme.getGradeColor(2)
        case 3:
            return AppTheme.getGradeColor(3)
        default:
            return AppTheme.accent
        }
    }
    
    func getGradeColor() -> Color {
        switch gradeClass {
        case 0:
            return AppTheme.primary
        case 1:
            return AppTheme.secondary
        case 2:
            return AppTheme.getGradeColor(2)
        case 3:
            return AppTheme.getGradeColor(3)
        default:
            return AppTheme.accent
        }
    }
    
    func getGradeTitle() -> String {
        switch gradeClass {
        case 0:
            return "Excellent Performance"
        case 1:
            return "Good Performance"
        case 2:
            return "Average Performance"
        case 3:
            return "Needs Improvement"
        default:
            return "Struggling"
        }
    }
    
    func getGradeDescription() -> String {
        switch gradeClass {
        case 0:
            return "You're on track for outstanding academic success!"
        case 1:
            return "You're doing well with room for excellence"
        case 2:
            return "Your performance is average with potential to improve"
        case 3:
            return "You may need additional support to improve your grades"
        default:
            return "You're facing challenges that need to be addressed"
        }
    }
    
    func getGradeLetter() -> String {
        switch gradeClass {
        case 0:
            return "A"
        case 1:
            return "B"
        case 2:
            return "C"
        case 3:
            return "D"
        default:
            return "F"
        }
    }
    
    // Helper functions for performance metrics
    func getStudyHabitsScore() -> Double {
        switch gradeClass {
        case 0:
            return 0.95
        case 1:
            return 0.8
        case 2:
            return 0.6
        case 3:
            return 0.4
        default:
            return 0.2
        }
    }
    
    func getEngagementScore() -> Double {
        switch gradeClass {
        case 0:
            return 0.9
        case 1:
            return 0.75
        case 2:
            return 0.55
        case 3:
            return 0.35
        default:
            return 0.25
        }
    }
    
    func getSupportScore() -> Double {
        switch gradeClass {
        case 0:
            return 0.85
        case 1:
            return 0.7
        case 2:
            return 0.65
        case 3:
            return 0.45
        default:
            return 0.3
        }
    }
    
    func getAcademicSkillsScore() -> Double {
        switch gradeClass {
        case 0:
            return 0.9
        case 1:
            return 0.8
        case 2:
            return 0.6
        case 3:
            return 0.4
        default:
            return 0.2
        }
    }
    
    // Helper functions for recommendations
    func getRecommendations() -> [String] {
        switch gradeClass {
        case 0:
            return [
                "Continue your excellent study habits",
                "Consider mentoring other students who need help",
                "Explore advanced material to challenge yourself further",
                "Look into academic competitions or research opportunities"
            ]
        case 1:
            return [
                "Increase study time by 2-3 hours per week for optimal results",
                "Join study groups to enhance your understanding",
                "Seek feedback from teachers on areas to improve",
                "Consider additional practice in challenging subjects"
            ]
        case 2:
            return [
                "Establish a consistent study schedule of at least 10 hours weekly",
                "Find a study partner to help with accountability",
                "Use active learning techniques rather than passive reading",
                "Visit office hours or get tutoring for difficult subjects"
            ]
        case 3:
            return [
                "Create a structured daily study plan of at least 2 hours",
                "Seek tutoring for subjects where you're struggling",
                "Improve attendance and engagement in class",
                "Meet with academic advisors to discuss additional support options"
            ]
        default:
            return [
                "Establish regular meetings with teachers or tutors",
                "Create a daily structured study plan with specific goals",
                "Address any barriers to learning (attendance, focus issues)",
                "Consider academic coaching for study skills development",
                "Connect with counselors for additional support resources"
            ]
        }
    }
}

struct HelpersListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userManager = UserManager.shared
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(userManager.getHelpers()) { helper in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(AppTheme.primary)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(helper.username)
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                Text("Available for tutoring")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .padding(.leading, 8)
                            
                            Spacer()
                            
                            Button(action: {
                                // Action to message helper
                            }) {
                                Text("Message")
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(AppTheme.primary)
                                    .foregroundColor(.white)
                                    .cornerRadius(AppTheme.cornerRadius)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Available Helpers")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NeedHelpListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userManager = UserManager.shared
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(userManager.getNeedHelp()) { student in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(AppTheme.accent)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(student.username)
                                    .font(.headline)
                                    .foregroundColor(AppTheme.textPrimary)
                                
                                Text("Needs tutoring help")
                                    .font(.subheadline)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .padding(.leading, 8)
                            
                            Spacer()
                            
                            Button(action: {
                                // Action to offer help
                            }) {
                                Text("Offer Help")
                                    .font(.subheadline)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(AppTheme.secondary)
                                    .foregroundColor(.white)
                                    .cornerRadius(AppTheme.cornerRadius)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
        .navigationTitle("Students Needing Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}
