//
//  LoginPageContentViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 21/02/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class LoginPageContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageFile = ""
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.image =  UIImage(named:imageFile)
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
