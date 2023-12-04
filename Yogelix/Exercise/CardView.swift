//  CardView.swift
import SwiftUI

struct CardView: View {
    let practices: DailyPractice
    
    var body: some View {
        
        ZStack {
            Image(practices.image)
                .resizable()
                .frame(width: 160, height: 90)
            VStack(alignment: .leading) {
                HStack {
                    Text(practices.title)
                        .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                    
                    Spacer()
                    
                    Label {
                        Text("\(practices.difficulty)")
                            .hidden()
                    }
                    icon: {
                        HStack(spacing: 2) {
                            if practices.difficulty == 3 {
                                Image(systemName: "gauge.with.dots.needle.33percent")
                                    .foregroundStyle(.green)
                            } else if practices.difficulty == 2 {
                                Image(systemName: "gauge.with.dots.needle.50percent")
                                    .foregroundStyle(.yellow)
                            } else {
                                Image(systemName: "gauge.with.dots.needle.67percent")
                                    .foregroundColor(.red)
                            }
                        }
                    }

                }
                .padding()
                
                Spacer()
                HStack {
                    Label {
                        Text("\(practices.goal)")
                    }
                    icon: {
                        Image(systemName: "sparkle")
                            .foregroundColor(.yellow) // Set the color you desire here
                    }
                        .labelStyle(.titleAndIcon)
                }
                .font(.footnote)
                .padding(.top, 50)
            }
            .padding()
        .foregroundColor(.black)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var practice = DailyPractice.dailyPractices[0]
    static var previews: some View {
        CardView(practices: practice)
            .previewLayout(.fixed(width: 400, height: 180))
            .presentationCornerRadius(16)
    }
}

