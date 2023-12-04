//  PosesList.swift
import SwiftUI

struct PoseList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    @State private var selectedChakra: ChakraDetail.Category? = nil
    @State private var filterByChakra = false
    @State private var selectedElement: String? = nil
    @State private var filterByElement = false
    @State private var filterByPetal = false
    @State private var selectedPetal: Int? = nil
    @State private var showingFilter = false

    var body: some View {
        NavigationSplitView {
            List {
                // Poses Section
                Section(header: Text("All Poses")) {
                    ForEach(filteredPoses) { pose in
                        NavigationLink {
                            PoseDetail(pose: pose)
                        } label: {
                            PoseRow(pose: pose)
                        }
                    }
                }
            }
            .navigationTitle("Yoga Poses")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingFilter = true
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilter) {
                PoseFilterView(
                    showFavoritesOnly: $showFavoritesOnly,
                    selectedChakra: $selectedChakra,
                    filterByChakra: $filterByChakra,
                    selectedElement: $selectedElement,
                    filterByElement: $filterByElement,
                    selectedPetal: $selectedPetal,
                    filterByPetal: $filterByPetal,
                    uniqueElements: modelData.uniqueElements,
                    uniquePetals: modelData.uniquePetals
                    
                )
            }
        } detail: {
            Text("Select a Pose or Chakra")
        }
    }

    var filteredPoses: [Pose] {
        modelData.poses.filter { pose in
            let favoritesCondition = (!showFavoritesOnly || pose.isFavorite)
            let chakraCondition = (!filterByChakra || (selectedChakra != nil && pose.chakraDetails.contains { $0.name == selectedChakra }))
            let elementCondition = (!filterByElement || (selectedElement != nil && pose.chakraDetails.contains { $0.element == selectedElement }))
            let petalCondition = (!filterByPetal || (selectedPetal != nil && pose.chakraDetails.contains { $0.numberOfPetals == selectedPetal }))
            return favoritesCondition && chakraCondition && elementCondition && petalCondition
        }
    }
}

struct PoseList_Previews: PreviewProvider {
    static var previews: some View {
        PoseList()
            .environmentObject(ModelData())
    }
}
