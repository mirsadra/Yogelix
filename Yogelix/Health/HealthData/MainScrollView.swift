//
//  MainScrollView.swift
//  Yogelix
//
//  Created by Mirsadra on 28/11/2023.
//

import SwiftUI

struct MainScrollView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("MainScroll View")
        }
    }
}

#Preview {
    MainScrollView()
}
