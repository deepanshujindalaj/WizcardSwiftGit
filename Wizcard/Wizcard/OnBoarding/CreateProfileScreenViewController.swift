//
//  CreateProfileScreenViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 17/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class CreateProfileScreenViewController: UIViewController {

    @IBOutlet weak var aboutME: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    var wizcard : Wizcard!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if wizcard != nil {
            firstName.text      =   wizcard.firstName;
            lastName.text       =   wizcard.lastName;
            let contactConainers =  wizcard.contactContainers?.allObjects as! [ContactContainer]
            
            companyName.text    =   contactConainers[0].company
            titleName.text      =   contactConainers[0].title
        }
        
        
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
