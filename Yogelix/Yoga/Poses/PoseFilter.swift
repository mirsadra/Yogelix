// PoseFilter.swift
import SwiftUI

struct PoseFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showFavoritesOnly: Bool
    @Binding var selectedChakra: ChakraDetail.Category?
    @Binding var filterByChakra: Bool
    @Binding var selectedElement: String?
    @Binding var filterByElement: Bool
    @Binding var selectedPetal: Int?
    @Binding var filterByPetal: Bool
    
    let uniqueElements: [String]
    let uniquePetals: [Int]

    var body: some View {
        NavigationView {
            Form {
                Toggle("Favorites only", isOn: $showFavoritesOnly)

                chakraFilterSection

                elementFilterSection

                petalFilterSection
            }
            .navigationTitle("Filters")
            .navigationBarItems(trailing: doneButton)
        }
    }

    private var chakraFilterSection: some View {
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

    private var elementFilterSection: some View {
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

    private var petalFilterSection: some View {
        Section(header: Text("Number of Petals Filter")) {
            Picker("Select Petals", selection: $selectedPetal) {
                Text("Any").tag(Int?.none)
                ForEach(uniquePetals, id: \.self) { petal in
                    Text("\(petal)").tag(petal as Int?)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Toggle("Filter by Number of Petals", isOn: $filterByPetal)
        }
    }

    private var doneButton: some View {
        Button("Done") {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
