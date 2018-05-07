//
//  MeViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 06/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    var selfwizcard : Wizcard!
    
    @IBOutlet weak var firstandLastNameLblOutlet: UILabel!
    @IBOutlet weak var profilePicOutlet: RoundableUIImageView!
    @IBOutlet weak var titleLblOutlet: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
        CommonFunction.showProfileImage(profilePicOutlet: profilePicOutlet, firstandLastNameLblOutlet: firstandLastNameLblOutlet, titleLblOutlet: titleLblOutlet, destination: nil, wizcard: selfwizcard)
        
        
        
        

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

    @IBAction func myProfileButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardNames.LandingScreen, bundle: nil)
        let mecreenViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.LandinScreen.rolodexL2ViewController) as! RolodexL2ViewController
        mecreenViewController.wizcard = selfwizcard
        self.navigationController?.pushViewController(mecreenViewController, animated: true)
    }
}
