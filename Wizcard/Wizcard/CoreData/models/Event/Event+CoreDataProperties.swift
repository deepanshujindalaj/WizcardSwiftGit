//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Akash Jindal on 20/05/18.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var address: String?
    @NSManaged public var attendeeCount: NSNumber?
    @NSManaged public var created: String?
    @NSManaged public var email: String?
    @NSManaged public var end: String?
    @NSManaged public var entity_type: String?
    @NSManaged public var eventDescription: String?
    @NSManaged public var eventId: NSNumber?
    @NSManaged public var friendsCount: NSNumber?
    @NSManaged public var is_detailed_saved: NSNumber?
    @NSManaged public var joined: NSNumber?
    @NSManaged public var lat: NSNumber?
    @NSManaged public var like_level: NSNumber?
    @NSManaged public var liked: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var start: String?
    @NSManaged public var state: NSNumber?
    @NSManaged public var timestamp: String?
    @NSManaged public var user_state: String?
    @NSManaged public var venue: String?
    @NSManaged public var website: String?
    @NSManaged public var campaignArray: NSSet?
    @NSManaged public var eventusers: NSSet?
    @NSManaged public var mediaArray: NSSet?
    @NSManaged public var speakerArray: NSSet?
    @NSManaged public var sponsors: NSSet?

}

// MARK: Generated accessors for campaignArray
extension Event {

    @objc(addCampaignArrayObject:)
    @NSManaged public func addToCampaignArray(_ value: NSManagedObject)

    @objc(removeCampaignArrayObject:)
    @NSManaged public func removeFromCampaignArray(_ value: NSManagedObject)

    @objc(addCampaignArray:)
    @NSManaged public func addToCampaignArray(_ values: NSSet)

    @objc(removeCampaignArray:)
    @NSManaged public func removeFromCampaignArray(_ values: NSSet)

}

// MARK: Generated accessors for eventusers
extension Event {

    @objc(addEventusersObject:)
    @NSManaged public func addToEventusers(_ value: Wizcard)

    @objc(removeEventusersObject:)
    @NSManaged public func removeFromEventusers(_ value: Wizcard)

    @objc(addEventusers:)
    @NSManaged public func addToEventusers(_ values: NSSet)

    @objc(removeEventusers:)
    @NSManaged public func removeFromEventusers(_ values: NSSet)

}

// MARK: Generated accessors for mediaArray
extension Event {

    @objc(addMediaArrayObject:)
    @NSManaged public func addToMediaArray(_ value: Media)

    @objc(removeMediaArrayObject:)
    @NSManaged public func removeFromMediaArray(_ value: Media)

    @objc(addMediaArray:)
    @NSManaged public func addToMediaArray(_ values: NSSet)

    @objc(removeMediaArray:)
    @NSManaged public func removeFromMediaArray(_ values: NSSet)

}

// MARK: Generated accessors for speakerArray
extension Event {

    @objc(addSpeakerArrayObject:)
    @NSManaged public func addToSpeakerArray(_ value: NSManagedObject)

    @objc(removeSpeakerArrayObject:)
    @NSManaged public func removeFromSpeakerArray(_ value: NSManagedObject)

    @objc(addSpeakerArray:)
    @NSManaged public func addToSpeakerArray(_ values: NSSet)

    @objc(removeSpeakerArray:)
    @NSManaged public func removeFromSpeakerArray(_ values: NSSet)

}

// MARK: Generated accessors for sponsors
extension Event {

    @objc(addSponsorsObject:)
    @NSManaged public func addToSponsors(_ value: Sponsors)

    @objc(removeSponsorsObject:)
    @NSManaged public func removeFromSponsors(_ value: Sponsors)

    @objc(addSponsors:)
    @NSManaged public func addToSponsors(_ values: NSSet)

    @objc(removeSponsors:)
    @NSManaged public func removeFromSponsors(_ values: NSSet)

}
