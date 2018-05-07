//
//  ContactContainer+CoreDataProperties.swift
//  
//
//  Created by Akash Jindal on 02/05/18.
//
//

import Foundation
import CoreData


extension ContactContainer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactContainer> {
        return NSFetchRequest<ContactContainer>(entityName: "ContactContainer")
    }

    @NSManaged public var company: String?
    @NSManaged public var title: String?
    @NSManaged public var wizCardID: NSNumber?
    @NSManaged public var media: NSSet?

}

// MARK: Generated accessors for media
extension ContactContainer {

    @objc(addMediaObject:)
    @NSManaged public func addToMedia(_ value: Media)

    @objc(removeMediaObject:)
    @NSManaged public func removeFromMedia(_ value: Media)

    @objc(addMedia:)
    @NSManaged public func addToMedia(_ values: NSSet)

    @objc(removeMedia:)
    @NSManaged public func removeFromMedia(_ values: NSSet)

}
