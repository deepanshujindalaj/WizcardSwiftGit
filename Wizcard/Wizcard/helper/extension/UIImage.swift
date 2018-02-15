//
//  UIImage.swift
//  EZER
//
//  Created by TimerackMac1 on 05/12/17.
//  Copyright © 2017 TimerackMac1. All rights reserved.
//

import UIKit
extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func convertImageToBase64(quality : CGFloat = 0.7,imageFormat : ImageFormat = ImageFormat.jpeg)->String
    {
        var imageData : Data!
        switch imageFormat {
        case .jpeg:
            imageData = UIImageJPEGRepresentation(self, quality)!
        case .png:
            imageData = UIImagePNGRepresentation(self)!
        }
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    enum ImageFormat
    {
        case png
        case jpeg
    }
}
