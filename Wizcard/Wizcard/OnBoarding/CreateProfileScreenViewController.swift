//
//  CreateProfileScreenViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 17/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class CreateProfileScreenViewController: UIViewController {

    @IBOutlet weak var facebookButtonOutlet: UIButton!
    @IBOutlet weak var twitterButtonOutlet: UIButton!
    @IBOutlet weak var linkedButtonOutlet: UIButton!
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
            email.text          =   wizcard.email
            let contactConainers =  wizcard.contactContainers?.allObjects as! [ContactContainer]
            
            companyName.text    =   contactConainers[0].company
            titleName.text      =   contactConainers[0].title
            phoneNumber.text    =   HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.phone)
            
            let extFields       =   wizcard.extfields?.allObjects as! [ExtFields]
            
            let filteredArrayAboutMe   =   extFields.filter() { $0.key == SocialMedia.ABOUTME }
            
            if filteredArrayAboutMe.count > 0{
                let extField    =   filteredArrayAboutMe[0]
                aboutME.text    =   extField.value
            }
            
            let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }
            
            if filteredArrayLinkedInArray.count > 0{
                linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedindelete"), for: .normal)
            }
        }else{
            
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

    @IBAction func linkedInButtonClicked(_ sender: Any) {
        if wizcard.extfields != nil {
            var extFields       =   wizcard.extfields?.allObjects as! [ExtFields]
            
            let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }
            
            if filteredArrayLinkedInArray.count > 0{
                extFields.remove(at: extFields.index(of: filteredArrayLinkedInArray[0])!)
                wizcard.extfields = NSSet(array : extFields)
                linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedinadd"), for: .normal)
            }else{
                
                SocialMediaManager.processLinkedAccount(viewController: self) { (wizcardLocal) in
                    let extFields       =   wizcardLocal?.extfields?.allObjects as! [ExtFields]
                    let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }

                    if filteredArrayLinkedInArray.count > 0{
                        var extFieldsGlobalWizcard       =   self.wizcard.extfields?.allObjects as! [ExtFields]
                        extFieldsGlobalWizcard.append(filteredArrayLinkedInArray[0])
                        self.wizcard.extfields = NSSet(array : extFieldsGlobalWizcard)
                        self.linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedindelete"), for: .normal)
                    }
                }
            }
        }
    }
    @IBAction func twitterButtonClicked(_ sender: Any) {
        
    }
    @IBAction func facebookButtonClicked(_ sender: Any) {
        
    }
}
