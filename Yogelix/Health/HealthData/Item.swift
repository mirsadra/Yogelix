//  Item.swift
import SwiftUI

// Sample Data Model
struct Item: Identifiable {
    var id: UUID = .init()
    var color: Color
}
