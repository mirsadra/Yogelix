//  ContentView.swift
import SwiftUI

struct ContentView: View {

    var body: some View {
        
            PoseList()

    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
