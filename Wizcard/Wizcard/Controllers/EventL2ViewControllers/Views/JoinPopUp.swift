//
//  JoinPopUp.swift
//  Wizcard
//
//  Created by Akash Jindal on 16/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

protocol JoinPopUpDelegate{
    func joinButtonClicked()
    func dismissButtonClicked()
}
class JoinPopUp: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate : JoinPopUpDelegate!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("JoinPopUp", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    @IBAction func joinButtonClicked(_ sender: Any) {
        delegate.joinButtonClicked()
    }
    
    @IBAction func dismissButtonClicked(_ sender: Any) {
        delegate.dismissButtonClicked()
    }

}
