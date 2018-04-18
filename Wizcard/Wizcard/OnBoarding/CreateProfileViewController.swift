//
//  CreateProfileViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import LinkedinSwift

class CreateProfileViewController: UIViewController {

    let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "77tn2ar7gq6lgv", clientSecret: "iqkDGYpWdhf7WKzA", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"))
    
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
    @IBAction func linkedInButtonClicked(_ sender: Any) {
        linkedinHelper.authorizeSuccess({ [unowned self] (lsToken) -> Void in
            
            self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                    print("\(response)")
                
                let jsonData = response.jsonObject
                
                
                
                let wizcard = WizcardManager.wizcardManager.getAllocatedWizcardForWizUserID(wizUserID: 0, isUnAssociate: true)
                
                wizcard.email       =   jsonData!["emailAddress"] as? String
                wizcard.firstName   =   jsonData!["firstName"] as? String
                wizcard.lastName    =   jsonData!["lastName"] as? String
                
                if let values = jsonData!["positions"] as? NSDictionary{
                    if let valuesDict = values["values"] as? NSArray{
                        
                        if let firstInstance = valuesDict[0] as? NSDictionary{
                        
                            let contactContainer = WizcardManager.wizcardManager.getAllocatedContactContainerUnAssociated(isUnAssociate: true)
                        
                            contactContainer.title = firstInstance["title"] as? String
                        
                            
                            wizcard.contactContainers = NSSet(object: contactContainer)
                        }
                    }
                    
                    
                }
                
                
                
                
                
                let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
                let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
                confirmViewController.wizcard = wizcard
                
                self.navigationController?.pushViewController(confirmViewController, animated: true)
                
                }) { [unowned self] (error) -> Void in
                    print("\(error)")
                }
            }, error: { [unowned self] (error) -> Void in
                print("\(error)")
                
            }, cancel: { [unowned self] () -> Void in
                
            
        })
    }
    
    @IBAction func scanYourBusinessCardClicked(_ sender: Any) {
        
    }
    @IBAction func enterManuallyClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
        let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
        
        
        self.navigationController?.pushViewController(confirmViewController, animated: true)
    }
    
}