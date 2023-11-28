//  Home.swift
import SwiftUI

struct Home: View {
    
    @State private var items: [Item] = [.red, .blue, .green, .yellow, .black].compactMap {
        return .init(color: $0) }
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                LoopingScrollView(width: 150, spacing: 10, items: items) { item in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(item.color.gradient)
                }
                .frame(height: 150)
                .contentMargins(.horizontal, 15, for: .scrollContent)
            }
            .padding(.vertical, 15)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    MainScrollView()
}
