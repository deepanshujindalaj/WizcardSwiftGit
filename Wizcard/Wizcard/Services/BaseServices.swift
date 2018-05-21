//
//  File.swift
//  EZER
//
//  Created by Geeta on 24/11/17.
//  Copyright © 2017 TimerackMac1. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Reachability


open class BaseServices {
    
    open class func SendPostJson(viewController: UIViewController?,method :HTTPMethod = .post,serverUrl:String,jsonToPost:[String:Any],isResponseRequired : Bool = false,showLoader : Bool = true,completion:@escaping (JSON?) -> Void) {
        
        
        let header :[String:Any] = [
            "version":"2.1",
            "msg_type":serverUrl,
            "device_id": HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.deviceID)
        ]
        
        
        let params :[String:Any] = [
            "sender":jsonToPost,
            "header":header,
        ]
        
        
        
        
        let reachability = Reachability()!
        let json = JSON(params)
        //print("serverUrl",serverUrl)
        print(json)
        if reachability.connection == .none //checking internet connectivity here
        {
            viewController?.hideProgressBar()
            viewController?.showAlertController( message: ValidationMessages.noInternet)
            return
        }
        //showing loader
        if showLoader{
            viewController?.showProgressBar()
        }
        
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        Alamofire.request(
            URL(string: ServerUrls.baseAddress)!,
            method: method,
            parameters:params,encoding:JSONEncoding.default)
            .validate()
            .responseJSON { (response) in
                if showLoader{
                    viewController?.hideProgressBar()
                }
                switch response.result {
                case .success(_):
                    
                    if(response.result.value == nil)
                    {
                        viewController?.showAlertController( message: ValidationMessages.serverFailiure)
                        /*if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                        }*/
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
                                viewController?.showMessage(json[ServerKeys.message].string ?? "", type: .error,options: [.textNumberOfLines(0)])
                                completion(nil)
                            }
                        }else{
                            showAlertDialogAccording(errorCode: json[ServerKeys.status].int ?? 0, viewCon: viewController)
                        }
                    }
                case .failure(let error):
                    
                   /* if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data:InOther \(utf8Text)")
                    }*/
                    
                    if error._code == NSURLErrorTimedOut {
                        viewController?.showAlertController( message: "Server TimeOut")
                        completion(nil)
                    }
                    else if error._code == NSURLErrorNetworkConnectionLost{
                       // print("Server Repeat")
                        SendPostJson(viewController: viewController,method: method,serverUrl: serverUrl,jsonToPost: jsonToPost, isResponseRequired: isResponseRequired, completion: completion)
                    }
                    else  {
                        if !isResponseRequired{
                            viewController?.showAlertController( message: "Invalid json Data")
                            completion(nil)
                        }
                    }
                }
        }
    }
    
    class func uploadImageToServer(image: UIImage,imageType:String,role: String,mimeType:String = "image/jpeg",quality:CGFloat = 0.7,completion:@escaping (JSON?) -> Void )
    {
        let params: Parameters = ["role": role,"imageType": imageType]
        var imageData : Data!
        var fileName = ""
        switch mimeType {
        case "image/png":
            imageData = UIImagePNGRepresentation(image)!
            fileName = "filename.png"
        default://case "image/jpeg":
            fileName = "filename.jpeg"
            imageData = UIImageJPEGRepresentation(image, quality)!
        }
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                multipartFormData.append(imageData, withName: "imageCode", fileName: fileName, mimeType: mimeType)
                for (key, value) in params
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        }, to:ServerUrls.Main.uploadImageToS3,method: .post,headers:nil)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                   // print(progress.fractionCompleted)
                    //self.progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
                })
                upload.responseJSON
                    { response in
                        switch response.result {
                        case .success(_):
                            if(response.result.value == nil)
                            {
                                completion(nil)
                            }else{
                                let json = JSON(response.result.value!)
                                //print(json)
                                if json[ServerKeys.status].int == 1
                                {
                                    completion(json)
                                }else{
                                    completion(nil)
                                }
                            }
                        case.failure(let error):
                          //  print("server failiure",error)
                            if error._code == NSURLErrorTimedOut {
                             //   print("server timeout")
                                completion(nil)
                            }
                            else if error._code == NSURLErrorNetworkConnectionLost{
                                //print("Server Repeat")
                                uploadImageToServer(image: image,imageType:imageType,role: role,mimeType:mimeType,quality:quality,completion:completion)
                            }
                            else  {
                                completion(nil)
                            }
                        }
                }
            case .failure(let error):
               
                print("failiure",error)
            }
        }
    }
    open class func sendGetJson(serverUrl:String,completion:@escaping (JSON?) -> Void) {
        Alamofire.request(
            URL(string: serverUrl)!)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    
                    if(response.result.value == nil)
                    {
                        /*if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                        }*/
                        completion(nil)
                    }else{
                        let json = JSON(response.result.value!)
                        completion(json)
                    }
                case .failure(let error):
                    
                   /* if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }*/
                    
                    if error._code == NSURLErrorTimedOut {
                        completion(nil)
                    }
                    else if error._code == NSURLErrorNetworkConnectionLost{
                      //  print("Server Repeat")
                    }
                    
                }
        }
    }
    
    // use if you don't wanna anything in response
    open class func sendPostJson(serverUrl:String,jsonToPost:[String:Any]) {
        
        Alamofire.request(
            URL(string: serverUrl)!,
            method: .post,
            parameters:jsonToPost,encoding:JSONEncoding.default)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .success(_):
                    
                    if(response.result.value == nil)
                    {
                        /*if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Data: \(utf8Text)")
                        }*/
                        
                    }else{
                        let json = JSON(response.result.value!)
                        //print(json)
                    }
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                    }
                    else if error._code == NSURLErrorNetworkConnectionLost{
                      //  print("Server Repeat")
                    }
                }
        }
    }
    open class func showAlertDialogAccording(errorCode : Int,viewCon : UIViewController?)
    {
        guard let viewCon = viewCon else { return }
        switch errorCode {
        case 100:
            let action = UIAlertAction.init(title: "OK", style: .cancel, handler: { (action) in
                
            })
            viewCon.showAlertController( message: ValidationMessages.orderCancelByUser, action: action)
        default:
            print("0 case")
        }
    }
}
