//
//  RoundableButton.swift
//  DreamRay
//
//  Created by TimerackMac1 on 22/09/17.
//  Copyright © 2017 TimerackMac1. All rights reserved.
//


import UIKit
@IBDesignable class RoundableButton: UIButton {
    private var _round = false
    private var _isDropShadow = false
    private var _borderColor = UIColor.clear
    @IBInspectable var borderColor: UIColor {
        set {
            _borderColor = newValue
            makeRound()
        }
        get {
            return self._borderColor
        }
    }
    
    @IBInspectable var round: Bool {
        set {
            _round = newValue
            makeRound()
        }
        get {
            return self._round
        }
    }
    
    @IBInspectable var isDropShadow: Bool {
        set {
            _isDropShadow = newValue
            makeRound()
        }
        get {
            return self._isDropShadow
        }
    }
    
    private func makeRound() {
        if self.round == true {
            self.layer.cornerRadius = 7//( self.frame.height) / 2
            self.layer.borderColor = _borderColor.cgColor
            self.layer.borderWidth = 1
        } else {
            self.layer.cornerRadius = 0
        }
        if self.isDropShadow{
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 1,height:1);
            layer.shadowRadius = 5
            layer.shadowOpacity = 0.5
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRound()
    }
}
