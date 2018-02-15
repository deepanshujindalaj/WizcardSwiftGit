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
        
        let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
        let pageViewControler = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.pageViewController) as! PageViewController
        self.navigationController?.pushViewController(pageViewControler, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

