//
//  RolodexInforFirstPageViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 06/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class RolodexInforFirstPageViewController: BaseViewController {

    
    
    var wizcard : Wizcard!
    @IBOutlet weak var profilePicOutlet: RoundableUIImageView!
    
    @IBOutlet weak var firstAndLastNameOutlet: UILabel!
    @IBOutlet weak var titleLbltOutlet: UILabel!
    @IBOutlet weak var companyLblOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CommonFunction.showProfileImage(profilePicOutlet: profilePicOutlet, firstandLastNameLblOutlet: firstAndLastNameOutlet, titleLblOutlet: titleLbltOutlet, destination: companyLblOutlet,   wizcard: wizcard)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
