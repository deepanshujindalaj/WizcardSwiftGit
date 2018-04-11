//
//  ConfirmViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 25/03/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import CoreLocation

class ConfirmViewController: UIViewController {

    @IBOutlet weak var confirmationCodeTxtOutlet: UITextField!
    @IBOutlet weak var phoneNumberLblOutlet: UILabel!
    var locationManager : LocationManager!
    var phoneNumber : String!
    var cordinateLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        phoneNumberLblOutlet.text = phoneNumber
        
        
        locationManager = LocationManager(delegate:self)
        locationManager.startUpdatingLocation()
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
        
        let userName = phoneNumber + "@wizcard.com"
        
        let params :[String:Any] = [
            "response_key": confirmationCodeTxtOutlet.text ?? "",
            "username": userName
        ]
        
        
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForPhone_Check_Response, jsonToPost: params) { (json) in
            
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    let jsonData = json[ServerKeys.data]
                    let user_id = jsonData[ProfileKeys.user_id].string ?? ""
                    HelperFunction.saveValueInUserDefaults(key: ProfileKeys.user_id, value: user_id)
                    self.loginUser(userID: user_id)
                }
            }
        }
    }
    
    func loginUser(userID : String){
        let userName = phoneNumber + "@wizcard.com"
        
        let params :[String:Any] = [
            "password": HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.deviceID) + userID,
            "username": userName,
            ProfileKeys.user_id : userID
        ]
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForLogin, jsonToPost: params) { (json) in
            
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    let jsonData = json[ServerKeys.data]
                    let wizuser_id = jsonData[ProfileKeys.wizuser_id].int ?? 0
                    self.registerUser(wizuser_id: wizuser_id)
                }
            }
        }
    }
    
    func registerUser(wizuser_id : Int){
        
        var deviceToken = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.deviceToken)
        if deviceToken == ""{
            deviceToken = "Simulator"
        }
        
        let params :[String:Any] = [
            ProfileKeys.user_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id),
            ProfileKeys.wizuser_id: wizuser_id,
            "reg_token" : deviceToken,
            "device_type" : "ios",
            "lat" : cordinateLocation.latitude,
            "lng" : cordinateLocation.longitude
        ]
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForRegister, jsonToPost: params) { (json) in
            
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    let jsonData = json[ServerKeys.data]
                    
                    if jsonData[ProfileKeys.wizcard].exists(){
                        var wizcardJSON = jsonData[ProfileKeys.wizcard]
                        wizcardJSON[ProfileKeys.user_id].stringValue = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id)
                        WizcardManager.wizcardManager.saveWizcard(wizcard: jsonData[ProfileKeys.wizcard])
                    }
                    
                    
                    
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



extension ConfirmViewController : LocationManagerDelegate
{
    func locationDenied() {
        
    }
    
    func didChangeinLocation(cordinate: CLLocationCoordinate2D) {
        cordinateLocation = cordinate
        locationManager.stopUpdatingLocation()
    }
    
    func didErrorinLocation(error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationNotAvailable() {
        DispatchQueue.main.async {
            if let _ = self.presentedViewController { return }
            self.showLocationAlert()
        }
    }
    func locationFaliedToUpdate(status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.showLocationAlert()
        }
    }
    
}
