//
//  RolodexL2ViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 06/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class RolodexL2ViewController: UIViewController {

    var wizcard : Wizcard!
    
    @IBOutlet weak var phoneNumberLblOutlet: UILabel!
    @IBOutlet weak var emailLblOutlet: UILabel!
    
    @IBOutlet weak var socialViewParent: CornerRadiousAndShadowView!
    
    @IBOutlet weak var facebookViewOutlet: UIView!
    @IBOutlet weak var facebookIcon: UIImageView!
    @IBOutlet weak var twitterViewOutlet: UIView!
    @IBOutlet weak var linkedInViewOutlet: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        phoneNumberLblOutlet.text   =   wizcard.phone
        emailLblOutlet.text         =   wizcard.email
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let rolodexPageViewController = segue.destination as? RolodexPageViewController {
            rolodexPageViewController.wizcard = wizcard
        }
    }

}
