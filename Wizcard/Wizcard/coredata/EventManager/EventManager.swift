//
//  EventManager.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class EventManager: BaseManager {
    static let eventManager = EventManager()
    
    func getEventForEventID(eventID : NSNumber, createIfNotExist : Bool ) -> Event{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let requestFormat : NSFetchRequest<Event> = Event.fetchRequest()
        requestFormat.predicate =   NSPredicate(format : "eventId == %@", eventID)
        requestFormat.returnsObjectsAsFaults = false
        var entity : Event!
        do {
            let fetchResults = try context.fetch(requestFormat)
            if !fetchResults.isEmpty{
                if fetchResults.count > 0{
                    entity = fetchResults[0]
                }else if createIfNotExist{
                    entity = getInstanceForStructure(tableStructure: .kTS_Event) as! Event
                }
            }else if createIfNotExist {
                entity = getInstanceForStructure(tableStructure: .kTS_Event) as! Event
            }
        } catch let error {
            print("error in finding",error)
        } // check if order is already exist
        return entity
    }
    
    
    func getAllocatedEventForEvent(eventID : NSNumber, isUnAssociate : Bool) -> Event{
        
        var event : Event!
        if isUnAssociate {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Event", in: context)
            event = NSManagedObject.init(entity: entity!, insertInto: nil) as! Event
        }else{
            event = getEventForEventID(eventID: eventID, createIfNotExist: true)
            
        }
        return event
    }
    
    
    func populateEventsFromServerNotif(eventJSON : JSON, createUnAssociate: Bool) -> [Event]{
        
        var eventArray = [Event]()
        if let jsonArray = eventJSON.array{
            if jsonArray.count > 0{
                for eventJSON in jsonArray{
                     eventArray.append(populateSingleEventFromServerNotif(eventJSON: eventJSON, createUnAssociate: createUnAssociate))
                }
            }
        }
        return eventArray
    }
    
    func populateSingleEventFromServerNotif(eventJSON : JSON, createUnAssociate: Bool) -> Event{
        
        let entity = getAllocatedEventForEvent(eventID: eventJSON[CommonKeys.id].number!, isUnAssociate: createUnAssociate)
        
        entity.eventId  =   eventJSON[CommonKeys.id].number
        entity.venue    =   eventJSON[EventsKeys.venue].string ?? ""
        entity.start    =   eventJSON[EventsKeys.start].string ?? ""
        entity.website  =   eventJSON[EventsKeys.website].string ?? ""
        entity.phone    =   eventJSON[CommonKeys.phone].string ?? ""
        entity.email    =   eventJSON[CommonKeys.email].string ?? ""
        entity.eventDescription =   eventJSON[CommonKeys.description_small].string ?? ""
        entity.user_state       =   eventJSON[EventsKeys.user_state].string ?? ""
        
        if eventJSON[CommonKeys.location].exists() {
            let location        =   eventJSON[CommonKeys.location]
            entity.lat          =   location[CommonKeys.lat].number
            entity.longitude    =   location[CommonKeys.lng].number
        }
        
        entity.address  =   eventJSON[EventsKeys.address].string ?? ""
        entity.created  =   eventJSON[EventsKeys.created].string ?? ""
        entity.name     =   eventJSON[EventsKeys.name].string ?? ""
        entity.end      =   eventJSON[EventsKeys.end].string ?? ""
        entity.joined   =   eventJSON[EventsKeys.joined].number
        
        if eventJSON[EventsKeys.like].exists() {
            let likeJSON        =   eventJSON[EventsKeys.like]
            entity.like_level   =   likeJSON[EventsKeys.like_level].number
            entity.liked        =   likeJSON[EventsKeys.liked].number
        }
        
        if eventJSON[ProfileKeys.media].exists(){
            let mediaFromWizcard = entity.mediaArray?.allObjects
            if mediaFromWizcard != nil {
                for item in mediaFromWizcard as! [Media]{
                    getManagedObjectContext().delete(item)
                }
            }
            
            entity.mediaArray = NSSet(array: MediaManager.mediaManager.populateMediaFromServerNotif(mediaJSONObject: eventJSON[ProfileKeys.media], createUnAssociate: createUnAssociate))
        }

        
        return entity
        
    }

}
