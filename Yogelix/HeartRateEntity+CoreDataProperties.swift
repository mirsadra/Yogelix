//
//  HeartRateEntity+CoreDataProperties.swift
//  Yogelix
//
//  Created by Mirsadra on 03/12/2023.
//
//

import Foundation
import CoreData


extension HeartRateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HeartRateEntity> {
        return NSFetchRequest<HeartRateEntity>(entityName: "HeartRateEntity")
    }

    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var identifier: String?
    @NSManaged public var duration: Double
    @NSManaged public var min: Double
    @NSManaged public var max: Double
    @NSManaged public var average: Double
    @NSManaged public var source: String?

}

extension HeartRateEntity : Identifiable {

}
