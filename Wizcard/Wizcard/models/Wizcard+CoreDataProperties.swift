//
//  Wizcard+CoreDataProperties.swift
//  
//
//  Created by Akash Jindal on 12/04/18.
//
//

import Foundation
import CoreData


extension Wizcard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wizcard> {
        return NSFetchRequest<Wizcard>(entityName: "Wizcard")
    }

    @NSManaged public var admin: NSNumber?
    @NSManaged public var descriptionText: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var isDeadCard: NSNumber?
    @NSManaged public var isExistInRolodex: NSNumber?
    @NSManaged public var isInvited: NSNumber?
    @NSManaged public var isLinkedInAccount: NSNumber?
    @NSManaged public var lastName: String?
    @NSManaged public var lastSaved: String?
    @NSManaged public var location: String?
    @NSManaged public var notes: String?
    @NSManaged public var phone: String?
    @NSManaged public var rolodexState: NSNumber?
    @NSManaged public var status: String?
    @NSManaged public var timeStamp: String?
    @NSManaged public var user_state: String?
    @NSManaged public var userId: String?
    @NSManaged public var videoThumbnailURL: String?
    @NSManaged public var videoURL: String?
    @NSManaged public var wizcard_id: NSNumber?
    @NSManaged public var wizUserId: NSNumber?
    @NSManaged public var contactContainers: NSSet?
    @NSManaged public var extfields: NSSet?
    @NSManaged public var flickedCards: NSSet?
    @NSManaged public var media: NSSet?

}

// MARK: Generated accessors for contactContainers
extension Wizcard {

    @objc(addContactContainersObject:)
    @NSManaged public func addToContactContainers(_ value: ContactContainer)

    @objc(removeContactContainersObject:)
    @NSManaged public func removeFromContactContainers(_ value: ContactContainer)

    @objc(addContactContainers:)
    @NSManaged public func addToContactContainers(_ values: NSSet)

    @objc(removeContactContainers:)
    @NSManaged public func removeFromContactContainers(_ values: NSSet)

}

// MARK: Generated accessors for extfields
extension Wizcard {

    @objc(addExtfieldsObject:)
    @NSManaged public func addToExtfields(_ value: NSManagedObject)

    @objc(removeExtfieldsObject:)
    @NSManaged public func removeFromExtfields(_ value: NSManagedObject)

    @objc(addExtfields:)
    @NSManaged public func addToExtfields(_ values: NSSet)

    @objc(removeExtfields:)
    @NSManaged public func removeFromExtfields(_ values: NSSet)

}

// MARK: Generated accessors for flickedCards
extension Wizcard {

    @objc(addFlickedCardsObject:)
    @NSManaged public func addToFlickedCards(_ value: NSManagedObject)

    @objc(removeFlickedCardsObject:)
    @NSManaged public func removeFromFlickedCards(_ value: NSManagedObject)

    @objc(addFlickedCards:)
    @NSManaged public func addToFlickedCards(_ values: NSSet)

    @objc(removeFlickedCards:)
    @NSManaged public func removeFromFlickedCards(_ values: NSSet)

}

// MARK: Generated accessors for media
extension Wizcard {

    @objc(addMediaObject:)
    @NSManaged public func addToMedia(_ value: Media)

    @objc(removeMediaObject:)
    @NSManaged public func removeFromMedia(_ value: Media)

    @objc(addMedia:)
    @NSManaged public func addToMedia(_ values: NSSet)

    @objc(removeMedia:)
    @NSManaged public func removeFromMedia(_ values: NSSet)

}
