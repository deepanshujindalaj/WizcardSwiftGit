//
//  SocialMediaView.swift
//  Wizcard
//
//  Created by Akash Jindal on 09/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

@IBDesignable class SocialMediaView: UIView {

    var wizcard : Wizcard!
    var contentView : UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var facebookParent: UIView!
    @IBOutlet weak var twitterParent: UIView!
    @IBOutlet weak var linkedInParent: UIView!
    
    @IBOutlet weak var linkedInWidthContraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var twitterWidthContraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var facebookWidthConstraintOutlet: NSLayoutConstraint!
    
    var filteredArrayTwitter = Array<ExtFields>()
    var filteredArrayFacebook = Array<ExtFields>()
    var filteredArrayLinkedInArray = Array<ExtFields>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayout()
    }
    
    private func setUpLayout()
    {
//        contentView = Bundle.main.loadNibNamed("SocialMediaView", owner: self, options:nil)?.first as! UIView
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
        
    }
    
    func updateExtFields(){
        let extFields           =   wizcard.extfields?.allObjects as! [ExtFields]
        
        filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }
        
        if filteredArrayLinkedInArray.count > 0{
            linkedInParent.isHidden = false
            linkedInWidthContraintOutlet.constant = 30
        }else{
            linkedInWidthContraintOutlet.constant = 0
            linkedInParent.isHidden = true
        }
        
        filteredArrayFacebook   =   extFields.filter() { $0.key == SocialMedia.FACEBOOK }
        if filteredArrayFacebook.count > 0{
            facebookParent.isHidden = false
            facebookWidthConstraintOutlet.constant = 30
        }else{
            facebookParent.isHidden = true
            facebookWidthConstraintOutlet.constant = 0
        }
        
        filteredArrayTwitter   =   extFields.filter() { $0.key == SocialMedia.TWITTER }
        if filteredArrayTwitter.count > 0{
            twitterParent.isHidden = false
            twitterWidthContraintOutlet.constant = 30
        }else{
            twitterParent.isHidden = true
            twitterWidthContraintOutlet.constant = 0
        }
        
    }
    @IBAction func twitterButtonClicked(_ sender: Any) {
        let urlString = filteredArrayTwitter[0].value
        guard let url = URL(string: urlString!) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func linkedInButtonClicked(_ sender: Any) {
        
        let urlString = filteredArrayLinkedInArray[0].value
        
        guard let url = URL(string: urlString!) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func facebookButtonClicked(_ sender: Any) {
        let urlString = filteredArrayFacebook[0].value
        guard let url = URL(string: urlString!) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
