//
//  ContactContainer+CoreDataProperties.swift
//  
//
//  Created by Akash Jindal on 10/04/18.
//
//

import Foundation
import CoreData


extension ContactContainer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactContainer> {
        return NSFetchRequest<ContactContainer>(entityName: "ContactContainer")
    }

    @NSManaged public var cardImageLocalFilePath: String?
    @NSManaged public var company: String?
    @NSManaged public var curCardImageAwsURL: String?
    @NSManaged public var f_bizCardImage: String?
    @NSManaged public var prevCardImageAwsURL: String?
    @NSManaged public var title: String?
    @NSManaged public var wizCardID: NSNumber?
    @NSManaged public var wizcard: Wizcard?

}
