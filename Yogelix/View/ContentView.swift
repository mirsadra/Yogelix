//  ContentView.swift
import SwiftUI

struct ContentView: View {

    var body: some View {
        
        NavigationView {
            PoseList()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ModelData())
}
