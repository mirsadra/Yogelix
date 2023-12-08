// PoseFilter.swift
import SwiftUI

struct PoseFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showFavoritesOnly: Bool
    @Binding var selectedChakra: ChakraDetail.Category?
    @Binding var filterByChakra: Bool
    @Binding var selectedElement: String?
    @Binding var filterByElement: Bool
    let uniqueElements: [String]

    var body: some View {
        NavigationView {
            Form {
                Toggle("Favorites only", isOn: $showFavoritesOnly)
                ChakraFilterSection(selectedChakra: $selectedChakra, filterByChakra: $filterByChakra)
                ElementFilterSection(selectedElement: $selectedElement, uniqueElements: uniqueElements, filterByElement: $filterByElement)
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing: DoneButton(presentationMode: _presentationMode))
        }
    }
}

private struct ChakraFilterSection: View {
    @Binding var selectedChakra: ChakraDetail.Category?
    @Binding var filterByChakra: Bool

    var body: some View {
        Section(header: Text("Chakra Filter")) {
            Picker("Select Chakra", selection: $selectedChakra) {
                Text("Any").tag(ChakraDetail.Category?.none)
                ForEach(ChakraDetail.Category.allCases, id: \.self) { chakra in
                    Text(chakra.rawValue).tag(chakra as ChakraDetail.Category?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            Toggle("Filter by Chakra", isOn: $filterByChakra)
        }
    }
}

private struct ElementFilterSection: View {
    @Binding var selectedElement: String?
    let uniqueElements: [String]
    @Binding var filterByElement: Bool

    var body: some View {
        Section(header: Text("Element Filter")) {
            Picker("Select Element", selection: $selectedElement) {
                Text("Any").tag(String?.none)
                ForEach(uniqueElements, id: \.self) { element in
                    Text(element).tag(element as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            Toggle("Filter by Element", isOn: $filterByElement)
        }
    }
}

private struct DoneButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button("Done") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
