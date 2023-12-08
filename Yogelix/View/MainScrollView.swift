// MainScrollView.swift
import SwiftUI

struct MainScrollView: View {
    @EnvironmentObject var modelData : ModelData

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(modelData.uniqueChakras, id: \.id) { chakraDetail in
                    ChakraDetailView(chakraDetail: chakraDetail)
                }
            }
            .padding(.horizontal)
        }
    }
}

// Preview
struct MainScrollView_Previews: PreviewProvider {
    static var previews: some View {
        MainScrollView()
            .environmentObject(ModelData())
    }
}
