//
//  SponsoredCollectionViewCell.swift
//  Wizcard
//
//  Created by Akash Jindal on 20/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class SponsoredCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: RoundableUIImageView!
    func populateCollectionCellData(sponsors : Sponsors){
        if sponsors.mediaArray?.allObjects.count != 0{
            let media = sponsors.mediaArray?.allObjects[0] as! Media
            if let url = URL(string : media.media_element!){
                imageView.af_setImage(withURL: url)
            }
        }
    }
}
