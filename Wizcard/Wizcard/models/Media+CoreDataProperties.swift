//
//  Media+CoreDataProperties.swift
//  
//
//  Created by Akash Jindal on 10/04/18.
//
//

import Foundation
import CoreData


extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var media_element: String?
    @NSManaged public var media_iframe: String?
    @NSManaged public var media_sub_type: String?
    @NSManaged public var media_type: String?
    @NSManaged public var mediaId: NSNumber?

}
