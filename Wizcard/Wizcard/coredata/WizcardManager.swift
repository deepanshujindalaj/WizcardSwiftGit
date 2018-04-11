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

class WizcardManager {
    
    static let wizcardManager = WizcardManager()
    func saveWizcard(wizcard : JSON){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let requestFormat : NSFetchRequest<Wizcard> = Wizcard.fetchRequest()
        requestFormat.predicate =   NSPredicate(format : "wizUserId == %@", wizcard[ProfileKeys.wizuser_id].string ?? "")
        requestFormat.returnsObjectsAsFaults = false
        do {
            let fetchResults = try context.fetch(requestFormat)
            if !fetchResults.isEmpty{
                return
            }
        } catch let error {
             print("error in finding",error)
        } // check if order is already exist
        
        
        let wizcardTable = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:context) as! Wizcard
        
        wizcardTable.userId     =   wizcard[ProfileKeys.user_id].string ?? ""
        wizcardTable.wizUserId  =   wizcard[ProfileKeys.wizuser_id].number
        wizcardTable.wizcard_id =   wizcard[ProfileKeys.wizcard_id].number
        
        wizcardTable.firstName  =   wizcard[ProfileKeys.first_name].string ?? ""
        wizcardTable.lastName   =   wizcard[ProfileKeys.last_name].string ?? ""
        wizcardTable.email      =   wizcard[ProfileKeys.email].string ?? ""
        wizcardTable.phone      =   wizcard[ProfileKeys.phone].string ?? ""
        
        if wizcard[ProfileKeys.isExistInRolodex].exists() {
            wizcardTable.isExistInRolodex = wizcard[ProfileKeys.isExistInRolodex].number
        }
        
        if wizcard[ProfileKeys.isAwaitingConfirmation].exists() {
            wizcardTable.isA = wizcard[ProfileKeys.isAwaitingConfirmation].number
        }
        
        
        do {
            try context.save()
            // print("saved")
        }
        catch let error as NSError
        {
               print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
