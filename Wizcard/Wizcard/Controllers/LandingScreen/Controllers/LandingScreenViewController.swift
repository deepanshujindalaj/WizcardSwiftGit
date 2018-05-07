//
//  LandingScreenViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 01/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import SideMenu

class LandingScreenViewController: UIViewController {

    var selfwizcard : Wizcard!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        SideMenuManager.default.menuPresentMode                     =   .menuSlideIn
        SideMenuManager.default.menuAnimationTransformScaleFactor   =   0.8
        SideMenuManager.default.menuFadeStatusBar                   =   false
        SideMenuManager.default.menuWidth                           =   self.view.frame.width * 0.75
        selfwizcard = WizcardManager.wizcardManager.getSelfWizcard()
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
