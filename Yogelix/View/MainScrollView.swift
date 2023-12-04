// MainScrollView.swift
import SwiftUI

struct MainScrollView: View {
    @ObservedObject var modelData = ModelData()

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
    }
}


/*
 //
 ZStack() {
   Rectangle()
     .foregroundColor(.clear)
     .frame(width: 393, height: 190)
     .background(
       LinearGradient(gradient: Gradient(colors: [Color(red: 0, green: 0.15, blue: 0.25), Color(red: 0, green: 0.44, blue: 0.65), Color(red: 0, green: 0.16, blue: 0.28)]), startPoint: .leading, endPoint: .trailing)
     )
     .offset(x: 0.92, y: 3)
 }
 .frame(width: 347.16, height: 160)
 */
