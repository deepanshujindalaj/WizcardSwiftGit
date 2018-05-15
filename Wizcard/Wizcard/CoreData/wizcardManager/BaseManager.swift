//
//  BaseManager.swift
//  Wizcard
//
//  Created by Akash Jindal on 11/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import CoreData

class BaseManager {
    
     static let baseManager = BaseManager()

    func getManagedObjectContext() -> NSManagedObjectContext{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return context
    }
    
    func getInstanceForStructure(tableStructure : TableStructure) -> NSManagedObject{
        let entity : NSManagedObject
        switch tableStructure {
            case .kTS_Wizcard:
                entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard

            case .kTS_Attendees:
                entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
            case .kTS_Preset:
                entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
            case .kTS_ContactContainer:
                entity = NSEntityDescription.insertNewObject(forEntityName: "ContactContainer", into:getManagedObjectContext()) as! ContactContainer
        case .kTS_Settings:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
        case .kTS_CreatedTable:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
        case .kTS_Notifications:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
        case .kTS_FlickedCard:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
        case .kTS_ExtField:
            entity = NSEntityDescription.insertNewObject(forEntityName: "ExtFields", into:getManagedObjectContext()) as! ExtFields
        case .kTS_Event:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Event", into:getManagedObjectContext()) as! Event
        case .kTS_Campaign:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
        case .kTS_Media:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Media", into:getManagedObjectContext()) as! Media
        case .kTS_Speaker:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
        case .kTS_Setting:
            entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:getManagedObjectContext()) as! Wizcard
        }
        
        return entity
    }
    
    func saveContext(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
            // print("saved")
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveUnAssociatedObject(object : NSManagedObject){
        if getManagedObjectContext().registeredObject(for: object.objectID) == nil{
            getManagedObjectContext().insert(object)
            do{
                try getManagedObjectContext().save()
            }
            catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteObject(object : NSManagedObject){
        if getManagedObjectContext().registeredObject(for: object.objectID) != nil{
            getManagedObjectContext().delete(object)
            do{
                try getManagedObjectContext().save()
            }
            catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
}
