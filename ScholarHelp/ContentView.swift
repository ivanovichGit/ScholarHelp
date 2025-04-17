//
//  ContentView.swift
//  ScholarHelp
//
//  Created by Ivanovich Chiu on 16/04/25.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var Age: String = ""
    @State private var Gender: String = ""
    @State private var Ethnicity: String = ""
    @State private var ParentalEducation: String = ""
    @State private var StudyTimeWeekly: String = ""
    @State private var Absences: String = ""
    @State private var Tutoring: String = ""
    @State private var ParentalSupport: String = ""
    @State private var Extracurricular: String = ""
    @State private var Sports: String = ""
    @State private var Music: String = ""
    @State private var Volunteering: String = ""
    @State private var GPA: String = ""
    @State private var GradeClass: String = ""

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Student Information")) {
                    TextField("Age", text: $Age)
                        .keyboardType(.numberPad)
                    TextField("Gender", text: $Gender)
                    TextField("Ethnicity", text: $Ethnicity)
                    TextField("Parental Education", text: $ParentalEducation)
                    TextField("Study Time Weekly", text: $StudyTimeWeekly)
                        .keyboardType(.numberPad)
                    TextField("Absences", text: $Absences)
                        .keyboardType(.numberPad)
                    TextField("Tutoring", text: $Tutoring)
                    TextField("Parental Support", text: $ParentalSupport)
                    TextField("Extracurricular", text: $Extracurricular)
                    TextField("Sports", text: $Sports)
                    TextField("Music", text: $Music)
                    TextField("Volunteering", text: $Volunteering)
                    TextField("GPA", text: $GPA)
                        .keyboardType(.decimalPad)
                }

                Button("Calculate Student Performance", action: calculatePerformance)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .navigationTitle("Student Performance Predictor")
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    func calculatePerformance() {
        // Validate numeric inputs
        guard let ageVal = Int64(Age),
              let genderVal = Int64(Gender),
              let ethnicityVal = Int64(Ethnicity),
              let parentalEducationVal = Int64(ParentalEducation),
              let studyTimeWeeklyVal = Double(StudyTimeWeekly),
              let absencesVal = Int64(Absences),
              let tutoringVal = Int64(Tutoring),
              let parentalSupportVal = Int64(ParentalSupport),
              let extracurricularVal = Int64(Extracurricular),
              let sportsVal = Int64(Sports),
              let musicVal = Int64(Music),
              let volunteeringVal = Int64(Volunteering),
              let gpaVal = Double(GPA)
            
            else {
            alertTitle = "Input Error"
            alertMessage = "Please enter valid numeric values in the appropriate fields."
            showingAlert = true
            return
        }

        print("Age: \(ageVal), Gender: \(genderVal), Ethnicity: \(ethnicityVal), ParentalEducation: \(parentalEducationVal), StudyTimeWeekly: \(studyTimeWeeklyVal), Absences: \(absencesVal), Tutoring: \(tutoringVal), ParentalSupport: \(parentalSupportVal), Extracurricular: \(extracurricularVal), Sports: \(sportsVal), Music: \(musicVal), Volunteering: \(volunteeringVal), GPA: \(GPA)")

        do {
            let config = MLModelConfiguration()
            let model = try GradeClassML(configuration: config)

            let prediction = try model.prediction(
                Age: ageVal,
                Gender: genderVal,
                Ethnicity: ethnicityVal,
                ParentalEducation: parentalEducationVal,
                StudyTimeWeekly: studyTimeWeeklyVal,
                Absences: absencesVal,
                Tutoring: tutoringVal,
                ParentalSupport: parentalSupportVal,
                Extracurricular: extracurricularVal,
                Sports: sportsVal,
                Music: musicVal,
                Volunteering: volunteeringVal,
                GPA: gpaVal
            )

            print("Predicted Outcome: \(prediction.GradeClass)")
            
            let gradeClass = Int64(prediction.GradeClass)
            
            alertTitle = "Prediction Result"
            
            switch gradeClass {
            case 0:
                alertMessage = "A - High performance"
            case 1:
                alertMessage = "B - Nice performance"
            case 2:
                alertMessage = "C - Medium performance"
            case 3:
                alertMessage = "D - Low performance"
            case 4:
                alertMessage = "F - Sad performance"
            default:
                alertMessage = "Unknown performance"
            }
        } catch {
            alertTitle = "Error"
            alertMessage = "Prediction failed. Please try again."
        }
        showingAlert = true
    }
}
