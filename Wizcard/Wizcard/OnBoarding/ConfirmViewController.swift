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
    @IBOutlet weak var phoneNumberLblOutlet: UILabel!
    
    var phoneNumber : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        phoneNumberLblOutlet.text = phoneNumber
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
        if !isValid(){
            return
        }
        
        let target = ""//phoneCode + phoneNumber.text!
        let userName = target + "@wizcard.com"
        
        let params :[String:Any] = [
            "response_key": confirmationCodeTxtOutlet.text ?? "",
            "username": userName
        ]
        
        
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForPhone_Check_Response, jsonToPost: params) { (json) in
            
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
                    let driverInfoController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.confirmViewController) as! ConfirmViewController
                    
                    
                    self.navigationController?.pushViewController(driverInfoController, animated: true)
                }
            }
        }
    }
    @IBAction func resendButtonClicked(_ sender: Any) {

        
        
        let userName = phoneNumber + "@wizcard.com"
        
        let params :[String:Any] = [
            "response_mode":"sms",
            "target":phoneNumber,
            "username": userName
        ]
        
        
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForPhone_Check_Request, jsonToPost: params) { (json) in
            
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    
                }
            }
        }
    }
    
    
    func isValid() -> Bool{
        var isValid = true
        if confirmationCodeTxtOutlet.text?.length == 0{
            showMessage(ValidationMessages.invalidCode, type: .info)
            isValid = false
        }
        return isValid
    }
}
