//
//  SocialMediaManager.swift
//  Wizcard
//
//  Created by Akash Jindal on 24/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import LinkedinSwift

class SocialMediaManager: NSObject {

//    static let socialMediaManager = SocialMediaManager()
    
    static let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "78wsyuutdyfaw7", clientSecret: "T65KHZju72SkyYUB", state: "DLKDJF46ikMMZADfdfds", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://github.com/tonyli508/LinkedinSwift"))
    
    open class func processLinkedAccount(viewController: UIViewController, completion:@escaping (Wizcard?) -> Void) {
        linkedinHelper.authorizeSuccess({ [unowned viewController] (lsToken) -> Void in
            
            viewController.showProgressBar()
            self.linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,public-profile-url,date-of-birth,phone-numbers,location)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                viewController.hideProgressBar()
                print("\(response)")
                
                let jsonData = response.jsonObject
                
                let wizcard = WizcardManager.wizcardManager.getAllocatedWizcardForWizUserID(wizUserID: 0, isUnAssociate: true)
                wizcard.userId      =   HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id)
                if let myInteger = Int(HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id)) {
                    wizcard.wizUserId = NSNumber(value:myInteger)
                }
                
                wizcard.email       =   jsonData!["emailAddress"] as? String
                wizcard.firstName   =   jsonData!["firstName"] as? String
                wizcard.lastName    =   jsonData!["lastName"] as? String
                
                var extFieldsArray = Array<ExtFields>()
                if let values = jsonData!["positions"] as? NSDictionary{
                    if let valuesDict = values["values"] as? NSArray{
                        
                        if let firstInstance = valuesDict[0] as? NSDictionary{
                            
                            let extFields       =   ExtFieldManager.extFieldManager.getAllocatedExtFieldsUnAssociated(isUnAssociate: true)
                            extFields.key       =   SocialMedia.ABOUTME
                            extFields.value     =   firstInstance["summary"] as? String
                            extFieldsArray.append(extFields)
                            
                            let contactContainer = WizcardManager.wizcardManager.getAllocatedContactContainerUnAssociated(isUnAssociate: true)
                            
                            if let companyDic = firstInstance["company"] as? NSDictionary{
                                contactContainer.company = companyDic["name"] as? String
                            }
                            contactContainer.title = firstInstance["title"] as? String
                            wizcard.contactContainers = NSSet(object: contactContainer)
                        }
                    }
                }
                
                if let profilePic = jsonData!["pictureUrl"] as? String{
                    let media = MediaManager.mediaManager.getAllocatedMediaUnAssociated(isUnAssociate: true)
                    media.media_element     =   profilePic
                    media.media_type        =   MediaTypes.IMG
                    media.media_sub_type    =   MediaTypes.THB
                    wizcard.media = NSSet(object: media)
                }
                
                if let _ = jsonData!["publicProfileUrl"]{
                    let extFields       =   ExtFieldManager.extFieldManager.getAllocatedExtFieldsUnAssociated(isUnAssociate: true)
                    extFields.key       =   SocialMedia.LINKEDIN
                    extFields.value     =   jsonData!["publicProfileUrl"] as? String
                    extFieldsArray.append(extFields)
                }else if let _ = jsonData!["siteStandardProfileRequest"]{
                    let extFields       =   ExtFieldManager.extFieldManager.getAllocatedExtFieldsUnAssociated(isUnAssociate: true)
                    extFields.key       =   SocialMedia.LINKEDIN
                    extFields.value     =   jsonData!["siteStandardProfileRequest"] as? String
                    extFieldsArray.append(extFields)
                }
                
                if extFieldsArray.count > 0{
                    wizcard.extfields = NSSet(array: extFieldsArray)
                }
                
                completion(wizcard)
                
            }) { [unowned viewController] (error) -> Void in
                print("\(error)")
                completion(nil)
                viewController.hideProgressBar()
            }
            }, error: { [unowned viewController] (error) -> Void in
                print("\(error)")
                completion(nil)
                viewController.hideProgressBar()
                
            }, cancel: { [unowned viewController] () -> Void in
                completion(nil)
                viewController.hideProgressBar()
                
        })
    }
    
}
