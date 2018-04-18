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

    @IBOutlet weak var resendPinBtnOutlet: RoundableButton!
    @IBOutlet weak var confirmationCodeTxtOutlet: UITextField!
    @IBOutlet weak var phoneNumberLblOutlet: UILabel!
    var locationManager : LocationManager!
    var phoneNumber : String!
    var cordinateLocation: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        phoneNumberLblOutlet.text = phoneNumber
        resendPinBtnOutlet.isEnabled = false
        
        locationManager = LocationManager(delegate:self)
        locationManager.startUpdatingLocation()
        startTheTimer()
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

    func startTheTimer(){
        var timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
    }

    // must be internal or public.
    @objc func update() {
        // Something cool
        resendPinBtnOutlet.backgroundColor = UIColor.buttonSelected
        resendPinBtnOutlet.isEnabled = true
        self.resendPinBtnOutlet.setTitleColor(UIColor.white, for: .normal)
    }

    @IBAction func confirmButtonClicked(_ sender: Any) {
        if !isValid(){
            return
        }
        
        confirmationCodeTxtOutlet.resignFirstResponder()
        
        
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
                        if jsonData[EventsKeys.events].exists(){
                            EventManager.eventManager.populateEventsFromServerNotif(eventJSON: jsonData[EventsKeys.events], createUnAssociate: false)
                        }
                        
                        if jsonData[ProfileKeys.wizcard].exists(){
                            var wizcardJSON = jsonData[ProfileKeys.wizcard]
                            wizcardJSON[ProfileKeys.user_id].stringValue = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id)
                            WizcardManager.wizcardManager.populateWizcardFromServerNotif(wizcard: wizcardJSON, createUnAssociate: false)
                        }
                        
                        var rolodexArraySuper = [Wizcard]()
                        if jsonData[ProfileKeys.rolodex].exists(){
                            if let jsonArray = jsonData[ProfileKeys.rolodex].array
                            {
                                if jsonArray.count > 0{
                                    for rolodexArray in jsonArray{
                                        if let wizcarderArray = rolodexArray.array{
                                            for var wizcard in wizcarderArray{
                                                wizcard[ProfileKeys.isExistInRolodex].bool = true
                                                rolodexArraySuper.append(WizcardManager.wizcardManager.populateWizcardFromServerNotif(wizcard: wizcard, createUnAssociate: false))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        if jsonData[ProfileKeys.context].exists(){
                            if let contextArray = jsonData[ProfileKeys.context].array{
                                if contextArray.count > 0{
                                    for item in contextArray{
                                        let wizcardID = item[ProfileKeys.asset_id].number
                                        for wizcard in rolodexArraySuper{
                                            if (wizcard.wizcard_id?.isEqual(to: wizcardID!))! {
                                                wizcard.timeStamp       =   item[ProfileKeys.time].string ?? ""
                                                wizcard.descriptionText =   item[CommonKeys.description_small].string ?? ""
                                                if item[ProfileKeys.notes].exists(){
                                                    let notes = item[ProfileKeys.notes]
                                                    
                                                    if notes[ProfileKeys.note].exists(){
                                                        wizcard.notes       =   notes[ProfileKeys.note].string ?? ""
                                                        wizcard.lastSaved   =   notes[ProfileKeys.last_saved].string ?? ""
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        WizcardManager.wizcardManager.saveContext()
                    }
                    else{
                        let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
                        let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileViewController) as! CreateProfileViewController
                        
                        
                        self.navigationController?.pushViewController(confirmViewController, animated: true)
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
                    self.resendPinBtnOutlet.isEnabled = false
                    self.resendPinBtnOutlet.backgroundColor = UIColor.buttonUnSelected
                    self.resendPinBtnOutlet.layer.cornerRadius = 7
                    self.resendPinBtnOutlet.setTitleColor(UIColor.unselecteButtonTextColor, for: .normal)
                    self.startTheTimer()
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
