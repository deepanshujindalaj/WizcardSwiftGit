//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
extension UIViewController {
    
    func showProgressBar()
    {
        JustHUD.shared.showInWindow(window: (UIApplication.shared.delegate as! AppDelegate).window!)
        //JustHUD.shared.showInView(view: self.view)
    }
    func hideProgressBar()
    {
        JustHUD.shared.hide()
    }
    
    func showAlertController(heading:String = AppName,message : String, action : UIAlertAction? = nil)
    {
        if let viewCon = self.presentedViewController
        {
            viewCon.dismiss(animated: false)
        }
        let alertCon = UIAlertController(title: heading, message: message, preferredStyle: .alert)
        if action == nil{
        alertCon.addAction(UIAlertAction.init(title: "OK", style: .cancel))
        }
        else
        {
            alertCon.addAction(action!)
        }
        self.present(alertCon, animated: true) 
    }
    func showLocationAlert()
    {
        let alertCon = UIAlertController(title: AppName, message: "please turn on the location services in settings-> location", preferredStyle: .alert)
        alertCon.addAction(UIAlertAction.init(title: "Setting", style: .cancel){
            action in
            var url = "App-Prefs:root=Privacy&path=LOCATION"//"app-settings:root=Privacy&path=LOCATION"
            if CLLocationManager.locationServicesEnabled() {
                print("main enabled")
                url = UIApplicationOpenSettingsURLString
            }
            if let url = URL(string: url){
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(url, completionHandler: nil)
                } else{
                    UIApplication.shared.openURL(url)
                }
            }
        })
        alertCon.addAction(UIAlertAction.init(title: "OK", style: .default)
        { action in
            
        })
        self.present(alertCon, animated: true)
    }
    
    func showCameraAlert()
    {
        let action  = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString){
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(url, completionHandler: nil)
                } else{
                    UIApplication.shared.openURL(url)
                }
            }
        }
        let message = "Please turn on the camera in settings-> Camera"
        showAlertController(message: message, action: action)
    }
    
    func checkCameraPermission(completion:@escaping (_ action : Bool) -> Void )
    {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied, .restricted:
            completion(false)
        case .authorized:
            completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                DispatchQueue.main.async {
                    if granted {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
            
        }
    }
    
}
