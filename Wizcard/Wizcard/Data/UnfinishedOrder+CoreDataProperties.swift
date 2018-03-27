//
//  UnfinishedOrder+CoreDataProperties.swift
//  
//
//  Created by TimerackMac1 on 25/01/18.
//
//

import Foundation
import CoreData


extension UnfinishedOrder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnfinishedOrder> {
        return NSFetchRequest<UnfinishedOrder>(entityName: "UnfinishedOrder")
    }

    @NSManaged public var beforeImages: [String]?
    @NSManaged public var loadingTime: Int32
    @NSManaged public var multiWOStatus: String?
    @NSManaged public var orderId: String?
    @NSManaged public var status: String?
    @NSManaged public var stop: Int16
    @NSManaged public var startTime: Double
    @NSManaged public var afterImages: [String]?

}
