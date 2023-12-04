//  StartWorkout.swift
import SwiftUI

struct StartWorkout: View {
    @State var isBegin = false
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(width: 200, height: 120)
                .opacity(0.4)
            
            VStack {
                Button("Ready?") {
                    isBegin.toggle()
                    // Handle action
                }
                
                Image(systemName: isBegin ? "figure.walk.departure" : "figure.walk.motion")
                    .symbolRenderingMode(.palette)
                    .animation(.linear(duration: 0.5), value: isBegin)
                
                HStack {
                    // Time picker
                    
                }
            }
        }
    }
}

#Preview {
    StartWorkout()
}
