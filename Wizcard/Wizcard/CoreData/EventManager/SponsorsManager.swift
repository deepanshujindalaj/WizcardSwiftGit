//
//  SponsorsManager.swift
//  Wizcard
//
//  Created by Akash Jindal on 20/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData


class SponsorsManager: BaseManager {

    static let sponsorsManager = SponsorsManager()

    func getSponsorsForSponsorID() -> Sponsors{
        
        var entity : Sponsors!
        
        entity = getInstanceForStructure(tableStructure: .kTS_Sponsor) as! Sponsors
        
        return entity
    }
    
    
    
    func getAllocatedSponsor(eventID : NSNumber, isUnAssociate : Bool) -> Sponsors{
        
        var event : Sponsors!
        if isUnAssociate {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Sponsors", in: context)
            event = NSManagedObject.init(entity: entity!, insertInto: nil) as! Sponsors
        }else{
            event = getSponsorsForSponsorID()
        }
        return event
    }
    
    func populateSingleSponsorsFromServerNotif(eventJSON : JSON, createUnAssociate: Bool) -> Sponsors{
        
        let entity = getAllocatedSponsor(eventID: eventJSON[CommonKeys.id].number!, isUnAssociate: createUnAssociate)
        
        entity.sponsorsID   =   eventJSON[CommonKeys.id].number
        entity.name         =   eventJSON[EventsKeys.name].string ?? ""
        entity.email        =   eventJSON[CommonKeys.email].string ?? ""
        entity.entityType   =   eventJSON[EventsKeys.entity_type].string ?? ""
        
        if eventJSON[ProfileKeys.media].exists(){
            let mediaFromWizcard = entity.mediaArray?.allObjects
            if mediaFromWizcard != nil {
                for item in mediaFromWizcard as! [Media]{
                    getManagedObjectContext().delete(item)
                }
            }
            
            entity.mediaArray = NSSet(array: MediaManager.mediaManager.populateMediaFromServerNotif(mediaJSONObject:
                eventJSON[ProfileKeys.media], createUnAssociate: createUnAssociate))
        }
        
        
//        entity.user_state   =   eventJSON[EventsKeys.user_state].string ?? ""
//        entity.venue    =   eventJSON[EventsKeys.venue].string ?? ""
//        entity.start    =   eventJSON[EventsKeys.start].string ?? ""
//        entity.website  =   eventJSON[EventsKeys.website].string ?? ""
//        entity.phone    =   eventJSON[CommonKeys.phone].string ?? ""

//        entity.eventDescription =   eventJSON[CommonKeys.description_small].string ?? ""

//
//        if eventJSON[CommonKeys.location].exists() {
//            let location        =   eventJSON[CommonKeys.location]
//            entity.lat          =   location[CommonKeys.lat].number
//            entity.longitude    =   location[CommonKeys.lng].number
//        }
//
//        entity.address  =   eventJSON[EventsKeys.address].string ?? ""
//        entity.created  =   eventJSON[EventsKeys.created].string ?? ""
//        entity.end      =   eventJSON[EventsKeys.end].string ?? ""
//        entity.joined   =   eventJSON[EventsKeys.joined].number
//
//        if eventJSON[EventsKeys.like].exists() {
//            let likeJSON        =   eventJSON[EventsKeys.like]
//            entity.like_level   =   likeJSON[EventsKeys.like_level].number
//            entity.liked        =   likeJSON[EventsKeys.liked].number
//        }
        
        
        
        
        return entity
        
    }
    
}

