//
//  NearByServices.swift
//  Wizcard
//
//  Created by Akash Jindal on 21/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NearByServices: NSObject {

    static let nearByServices = NearByServices()
    var nearByWizcarderArrayList = [Wizcard]()
    
    func SendPostJson(method :HTTPMethod = .post,serverUrl:String,jsonToPost:[String:Any],isResponseRequired : Bool = false,showLoader : Bool = true,completion:@escaping (JSON?) -> Void) {
        
        
        let header :[String:Any] = [
            "version":"2.1",
            "msg_type":serverUrl,
            "device_id": HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.deviceID)
        ]
        
        let params :[String:Any] = [
            "sender":jsonToPost,
            "header":header,
            ]
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        Alamofire.request(
            URL(string: ServerUrls.baseAddress)!,
            method: method,
            parameters:params,encoding:JSONEncoding.default)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .success(_):
                    
                    if(response.result.value == nil)
                    {
                        completion(nil)
                    }else{
                        let json = JSON(response.result.value!)
                        print(json)
                        let jsonObject = json[ServerKeys.result]
                        
                        if jsonObject[ServerKeys.error] == 0{
                            completion(json)
                        }else if jsonObject[ServerKeys.error] == 1 {
                            if isResponseRequired{
                                completion(json)
                            }else{
                            }
                        }else{
                            
                        }
                    }
                case .failure(let error):
                    
                    /* if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                     print("Data:InOther \(utf8Text)")
                     }*/
                    
                    if error._code == NSURLErrorTimedOut {
                        completion(nil)
                    }
                    else if error._code == NSURLErrorNetworkConnectionLost{
                        // print("Server Repeat")
                        
                    }
                    else  {
                        if !isResponseRequired{
                            completion(nil)
                        }
                    }
                }
        }
    }
    
    
    func getCards(){

        if AppDelegate.appDelgate.cordinateLocation != nil{
            let params :[String:Any] = [
                ProfileKeys.user_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id),
                ProfileKeys.wizuser_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id),
                ProfileKeys.lat : AppDelegate.appDelgate.cordinateLocation.latitude,
                ProfileKeys.lng : AppDelegate.appDelgate.cordinateLocation.longitude,
                "onWifi" : false
            ]
            
            SendPostJson(serverUrl: ServerUrls.APICalls.kKeyForGet_Cards, jsonToPost: params) { (json) in
                if let json = json{
                    let jsonObject = json[ServerKeys.result]
                    if jsonObject[ServerKeys.error] == 0{
                        let data = json[ServerKeys.data]
                        
                        if data[ServerKeys.numElements].exists() && data[ServerKeys.numElements].int != 0{
                            if let dataArrayList = data[ServerKeys.elementList].array
                            {
                                if dataArrayList.count > 0{
                                    for element in dataArrayList{
                                        switch(element["notifType"].int!){
                                        case 1:
                                            print("")
                                        case 2:
                                            print("")
                                        case 7:
                                            print("")
                                        default:
                                            print("")
                                            break
                                        }
                                    }
                                }
                            }
                            self.callgetcards()
                        }else{
                            self.callgetcards()
                        }
                    }else {
                        self.callgetcards()
                    }
                }else{
                    self.callgetcards()
                }
            }
        }else{
            self.callgetcards()
        }
    }
    
    func callgetcards(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0, execute: {
            self.getCards()
        })
    }
    
    func updateNearBuUsers(wizcardElement : JSON){
        
        nearByWizcarderArrayList.removeAll()
        if wizcardElement[ServerKeys.data].exists(){
            if let wizcardArray = wizcardElement[ServerKeys.data].array{
                for wizcardData in wizcardArray{
                    nearByWizcarderArrayList.append(WizcardManager.wizcardManager.populateWizcardFromServerNotif(wizcard: wizcardData, createUnAssociate: true))
                }
            }
        }
        
        
    }
    
}
