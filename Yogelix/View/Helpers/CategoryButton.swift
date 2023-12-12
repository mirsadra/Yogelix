//  CategoryButton.swift
import SwiftUI

struct CategoryButton: View {
    let category: MetadataCategory
    @Binding var selectedCategory: MetadataCategory?
    
    var body: some View {
        Button(action: {
            self.selectedCategory = self.category
        }) {
            Text(category.rawValue)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(self.selectedCategory == category ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(self.selectedCategory == category ? Color.white : Color.black)
                .font(.system(size: 14, weight: .semibold))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(self.selectedCategory == category ? Color.blue : Color.clear, lineWidth: 1)
                )
        }
    }
}

