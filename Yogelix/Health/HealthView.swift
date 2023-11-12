//  HealthView.swift
import SwiftUI
import Charts

struct HealthView: View {
    @StateObject var viewModel = HealthDataViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Overview Cards
                HStack(spacing: 15) {
                    OverviewCard(title: "Yoga", subtitle: "45 min", imageName: "yoga")
                    OverviewCard(title: "Steps", subtitle: "\(viewModel.stepsData) Steps", imageName: "steps")
                    OverviewCard(title: "Sleep", subtitle: "7h 30m", imageName: "sleep")
                }

                // Detailed Data Section
                HeartRateGraphView(heartRateData: viewModel.heartRateData)

                // Women's Health Section
                WomenHealthSection()

                // Mindfulness and Meditation Section
                MindfulnessView()
            }
            .padding()
        }
        .navigationBarTitle("Dashboard", displayMode: .inline)
    }
}

struct OverviewCard: View {
    var title: String
    var subtitle: String
    var imageName: String

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct HeartRateGraphView: View {
    var heartRateData: [HeartRateData]

    var body: some View {
        VStack {
            Text("Heart Rate")
                .font(.headline)
            Chart(heartRateData) { data in
                LineMark(
                    x: .value("Date", data.date),
                    y: .value("Heart Rate", data.value)
                )
            }
            .frame(height: 150)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct WomenHealthSection: View {
    var body: some View {
        VStack {
            Text("Abdominal Cramps")
                .font(.headline)
            // Placeholder for Data Visualization
            Rectangle()
                .fill(Color.blue.opacity(0.3))
                .frame(height: 100)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct MindfulnessView: View {
    var body: some View {
        VStack {
            Text("Mindfulness")
                .font(.headline)
            // Placeholder for Mindfulness Data
            Rectangle()
                .fill(Color.green.opacity(0.3))
                .frame(height: 100)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}
