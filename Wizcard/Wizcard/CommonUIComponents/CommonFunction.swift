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

    
    open class func uploadProfileImage(image: UIImage, completion:@escaping (String?, Error) -> Void){
        
        let credentialProvider = AWSCognitoCredentialsProvider.init(regionType: .EUWest2, identityPoolId: "us-west-2:9fac6644-6f9e-481a-b7a2-9ddd014a7167")
        
        let awSServiceConfiguration = AWSServiceConfiguration.init(region: .EUWest1, credentialsProvider: credentialProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = awSServiceConfiguration
        
        
        let fileName = "thumbnails/WZThumbnail\(HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id)).png"
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
            })
        }
        
        
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data!, bucket: AWSBucketKeys.AWSTHUMBNAILBUCKET, key: fileName, contentType: "image/*", expression: expression, completionHandler: completionHandler)
        
        
    }
    
    open class func uploadBusinessCardImage(image: UIImage, completion:@escaping (String?, Error) -> Void){
        
        let credentialProvider = AWSCognitoCredentialsProvider.init(regionType: .EUWest2, identityPoolId: "us-west-2:9fac6644-6f9e-481a-b7a2-9ddd014a7167")
        
        let awSServiceConfiguration = AWSServiceConfiguration.init(region: .EUWest1, credentialsProvider: credentialProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = awSServiceConfiguration
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormats.DateFormatForImages
        let result = formatter.string(from: date)

        
        
        let fileName = "thumbnails/WZCard\(result).png"
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
            })
        }

        
        
        let transferUtility = AWSS3TransferUtility.default()
        transferUtility.uploadData(data!, bucket: AWSBucketKeys.AWSTHUMBNAILBUCKET, key: fileName, contentType: "image/*", expression: expression, completionHandler: completionHandler)
        
        
    }
    
}