//
//  UserTableViewCell.swift
//  Wizcard
//
//  Created by Akash Jindal on 21/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: RoundableUIImageView!
    @IBOutlet weak var firstAndLastName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var company: UILabel!
    
    var wizcardLocal : Wizcard!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateWizcardData(wizcard : Wizcard){
        wizcardLocal = wizcard
        CommonFunction.showProfileImage(profilePicOutlet: userImage, firstandLastNameLblOutlet: firstAndLastName, titleLblOutlet: title, destination: company, wizcard: wizcardLocal)
    }
}
