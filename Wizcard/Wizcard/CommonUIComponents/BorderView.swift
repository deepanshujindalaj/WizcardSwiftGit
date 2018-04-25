//
//  BorderView.swift
//  Wizcard
//
//  Created by Akash Jindal on 25/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class BorderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.borderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
        
    }
}
