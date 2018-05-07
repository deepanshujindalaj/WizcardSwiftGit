//
//  CornerRadiousAndShadowView.swift
//  Wizcard
//
//  Created by Akash Jindal on 07/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class CornerRadiousAndShadowView: UIView {

    private var _borderWidth  :  CGFloat = 0
    private var _borderColor = UIColor.clear
    private var _cornerRadius : CGFloat = 0
    private var _shadowRadious : CGFloat = 0
    private var _shadowOpacity : Float = 0.0
    
    @IBInspectable var borderColor : UIColor{
        set {
            _borderColor = newValue
//            makeRound()
        }
        get {
            return self._borderColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat{
        set {
            _borderWidth = newValue
        }
        get {
            return self._borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat{
        set {
            _cornerRadius = newValue
        }
        get {
            return self._cornerRadius
        }
    }
    
    @IBInspectable var shadowOpacity : Float{
        set {
            _shadowOpacity = newValue
        }
        get {
            return self._shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadious : CGFloat{
        set {
            _shadowRadious = newValue
        }
        get {
            return self._shadowRadious
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth      = self.borderWidth;
        self.layer.borderColor      = self.borderColor.cgColor
        
        self.layer.cornerRadius     = self.cornerRadius
        self.layer.shadowColor      = self.borderColor.cgColor
        self.layer.shadowOpacity    = self.shadowOpacity
        self.layer.shadowRadius     = self.shadowRadious
        self.layer.shadowOffset     = CGSize(width: -1, height: 1)
        
    }
    
}
