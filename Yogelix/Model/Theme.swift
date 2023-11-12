//  Theme.swift
import SwiftUI

enum Theme: String {
    case sereneGreen
    case calmingBlue
    case peacefulPurple
    case meditationMaroon
    case zenYellow
    case mindfulnessMint
    case tranquilTeal
    case balanceBeige
    case harmonyGray
    case energyOrange

    var accentColor: Color {
        // Define the accent color based on the main color's brightness
        switch self {
        case .sereneGreen, .calmingBlue, .peacefulPurple, .meditationMaroon, .zenYellow:
            return .white // Light themes with dark accent
        case .mindfulnessMint, .tranquilTeal, .balanceBeige, .harmonyGray, .energyOrange:
            return .black // Dark themes with light accent
        }
    }
    
    var mainColor: Color {
        Color(rawValue)
    }
    
    // MARK: - belongs to "Label("Theme", systemImage: "paintpalette")" part in `DetailsView.swift`
    var name: String {
        rawValue.capitalized
    }
}


