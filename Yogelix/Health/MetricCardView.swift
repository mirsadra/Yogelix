//  MetricCardView.swift
import SwiftUI

struct MetricCardView: View {
    var title: String
    var value: String
    var subtitle: String
    var color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.black.opacity(0.8)))
        .shadow(radius: 5)
    }
}

