//
//  ConfirmViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 25/03/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {

    @IBOutlet weak var confirmationCodeTxtOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

    @IBAction func confirmButtonClicked(_ sender: Any) {
        
    }
    @IBAction func resendButtonClicked(_ sender: Any) {
        
    }
}
