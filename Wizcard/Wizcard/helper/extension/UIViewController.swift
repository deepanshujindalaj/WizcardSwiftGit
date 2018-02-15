//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import CoreLocation
extension UIViewController {
    
    
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
    
}
