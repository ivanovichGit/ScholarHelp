//
//  TestView.swift
//  ScholarHelp
//
//  Created by Daniel Nuno on 4/18/25.
//

import SwiftUI
import CoreML



struct SecondaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = AppTheme.cardBackground
    var foregroundColor: Color = AppTheme.textPrimary

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor.opacity(configuration.isPressed ? 0.9 : 1.0))
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.textSecondary.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(AppTheme.cornerRadius)
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(AppTheme.cardBackground)
            .cornerRadius(AppTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.textSecondary.opacity(0.08), lineWidth: 1)
            )
    }
}

struct TestView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userManager = UserManager.shared
    @ObservedObject private var themeManager = ThemeManager.shared

    @State private var navigateToResults = false
    @State private var predictionResult: Int?

    // Student information
    @State private var age                = 18
    @State private var gender             = false
    @State private var ethnicity          = 0
    @State private var parentalEducation  = 0
    @State private var studyTimeWeekly    = 20.0
    @State private var absences           = 0
    @State private var tutoring           = false
    @State private var parentalSupport    = 2
    @State private var extracurricular    = false
    @State private var sports             = false
    @State private var music              = false
    @State private var volunteering       = false
    @State private var gpa                = 2.0

    @State private var currentPage        = 0
    private let totalPages                = 3

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            VStack(spacing: 0) {

                HStack {
                    Text("Academic Profile")
                        .font(.title.bold())
                        .foregroundColor(AppTheme.textPrimary)

                    Spacer()

                    ThemeToggleButton()
                }
                .padding([.horizontal, .top, .bottom])

                HStack(spacing: 8) {
                    ForEach(0 ..< totalPages, id: \.self) { page in
                        Rectangle()
                            .fill(page <= currentPage
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary.opacity(0.3))
                            .frame(height: 4)
                            .cornerRadius(2)
                    }
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: AppTheme.padding) {
                        Text(getPageTitle())
                            .font(.title.bold())
                            .foregroundColor(AppTheme.textPrimary)
                            .padding(.top)

                        Text(getPageDescription())
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.bottom, AppTheme.padding)

                        if currentPage == 0      { basicInfoSection      }
                        else if currentPage == 1 { academicInfoSection   }
                        else                     { extracurricularSection }
                    }
                    .padding(.horizontal)
                }

                HStack(spacing: AppTheme.padding) {
                    if currentPage > 0 {
                        Button("Previous") { currentPage -= 1 }
                            .buttonStyle(SecondaryButtonStyle())
                    }

                    if currentPage < totalPages - 1 {
                        Button("Next") { currentPage += 1 }
                            .buttonStyle(PrimaryButtonStyle())
                    } else {
                        Button("Calculate Results", action: calculatePerformance)
                            .buttonStyle(PrimaryButtonStyle())
                    }
                }
                .padding()
            }

            NavigationLink(
                destination: ResultsView(gradeClass: predictionResult ?? -1),
                isActive: $navigateToResults
            ) { EmptyView() }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(AppTheme.textPrimary)
                    .font(.title3)
            }
        )
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }

    private var basicInfoSection: some View {
        VStack(spacing: AppTheme.padding) {

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Age")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                Slider(value: Binding(get: { Double(age) },
                                      set: { age = Int($0) }),
                       in: 10 ... 25, step: 1)
                    .accentColor(AppTheme.primary)

                Text("\(age) years old")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }.cardStyle()

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Gender")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                HStack {
                    genderButton(label: "Male",   selected: !gender) { gender = false }
                    genderButton(label: "Female", selected:  gender) { gender = true }
                }
            }.cardStyle()

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Ethnicity")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                Picker("", selection: $ethnicity) {
                    Text("Caucasian").tag(0)
                    Text("African-American").tag(1)
                    Text("Asian").tag(2)
                    Text("Other").tag(3)
                }
                .pickerStyle(.segmented)
            }.cardStyle()

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Parental Education")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                Picker("Parental Education", selection: $parentalEducation) {
                    Text("None").tag(0)
                    Text("High School").tag(1)
                    Text("Some College").tag(2)
                    Text("Bachelor's").tag(3)
                    Text("Higher").tag(4)
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
            }.cardStyle()
        }
    }

    private func genderButton(label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: "person.fill")
                Text(label)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(selected ? AppTheme.primary : Color.clear)
            .foregroundColor(selected ? .white : AppTheme.textPrimary)
            .cornerRadius(AppTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(selected
                            ? AppTheme.primary
                            : AppTheme.textSecondary.opacity(0.3), lineWidth: 1)
            )
        }
    }

    private var academicInfoSection: some View {
        VStack(spacing: AppTheme.padding) {

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Weekly Study Time")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                Slider(value: $studyTimeWeekly, in: 0 ... 40, step: 0.5)
                    .accentColor(AppTheme.primary)

                Text("\(String(format: "%.1f", studyTimeWeekly)) hours per week")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }.cardStyle()

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Absences")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                HStack {
                    minusPlusButton(systemName: "minus.circle.fill") { if absences > 0 { absences -= 1 } }
                    Text("\(absences)")
                        .font(.title)
                        .foregroundColor(AppTheme.textPrimary)
                        .frame(minWidth: 60)
                    minusPlusButton(systemName: "plus.circle.fill")  { if absences < 50 { absences += 1 } }
                }

                Text("Days absent this year")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }.cardStyle()

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Additional Support")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                Toggle("Tutoring", isOn: $tutoring)
                    .toggleStyle(SwitchToggleStyle(tint: AppTheme.primary))

                Divider()

                Text("Parental Support Level")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textPrimary)
                    .padding(.top, 5)

                Picker("", selection: $parentalSupport) {
                    Text("None").tag(0)
                    Text("Low").tag(1)
                    Text("Moderate").tag(2)
                    Text("High").tag(3)
                    Text("Very High").tag(4)
                }
                .pickerStyle(.segmented)
            }.cardStyle()

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Current GPA")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                Slider(value: $gpa, in: 0.0 ... 4.0, step: 0.01)
                    .accentColor(AppTheme.primary)

                HStack {
                    Text(String(format: "%.2f", gpa))
                        .font(.title2.bold())
                        .foregroundColor(AppTheme.primary)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("4.0: A")
                        Text("3.0: B")
                        Text("2.0: C")
                        Text("<2.0: F")
                    }
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
                }
            }.cardStyle()
        }
    }

    private func minusPlusButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(AppTheme.primary)
        }
    }

    private var extracurricularSection: some View {
        VStack(spacing: AppTheme.padding) {

            Text("Extracurricular Activities")
                .font(.headline)
                .foregroundColor(AppTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: AppTheme.smallPadding) {
                activityToggle(title: "General Extracurricular", description: "Clubs, organizations, etc.", isOn: $extracurricular)
                Divider()
                activityToggle(title: "Sports",        description: "Athletic participation", isOn: $sports)
                Divider()
                activityToggle(title: "Music",         description: "Instruments, choir, band", isOn: $music)
                Divider()
                activityToggle(title: "Volunteering",  description: "Community service", isOn: $volunteering)
            }
            .cardStyle()

            VStack(alignment: .leading, spacing: AppTheme.smallPadding) {
                Text("Your profile is almost complete!")
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                Text("Tap **Calculate Results** to see your academic prediction and get personalized assistance.")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.vertical)

                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.primary.opacity(0.8))
                    .frame(maxWidth: .infinity)
            }
            .cardStyle()
        }
    }

    private func activityToggle(title: String, description: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            Spacer()
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: AppTheme.primary))
        }
        .padding(.vertical, 5)
    }

    private func getPageTitle() -> String {
        ["Basic Information", "Academic Details", "Activities & Engagement"][currentPage]
    }

    private func getPageDescription() -> String {
        [
            "Tell us about yourself to help customize your academic profile.",
            "Share your current academic situation and support systems.",
            "Let us know about your extracurricular involvement."
        ][currentPage]
    }

    private func calculatePerformance() {
        do {
            let model = try GradeClassML(configuration: MLModelConfiguration())

            let input = GradeClassMLInput(
                Age: Int64(age),
                Gender: Int64(gender ? 1.0 : 0.0),
                Ethnicity: Int64(ethnicity),
                ParentalEducation: Int64(parentalEducation),
                StudyTimeWeekly: studyTimeWeekly,
                Absences: Int64(absences),
                Tutoring: Int64(tutoring ? 1.0 : 0.0),
                ParentalSupport: Int64(parentalSupport),
                Extracurricular: Int64(extracurricular ? 1.0 : 0.0),
                Sports: Int64(sports ? 1.0 : 0.0),
                Music: Int64(music ? 1.0 : 0.0),
                Volunteering: Int64(volunteering ? 1.0 : 0.0),
                GPA: gpa
            )
            /* print("""
            Inputs to model:
            Age: \(age),
            Gender: \(gender),
            Ethnicity: \(ethnicity),
            ParentalEducation: \(parentalEducation),
            StudyTimeWeekly: \(studyTimeWeekly),
            Absences: \(absences),
            Tutoring: \(tutoring),
            ParentalSupport: \(parentalSupport),
            Extracurricular: \(extracurricular),
            Sports: \(sports),
            Music: \(music),
            Volunteering: \(volunteering),
            GPA: \(gpa)
            """)
             */

            let output = try model.prediction(input: input)
            
            print("Model output: \(output.GradeClass)")

            predictionResult = Int(round(output.GradeClass))
            
            // print("Predicted Grade Class: \(predictionResult ?? -1)")
            

        } catch {
            print("Error in prediction: \(error)")
            predictionResult = -1
        }

        userManager.updateCurrentUserGrade(gradeClass: predictionResult ?? -1)
        navigateToResults = true
    }

}
