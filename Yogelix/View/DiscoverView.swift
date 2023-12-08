//  DiscoverView.swift
import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationSplitView {
            List {
                ScrollView(.horizontal) {
                    NavigationLink {
                        
                        Text("😵‍")
                            .navigationTitle("Destination is Here")
                    } label: {
                        HStack {
                            Text("Tap to Navigate")
                            Spacer()
                            Image(systemName: "arrow.forward.circle")
                                .font(.largeTitle)
                        }
                        .frame(width: 6, height: 44)
                    }
                    
                }
            }
            
        } detail: {
            Text("Select")
        }
    }
}

#Preview {
    DiscoverView()
        .environmentObject(ModelData())
}
