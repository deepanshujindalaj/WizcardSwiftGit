//
//  WizcardManager.swift
//  Wizcard
//
//  Created by Akash Jindal on 09/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class WizcardManager : BaseManager {
    
    static let wizcardManager = WizcardManager()
    
    
    func getWizcardForWizUserId(wizUserID : NSNumber, createIfNotExist : Bool ) -> Wizcard{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let requestFormat : NSFetchRequest<Wizcard> = Wizcard.fetchRequest()
        requestFormat.predicate =   NSPredicate(format : "wizUserId == %@", wizUserID)
        requestFormat.returnsObjectsAsFaults = false
        var entity : Wizcard!
        do {
            let fetchResults = try context.fetch(requestFormat)
            if !fetchResults.isEmpty{
                if fetchResults.count > 0{
                    entity = fetchResults[0]
                }else if createIfNotExist{
                    entity = getInstanceForStructure(tableStructure: .kTS_Wizcard) as! Wizcard
                }
            }else if createIfNotExist {
                entity = getInstanceForStructure(tableStructure: .kTS_Wizcard) as! Wizcard
            }
        } catch let error {
            print("error in finding",error)
        } // check if order is already exist
        return entity
    }
    

    
    
    func getAllocatedWizcardForWizUserID(wizUserID : NSNumber, isUnAssociate : Bool) -> Wizcard{
        
         var wizcard : Wizcard!
        if isUnAssociate {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Wizcard", in: context)
            wizcard = NSManagedObject.init(entity: entity!, insertInto: nil) as! Wizcard
        }else{
           wizcard = getWizcardForWizUserId(wizUserID: wizUserID, createIfNotExist: true)
        }
        return wizcard
    }

    
    
    
    func populateWizcardFromServerNotif(wizcard : JSON, createUnAssociate: Bool){

        
        let entity = getAllocatedWizcardForWizUserID(wizUserID: wizcard[ProfileKeys.wizuser_id].number!, isUnAssociate: createUnAssociate)
        
        
        entity.userId     =   wizcard[ProfileKeys.user_id].string ?? ""
        entity.wizUserId  =   wizcard[ProfileKeys.wizuser_id].number
        entity.wizcard_id =   wizcard[ProfileKeys.wizcard_id].number
        
        entity.firstName  =   wizcard[ProfileKeys.first_name].string ?? ""
        entity.lastName   =   wizcard[ProfileKeys.last_name].string ?? ""
        entity.email      =   wizcard[ProfileKeys.email].string ?? ""
        entity.phone      =   wizcard[ProfileKeys.phone].string ?? ""
        
        if wizcard[ProfileKeys.isExistInRolodex].exists() {
            entity.isExistInRolodex = wizcard[ProfileKeys.isExistInRolodex].number
        }
        
        if wizcard[ProfileKeys.user_state].exists() {
            entity.user_state = wizcard[ProfileKeys.user_state].string ?? ""
        }
        
        if wizcard[ProfileKeys.Description].exists() {
            entity.descriptionText = wizcard[ProfileKeys.Description].string ?? ""
        }
        
        if wizcard[ProfileKeys.videoUrl].exists() {
            entity.videoURL =   wizcard[ProfileKeys.videoUrl].string ?? ""
        }
        
        if wizcard[ProfileKeys.videoThumbnailUrl].exists(){
            entity.videoThumbnailURL = wizcard[ProfileKeys.videoThumbnailUrl].string ?? ""
        }
        
        
        
        entity.contactContainers =  NSSet(array : populateContactContainer(wizcard: entity, contactContainer: wizcard[ProfileKeys.contact_container], createdUnAssociate: createUnAssociate))
        
        if wizcard[ProfileKeys.media].exists(){
            entity.media = NSSet(array: MediaManager.mediaManager.populateMediaFromServerNotif(wizcard: entity, mediaJSONObject: wizcard[ProfileKeys.media], createUnAssociate: createUnAssociate))
        }

        if wizcard[ProfileKeys.ext_fields].exists() {
            entity.extfields = NSSet(array : ExtFieldManager.extFieldManager.populateExtFieldsFromServerNotif(wizcard: entity, extFieldsJSONObject: wizcard[ProfileKeys.ext_fields], createUnAssociate: createUnAssociate))
            
        }
    }
    
    func populateContactContainer(wizcard: Wizcard, contactContainer : JSON, createdUnAssociate: Bool) -> Array<ContactContainer>{
        var contactContainerArrayLocal = Array<ContactContainer>()
        
        
        let contactConatinerFromWizcard = wizcard.contactContainers?.allObjects
        if contactConatinerFromWizcard != nil {
            for item in contactConatinerFromWizcard as! [Media]{
                getManagedObjectContext().delete(item)
            }
        }
        
        if let contactContainerArray = contactContainer.array
        {
            for item in contactContainerArray{
                let contactContainerObject  = getAllocatedContactContainerUnAssociated(isUnAssociate: createdUnAssociate)
                contactContainerObject.company = item[ContactContainerKeys.company].string ?? ""
                contactContainerObject.title = item[ContactContainerKeys.title].string ?? ""
                
                contactContainerArrayLocal.append(contactContainerObject)
            }
        }
        return contactContainerArrayLocal
    }
    
    func getAllocatedContactContainerUnAssociated(isUnAssociate : Bool) -> ContactContainer{
        var contactContainer : ContactContainer!
        if isUnAssociate {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ContactContainer", in: context)
            contactContainer = NSManagedObject.init(entity: entity!, insertInto: nil) as! ContactContainer
        }else{
            contactContainer = getInstanceForStructure(tableStructure: .kTS_ContactContainer) as! ContactContainer
        }
        return contactContainer
    }
   
}
