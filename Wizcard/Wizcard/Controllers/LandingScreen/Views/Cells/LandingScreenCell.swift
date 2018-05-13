//
//  LandingScreenCell.swift
//  Wizcard
//
//  Created by Akash Jindal on 13/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class LandingScreenCell: UICollectionViewCell {
    
    @IBOutlet weak var eventImageViewOutlet: UIImageView!
    @IBOutlet weak var eventNameLblOutlet: UILabel!
    @IBOutlet weak var eventVenueLblOutlet: UILabel!
    
    @IBOutlet weak var eventDateLblOutlet: UILabel!
    
    @IBOutlet weak var pinEventButtonOutlet: UIButton!
    
    func populateCollectionCellData(event : Event){
        
        eventNameLblOutlet.text     =   event.name
        eventVenueLblOutlet.text    =   event.venue
        let media = HelperFunction.getLGOMedia(arrayList: event.mediaArray?.allObjects as? [Media])
        if media != nil {
            if  let url = URL(string : (media?.media_element)!) {
                eventImageViewOutlet.af_setImage(withURL: url)
            }
        }
        else{
            eventImageViewOutlet.image = #imageLiteral(resourceName: "event_placeholder")
        }

        let startDate   =   HelperFunction.getStartMonthDate(dateString: event.start!)
        let endDate     =   HelperFunction.getEndDateAndYear(dateString: event.end!)
        
        eventDateLblOutlet.text = "\(startDate)- \(endDate)"

        
    }
    
}
