import SwiftUI
import CoreML

struct ContentView: View {
    @State private var age: Int = 10
    @State private var gender: Bool = false // false = Male, true = Female
    @State private var ethnicity: Int = 0
    @State private var parentalEducation: Int = 0
    @State private var studyTimeWeekly: Double = 0.0
    @State private var absences: Int = 0
    @State private var tutoring: Bool = false
    @State private var parentalSupport: Int = 0
    @State private var extracurricular: Bool = false
    @State private var sports: Bool = false
    @State private var music: Bool = false
    @State private var volunteering: Bool = false
    @State private var gpa: Double = 0.0

    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Student Information")) {
                    Picker("Age", selection: $age) {
                        ForEach(10...99, id: \.self) { age in
                            Text("\(age)").tag(age)
                        }
                    }

                    Toggle("Gender: \(gender ? "Female" : "Male")", isOn: $gender)

                    Picker("Ethnicity", selection: $ethnicity) {
                        Text("Caucasian").tag(0)
                        Text("African-American").tag(1)
                        Text("Asian").tag(2)
                        Text("Other").tag(3)
                    }

                    Picker("Parental Education", selection: $parentalEducation) {
                        Text("None").tag(0)
                        Text("High School").tag(1)
                        Text("Some College").tag(2)
                        Text("Bachelors").tag(3)
                        Text("Higher").tag(4)
                    }

                    Stepper("Study Time Weekly: \(String(format: "%.1f", studyTimeWeekly)) hours", value: $studyTimeWeekly, in: 0...40, step: 0.5)

                    Picker("Absences", selection: $absences) {
                        ForEach(0...50, id: \.self) { absence in
                            Text("\(absence)").tag(absence)
                        }
                    }

                    Toggle("Tutoring: \(tutoring ? "Yes" : "No")", isOn: $tutoring)

                    Picker("Parental Support", selection: $parentalSupport) {
                        Text("None").tag(0)
                        Text("Low").tag(1)
                        Text("Moderate").tag(2)
                        Text("High").tag(3)
                        Text("Very High").tag(4)
                    }

                    Toggle("Extracurricular: \(extracurricular ? "Yes" : "No")", isOn: $extracurricular)
                    Toggle("Sports: \(sports ? "Yes" : "No")", isOn: $sports)
                    Toggle("Music: \(music ? "Yes" : "No")", isOn: $music)
                    Toggle("Volunteering: \(volunteering ? "Yes" : "No")", isOn: $volunteering)

                    Stepper("GPA: \(String(format: "%.2f", gpa))", value: $gpa, in: 2.0...4.0, step: 0.01)
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
        do {
            let config = MLModelConfiguration()
            let model = try GradeClassML(configuration: config)

            let prediction = try model.prediction(
                Age: Int64(age),
                Gender: gender ? 1 : 0,
                Ethnicity: Int64(ethnicity),
                ParentalEducation: Int64(parentalEducation),
                StudyTimeWeekly: studyTimeWeekly,
                Absences: Int64(absences),
                Tutoring: tutoring ? 1 : 0,
                ParentalSupport: Int64(parentalSupport),
                Extracurricular: extracurricular ? 1 : 0,
                Sports: sports ? 1 : 0,
                Music: music ? 1 : 0,
                Volunteering: volunteering ? 1 : 0,
                GPA: gpa
            )

            let gradeClass = Int(prediction.GradeClass)

            alertTitle = "Prediction Result"
            alertMessage = {
                switch gradeClass {
                case 0: return "A - High performance"
                case 1: return "B - Nice performance"
                case 2: return "C - Medium performance"
                case 3: return "D - Low performance"
                case 4: return "F - Sad performance"
                default: return "Unknown performance"
                }
            }()
        } catch {
            alertTitle = "Error"
            alertMessage = "Prediction failed. Please try again."
        }
        showingAlert = true
    }
}
