//  AsanasExplorerView.swift
import SwiftUI

struct AsanasExplorerView: View {
    @ObservedObject var viewModel = AsanasExplorerViewModel()
    @State private var selectedCategory = "All"

    var body: some View {
        NavigationView {
            VStack {
                searchField
                categoryPicker
                
            }
            .navigationBarTitle("Asanas Explorer", displayMode: .inline)
        }
    }

    private var searchField: some View {
        TextField("Search asanas", text: $viewModel.searchText)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()
    }

    private var categoryPicker: some View {
        Picker("Category", selection: $viewModel.selectedCategory) {
            Text("All").tag("All")
            // Add other categories here...
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }

}

#Preview {
    AsanasExplorerView()
}
