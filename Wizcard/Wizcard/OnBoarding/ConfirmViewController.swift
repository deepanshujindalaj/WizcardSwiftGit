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
    var locationManager : LocationManager!
    var phoneNumber : String!
    
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
                    self.loginUser(userID: jsonData[ServerKeys.user_id].string ?? "")
                }
            }
        }
    }
    
    func loginUser(userID : String){
        let userName = phoneNumber + "@wizcard.com"
        
        let params :[String:Any] = [
            "password": HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.deviceID) + userID,
            "username": userName,
            "user_id" : userID
        ]
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForLogin, jsonToPost: params) { (json) in
            
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    let jsonData = json[ServerKeys.data]
                    self.registerUser(wizuser_id: jsonData[ServerKeys.wizuser_id].string ?? "")
                }
            }
        }
    }
    
    func registerUser(wizuser_id : String){
        let params :[String:Any] = [
            "password": HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.deviceID) + userID,
            "username": userName,
            "reg_token" : HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.deviceToken),
            "device_type" : "ios"
        ]
        
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
        let camera = GMSCameraPosition.camera(withLatitude: cordinate.latitude,
                                              longitude: cordinate.longitude,
                                              zoom: zoomLevel)
        if locationMap.isHidden {
            locationMap.isHidden = false
            locationMap.camera = camera
        } else {
            locationMap.animate(to: camera)
        }
        addMrkerOnMap(coordinate:cordinate)
        reverseGeocodeCoordinate(coordinate: cordinate)
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
