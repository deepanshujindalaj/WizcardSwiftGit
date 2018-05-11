//
//  MediaManager.swift
//  Wizcard
//
//  Created by Akash Jindal on 12/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class MediaManager: BaseManager {
    
    static let mediaManager = MediaManager()

    func getAllocatedMediaUnAssociated(isUnAssociate : Bool) -> Media{
        var media : Media!
        if isUnAssociate {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Media", in: context)
            media = NSManagedObject.init(entity: entity!, insertInto: nil) as! Media
        }else{
            media = getInstanceForStructure(tableStructure: .kTS_Media) as! Media
        }
        return media
    }
    
    func populateMediaFromServerNotif(mediaJSONObject : JSON, createUnAssociate: Bool) -> Array<Media>{
         var array  = Array<Media>()
        
        if let mediaJsonArray = mediaJSONObject.array
        {
            for mediaJSON in mediaJsonArray{
                
                let media = getAllocatedMediaUnAssociated(isUnAssociate: createUnAssociate)
                media.mediaId           =   mediaJSON[CommonKeys.id].number
                media.media_element     =   mediaJSON[MediaKeys.media_element].string ?? ""
                media.media_iframe      =   mediaJSON[MediaKeys.media_iframe].string ?? ""
                media.media_type        =   mediaJSON[MediaKeys.media_type].string ?? ""
                media.media_sub_type    =   mediaJSON[MediaKeys.media_sub_type].string ?? ""
                array.append(media)
            }
        }
        
        return array
    }
}
