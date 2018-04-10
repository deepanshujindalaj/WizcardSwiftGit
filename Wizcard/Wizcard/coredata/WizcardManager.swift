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
        
        let requestFormat : NSFetchRequest<Wizcard> = Wizcard.fetchRequest() as! NSFetchRequest<Wizcard>
        requestFormat.predicate =   NSPredicate(format : "orderId == %@", wizcard.wizuser_id)
        requestFormat.returnsObjectsAsFaults = false
        do {
            let fetchResults = try context.fetch(requestFormat)
            if !fetchResults.isEmpty{
                return
            }
        } catch let error {
             print("error in finding",error)
        } // check if order is already exist
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Wizcard", into:context) as! Wizcard
        entity.first_name = wizcard.first_name
        
        do {
            try context.save()
            // print("saved")
        }
        catch let error as NSError
        {
            //   print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
