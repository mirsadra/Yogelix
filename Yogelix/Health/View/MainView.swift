//  MainView.swift
import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: QuantityDataViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Section(header: Text("Last Week's Heart Rate").font(.headline)) {

                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline) // Makes the title less prominent
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Heart Rate Statistics").font(.title2) // Custom font for the title
                }
            }
            .onAppear {
                viewModel.fetchLastWeekHeartRate()
            }
        }
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: QuantityDataViewModel())
    }
}
