//  CustomActivityRingView.swift
import SwiftUI
import HealthKitUI

struct CustomActivityRingView: View {
    @ObservedObject var healthDataViewModel: HealthDataViewModel
    
    var body: some View {
        VStack{
            HStack {
                // Move ring
                //                RingView(progress: CGFloat(healthDataViewModel.moveRingProgress), startColor: .red, endColor: .orange, labelText: "Move", systemImageName: "flame.fill")
                // Exercise ring
                //                RingView(progress: CGFloat(healthDataViewModel.exerciseRingProgress), startColor: .green, endColor: .blue, labelText: "Exercise", systemImageName: "medal")
                // Stand ring
                //                RingView(progress: CGFloat(healthDataViewModel.standRingProgress), startColor: .blue, endColor: .purple, labelText: "Stand", systemImageName: "figure.stand")
            }
            HStack {
                // Move ring
                //                RingView(progress: CGFloat(healthDataViewModel.moveRingProgress), startColor: .red, endColor: .orange, labelText: "Move", systemImageName: "flame.fill")
                //                // Exercise ring
                //                RingView(progress: CGFloat(healthDataViewModel.exerciseRingProgress), startColor: .green, endColor: .blue, labelText: "Exercise", systemImageName: "medal")
                //            }
                
            }
        }
    }
    
    struct RingView: View {
        var progress: CGFloat
        var startColor: Color
        var endColor: Color
        var labelText: String
        var systemImageName: String
        @Environment(\.colorScheme) var colorScheme // Detects the current color scheme
        
        
        var labelColor: Color {
            colorScheme == .light ? .black : .white
        }
        
        var imageColor: Color {
            switch systemImageName {
                case "flame.fill":
                    return .red // Flame icon will be red
                default:
                    return labelColor // Other icons will match the label color
            }
        }
        
        var body: some View {
            ZStack {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: progress)
                
                Label {
                    Text(labelText)
                        .font(.caption)
                        .foregroundColor(labelColor)
                } icon: {
                    Image(systemName: systemImageName)
                        .foregroundColor(imageColor)
                }
            }
        }
    }
    
    //struct HealthKitRingView: UIViewRepresentable {
    //    @ObservedObject var healthDataViewModel: HealthDataViewModel
    //
    //    func makeUIView(context: Context) -> HKActivityRingView {
    //        return HKActivityRingView()
    //    }
    
    //    func updateUIView(_ uiView: HKActivityRingView, context: Context) {
    //        // Update to use healthDataViewModel's activitySummary
    //        if let summary = healthDataViewModel.activitySummary.copy() as? HKActivitySummary {
    //            uiView.setActivitySummary(summary, animated: true)
    //        }
    //    }
    
}
