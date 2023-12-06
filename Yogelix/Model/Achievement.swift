//  Achievement.swift
import Foundation
import SwiftUI

struct Achievement: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var poseName: String
    var progress: Double
    var trophy: TrophyType
    var color: Color
}


