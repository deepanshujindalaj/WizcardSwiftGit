//
//  LeftMenuViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 06/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

protocol LeftMenuViewControllerDelegate {
    func backButtonPressed()
}

class LeftMenuViewController: UIViewController {

    @IBOutlet weak var firstAndLastNameOutlet: UILabel!
    @IBOutlet weak var profilePicOutlet: RoundableUIImageView!
    var eventL2ViewController : EventL2ViewController!
    var delegate : LeftMenuViewControllerDelegate!
    var selfwizcard : Wizcard!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selfwizcard = WizcardManager.wizcardManager.getSelfWizcard()
        CommonFunction.showProfileImage(profilePicOutlet: profilePicOutlet, firstandLastNameLblOutlet: nil, titleLblOutlet: nil, destination: nil, wizcard: selfwizcard)
        
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
    
    @IBAction func openMeScreenClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: StoryboardNames.LandingScreen, bundle: nil)
        let mecreenViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.LandinScreen.meScreen) as! MeViewController
        mecreenViewController.selfwizcard = selfwizcard
        self.navigationController?.pushViewController(mecreenViewController, animated: true)
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any){
        delegate.backButtonPressed()
    }
    
}
