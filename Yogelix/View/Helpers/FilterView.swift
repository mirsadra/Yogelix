//  FilterView.swift
import SwiftUI

/// A view for filtering yoga poses based on various criteria.
struct FilterView: View {
    @EnvironmentObject var poseData: PoseData
    
    @Binding var filterText: String
    @Binding var filterDifficulty: Int?
    @Binding var filterBenefits: String
    @Binding var filterPrecautions: String
    @Binding var filterLevel: String
    @Binding var showFavoritesOnly: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Search Filters")) {
                    Toggle("Show Favorites Only", isOn: $showFavoritesOnly)
                }

                Section(header: Text("Advanced Filters")) {
                    HStack {
                        Text("Difficulty: \(filterDifficulty ?? 1)")
                        Slider(value: Binding(
                            get: { Double(filterDifficulty ?? 1) },
                            set: { filterDifficulty = Int($0) }
                        ), in: 1...5, step: 1)
                    }

                    TextField("Filter by Benefits", text: $filterBenefits)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    TextField("Filter by Precautions", text: $filterPrecautions)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    TextField("Filter by Level", text: $filterLevel)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            .navigationTitle("Filter Poses")
            .environmentObject(PoseData())
        }
    }
}
