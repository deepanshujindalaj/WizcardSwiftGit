//
//  CreateProfileViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    @IBAction func linkedInButtonClicked(_ sender: Any) {
        
        
        SocialMediaManager.processLinkedAccount(viewController: self) { (wizcard) in
            
            let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
            let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
            confirmViewController.wizcard = wizcard
            
            self.navigationController?.pushViewController(confirmViewController, animated: true)
            
        }
        
        
        
        
        
    }
    
    @IBAction func scanYourBusinessCardClicked(_ sender: Any) {
        
    }
    @IBAction func enterManuallyClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
        let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
        
        
        self.navigationController?.pushViewController(confirmViewController, animated: true)
    }
    
}
