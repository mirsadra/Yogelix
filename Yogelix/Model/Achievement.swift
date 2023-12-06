//  Achievement.swift
import Foundation
import SwiftUI

struct Achievement: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var progress: Double
    var color: Color
}


