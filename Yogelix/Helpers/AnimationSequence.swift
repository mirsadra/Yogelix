import SwiftUI
import Combine

struct AnimationSequence: View {
    @State private var rotationAngle: Angle = .degrees(0)
    @State private var currentSymbolIndex = 0
    private let symbols = ["figure.walk", "figure.walk.motion", "figure.run", "figure.yoga", "figure.mind.and.body", "brain.head.profile"] // Added an AI-themed symbol
    @State private var backgroundColor: Color = .white
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Use a gradient or image background representing yoga and science
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.5), Color.blue.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                // Display the app slogan
                
                Text("Yogelix")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .rotation3DEffect(
                        rotationAngle,
                        axis: (x: 0, y: 1, z: 0)
                    )
                
                Spacer()
                
                SymbolView(symbol: symbols[currentSymbolIndex])
                    .symbolEffect(.pulse)
            }
            .padding()
            
            .onReceive(timer) { _ in
                withAnimation {
                    currentSymbolIndex = (currentSymbolIndex + 1) % symbols.count
                    backgroundColor = Color(hue: Double(currentSymbolIndex) / Double(symbols.count), saturation: 0.5, brightness: 0.95)
                    rotationAngle += .degrees(360)
                }
            }
        }
    }
}

struct SymbolView: View {
    let symbol: String
    var body: some View {
        Image(systemName: symbol)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
        // Use a serene and calming color for the symbols
            .foregroundColor(symbolColor(symbol))
            .padding()
    }
    
    // Determine the color based on the symbol representing different yoga activities
    func symbolColor(_ symbol: String) -> Color {
        switch symbol {
            case "figure.yoga", "figure.mind.and.body":
                return .indigo // Blue for a calm, yoga-related color
            default:
                return .gray // Gray for less focus
        }
    }
}

struct AnimationSequence_Previews: PreviewProvider {
    static var previews: some View {
        AnimationSequence()
    }
}
