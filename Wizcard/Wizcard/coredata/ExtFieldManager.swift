//
//  ExtFieldManager.swift
//  Wizcard
//
//  Created by Akash Jindal on 13/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ExtFieldManager: BaseManager {
    static let extFieldManager = ExtFieldManager()
    

    func getAllocatedExtFieldsUnAssociated(isUnAssociate : Bool) -> ExtFields{
        var extFields : ExtFields!
        if isUnAssociate {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "ExtFields", in: context)
            extFields = NSManagedObject.init(entity: entity!, insertInto: nil) as! ExtFields
        }else{
            extFields = getInstanceForStructure(tableStructure: .kTS_ExtField) as! ExtFields
        }
        return extFields
    }
    
    func populateExtFieldsFromServerNotif(wizcard: Wizcard, extFieldsJSONObject : JSON, createUnAssociate: Bool) -> Array<ExtFields>{
        var array  = Array<ExtFields>()
    
        
        for (key, subJson) in extFieldsJSONObject {
            let extField = getAllocatedExtFieldsUnAssociated(isUnAssociate: createUnAssociate)
            extField.value           =   subJson.string ?? ""
            extField.key             =   key
            array.append(extField)
        }
    
        
        return array
    }
    
}
