//  HomeView.swift
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack {
                cell(header: "Text Here", text: "336.851", color: Color.orange)
                cell(header: "Text Here", text: "336.851", color: Color.red)
            }
            HStack {
                cell(header: "Text Here", text: "336.851", color: Color.green)
                cell(header: "Text Here", text: "336.851", color: Color.blue)
                cell(header: "Text Here", text: "336.851", color: Color.purple)
            }
        }
    }

    func cell(header: String, text: String, color: Color) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(header)
                    .font(.caption)
                Text(text)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(color)
        .cornerRadius(10)
        .padding(10)
    }
}

#Preview {
    HomeView()
}
