//  AsanasExplorerViewModel.swift
import Foundation
import Combine

class AsanasExplorerViewModel: ObservableObject {
//    @Published var asanas: [Asana] = []?
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"

    private var cancellables: Set<AnyCancellable> = []
    


    init() {
        loadAsanas()

        // Setup search and filter functionality
        $searchText
            .combineLatest($selectedCategory)
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] searchText, category in
                self?.filterAsanas(searchText: searchText, category: category)
            }
            .store(in: &cancellables)
    }

    func loadAsanas() {
        
    }

    private func filterAsanas(searchText: String, category: String) {
        // Reset to all asanas if search text and category are default
        if searchText.isEmpty && category == "All" {
            loadAsanas()
            return
        }

    }

}

