//
//  Sponsors+CoreDataProperties.swift
//  
//
//  Created by Akash Jindal on 20/05/18.
//
//

import Foundation
import CoreData


extension Sponsors {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sponsors> {
        return NSFetchRequest<Sponsors>(entityName: "Sponsors")
    }

    @NSManaged public var caption: String?
    @NSManaged public var created: String?
    @NSManaged public var email: String?
    @NSManaged public var entityType: String?
    @NSManaged public var modified: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var polymorphic_ctype: NSNumber?
    @NSManaged public var sponsoredDescription: String?
    @NSManaged public var sponsorsID: NSNumber?
    @NSManaged public var state: NSNumber?
    @NSManaged public var vcard: String?
    @NSManaged public var website: String?
    @NSManaged public var extFields: NSSet?
    @NSManaged public var mediaArray: NSSet?

}

// MARK: Generated accessors for extFields
extension Sponsors {

    @objc(addExtFieldsObject:)
    @NSManaged public func addToExtFields(_ value: ExtFields)

    @objc(removeExtFieldsObject:)
    @NSManaged public func removeFromExtFields(_ value: ExtFields)

    @objc(addExtFields:)
    @NSManaged public func addToExtFields(_ values: NSSet)

    @objc(removeExtFields:)
    @NSManaged public func removeFromExtFields(_ values: NSSet)

}

// MARK: Generated accessors for mediaArray
extension Sponsors {

    @objc(addMediaArrayObject:)
    @NSManaged public func addToMediaArray(_ value: Media)

    @objc(removeMediaArrayObject:)
    @NSManaged public func removeFromMediaArray(_ value: Media)

    @objc(addMediaArray:)
    @NSManaged public func addToMediaArray(_ values: NSSet)

    @objc(removeMediaArray:)
    @NSManaged public func removeFromMediaArray(_ values: NSSet)

}
