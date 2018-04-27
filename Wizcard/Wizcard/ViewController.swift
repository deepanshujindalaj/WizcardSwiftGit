//
//  ViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/02/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    
        
        if HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizcard_id) != ""{
            
        }
        else if HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id) != ""{
            let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
            let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileViewController) as! CreateProfileViewController
            self.navigationController?.pushViewController(confirmViewController, animated: true)
        }
        else if HelperFunction.getBooleanFromUserDefaults(key: UserDefaultKeys.kKeyForIsHelpShown){
            let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
            let viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.loginViewCon) as! LoginViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
            let pageViewControler = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.helpViewController) as! HelpViewController
            self.navigationController?.pushViewController(pageViewControler, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
