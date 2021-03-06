//
//  CommonFunction.swift
//  Wizcard
//
//  Created by Akash Jindal on 27/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import AWSS3


class CommonFunction: NSObject {

    open class func uploadProfileImage(image: UIImage, completion:@escaping (String?, Error?) -> Void){
        
        let credentialProvider = AWSCognitoCredentialsProvider.init(regionType: .APSouth1, identityPoolId: "ap-south-1:8de9ae7f-0234-484d-81e3-afda1354d576")
        
        let awSServiceConfiguration = AWSServiceConfiguration.init(region: .APSouth1, credentialsProvider: credentialProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = awSServiceConfiguration

        let fileName = "thumbnails/WZThumbnail\(HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id)).jpeg"
        let data = UIImagePNGRepresentation(image)

        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar
                print("\(progress)")
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                completion("https://wizcard-media-test.s3.amazonaws.com/\(fileName)", error)
                
            })
        }
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data!, bucket: AWSBucketKeys.AWSTHUMBNAILBUCKET, key: fileName, contentType: "image/jpeg", expression: expression, completionHandler: completionHandler)
    }
    
    open class func uploadBusinessCardImage(image: UIImage, completion:@escaping (String?, Error?) -> Void){
        
        let credentialProvider = AWSCognitoCredentialsProvider.init(regionType: .APSouth1, identityPoolId: "ap-south-1:8de9ae7f-0234-484d-81e3-afda1354d576")
        let awSServiceConfiguration = AWSServiceConfiguration.init(region: .APSouth1
            , credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = awSServiceConfiguration
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.DateFormatForImages
        let result = formatter.string(from: date)
        
        let fileName = "thumbnails/WZCard\(result).jpeg"
        let data = UIImagePNGRepresentation(image)
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Update a progress bar
                print("\(progress)")
            })
        }
        
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                // Do something e.g. Alert a user for transfer completion.
                // On failed uploads, `error` contains the error object.
                print("\(task)")
                
                let url = "https://wizcard-media-test.s3.amazonaws.com/\(fileName)"
                completion(url, error)
                
            })
        }

        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data!, bucket: AWSBucketKeys.AWSTHUMBNAILBUCKET, key: fileName, contentType: "image/jpeg", expression: expression, completionHandler: completionHandler)
    }
    
    
    class func showProfileImage(profilePicOutlet : RoundableUIImageView, firstandLastNameLblOutlet : UILabel?, titleLblOutlet : UILabel?, destination : UILabel?,  wizcard : Wizcard)
    {
        if let media = HelperFunction.getWizcardThumbnail(arrayList: wizcard.media?.allObjects as? [Media]){
            if let picUrl = URL(string:media.media_element!)
            {
                profilePicOutlet.af_setImage(withURL:  picUrl)
            }
        }else{
            profilePicOutlet.image = #imageLiteral(resourceName: "createProfilePlaceholder")
        }
        
        if firstandLastNameLblOutlet != nil {
            firstandLastNameLblOutlet?.text = "\(wizcard.firstName ?? "") \(wizcard.lastName ?? "")"
        }
        
        if titleLblOutlet != nil{
            let contactContainers =  wizcard.contactContainers?.allObjects as! [ContactContainer]
            titleLblOutlet?.text =   contactContainers[0].title
            
            if destination != nil{
                destination?.text = contactContainers[0].company
            }
        }
    }

}
