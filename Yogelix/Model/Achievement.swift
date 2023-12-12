//  Achievement.swift
import Foundation

struct Achievement: Codable, Identifiable {
    var id: String // "gold", "silver", or "bronze"
    var count: Int // The number of achievements of this type

    enum CodingKeys: String, CodingKey {
        case id
        case count
    }
}
