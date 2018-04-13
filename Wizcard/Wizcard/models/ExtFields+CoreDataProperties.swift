//
//  ExtFields+CoreDataProperties.swift
//  
//
//  Created by Akash Jindal on 13/04/18.
//
//

import Foundation
import CoreData


extension ExtFields {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExtFields> {
        return NSFetchRequest<ExtFields>(entityName: "ExtFields")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: String?
    @NSManaged public var wizcard_id: NSNumber?
    @NSManaged public var wizcard: Wizcard?

}
