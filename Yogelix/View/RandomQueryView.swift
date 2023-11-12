//  RandomQueryView.swift
import SwiftUI

struct RandomQueryView: View {
    var userData: UserData
    var funFacts: [String] {
        [
            "You are \(userData.age) years old.",
            "Your weight is \(userData.weight) kg.",
            "You are \(userData.height) cm tall.",
            "You have \(userData.yogaExperienceYears) years of yoga experience.",
            "Your gender is \(userData.gender.rawValue).",
            "Your body type is \(userData.bodyType.rawValue)."
        ]
    }
    @State private var randomFact = ""

    var body: some View {
        ZStack {
            VStack {
                Text("Personalized Query")
                    .font(.largeTitle)
                Divider()
                Text(randomFact)
                    .font(.title)
                    .frame(maxWidth: 400, minHeight: 300)
                
                Button("Show Random Fact") {
                    randomFact = funFacts.randomElement() ?? "No Fun."
                }
                DisclosureGroup {
                                HStack(spacing: 30) {
                                    Text("Age: \(userData.age)")
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                    Text("Height: \(userData.height)")
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                    Text("Weight: \(userData.weight)")
                                        .frame(width: 70, height: 70)
                                        .cornerRadius(10)
                                    Spacer()
                                }
                                .padding(.vertical)
                            } label: {
                                Text("Guess my favorite colors")
                                    .font(.title2)
                            }
            }
            .padding()
        }
    }
}

struct RandomQueryView_Previews: PreviewProvider {
    static var previews: some View {
        RandomQueryView(userData: sampleData)
    }
}
