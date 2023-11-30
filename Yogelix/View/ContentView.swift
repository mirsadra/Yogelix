//  ContentView.swift
import SwiftUI

struct ContentView: View {

    var body: some View {
        Image(systemName: "bolt")
            .resizable()
            .frame(width: 220, height: 400)
            .foregroundColor(.yellow)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
