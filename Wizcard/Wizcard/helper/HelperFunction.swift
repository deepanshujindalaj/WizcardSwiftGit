//
//  HelperFunction.swift
//  EZER
//
//  Created by TimerackMac1 on 23/11/17.
//  Copyright © 2017 TimerackMac1. All rights reserved.
//

import UIKit
import CoreLocation
open class HelperFunction {
    
    
    /// Descritpion
    ///
    /// - Parameter key: preferences key
    /// - Returns: Returns value for key. if key not found returns empty value
    open class func  getSrtingFromUserDefaults(key : String) -> String
    {
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
    /// Descritpion
    ///
    /// - Parameters:
    ///   - key: String key for pref
    ///   - value: data to be save in pref
    open class func  saveValueInUserDefaults(key : String, value: Any)
    {
        return UserDefaults.standard.set(value, forKey: key)
    }
    
    
    open class func  getBooleanFromUserDefaults(key : String) -> Bool
    {
        return UserDefaults.standard.bool(forKey: key)
    }
    /// Descritpion
    ///
    /// - Parameters:
    ///   - key: String key for pref
    ///   - value: data to be save in pref
    open class func  saveBooleanValueInUserDefaults(key : String, value: Any)
    {
        return UserDefaults.standard.set(value, forKey: key)
    }
    
    
    
    open class func validateEmail(email:String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    open class func isValidZip(testStr:String) -> Bool {
        // print("validate calendar: \(ftestStr)")
        let statusCode = "\\d{5}"
        let code = NSPredicate(format:"SELF MATCHES %@", statusCode)
        return code.evaluate(with: testStr)
    }
    /// get file name from url
    ///
    /// - Parameter stringUrl: url from which file name to extracted
    open class func getFileNameFromUrl(stringUrl : String)-> String
    {
        if let url = URL(string: stringUrl) {
            //let withoutExt = url.deletingPathExtension()
            //let name = withoutExt.lastPathComponent
            let name = url.lastPathComponent
            return name
            //let result = name.substring(from: name.index(name.startIndex, offsetBy: 5))
            
        }
        return ""
    }
    
    
    open class func convertImageToBase64() -> String
    {
        let image : UIImage = UIImage(named:"ic_user")!
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        var strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        strBase64 = "data:image/jpeg;base64,\(strBase64)"
        return strBase64
    }
    
    
    open class func isValidPhoneNumber(testStr:String) -> Bool {
        if(testStr.length > 14)
        {
            return false
        }
        return true
        //        let statusCode = "^(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$"
        //        let code = NSPredicate(format:"SELF MATCHES %@", statusCode)
        //        return code.evaluate(with: testStr)
    }
    
//    open class func getUserName(loginType:LoginType)->String {
//        var firstName = HelperFunction.getSrtingFromUserDefaults(key: DriverProfileKeys.firstName)
//        var lastName = HelperFunction.getSrtingFromUserDefaults(key: DriverProfileKeys.lastName)
//
//        if(loginType == .customer)
//        {
//            firstName = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.first_name)
//            lastName = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.first_name)
//        }
//
//        return "\(firstName) \(lastName)"
//
//    }
    
//    open class func getUserId()->String {
//
//        var userId :  String! = ""
//        if LoginType.customer.rawValue == HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.profileType)
//        {
//            userId = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.Id)
//        }
//        else if LoginType.driver.rawValue == HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.profileType){
//            userId = HelperFunction.getSrtingFromUserDefaults(key: DriverProfileKeys.id)
//        }
//        return userId
//
//    }
    
//    open class func getUserInitials(loginType:LoginType)->String {
//        var firstName = HelperFunction.getSrtingFromUserDefaults(key: DriverProfileKeys.firstName)
//        var lastName = HelperFunction.getSrtingFromUserDefaults(key: DriverProfileKeys.lastName)
//
//        if(loginType == .customer)
//        {
//            firstName = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.first_name)
//            lastName = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.last_name)
//        }
//
//        return "\(firstName.firstCharacter())\(lastName.firstCharacter())"
//    }

    
//    +(NSDate *)getProperDateFromString:(NSString *)date{
//    NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
//    [objDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
//    NSTimeZone *tz = [NSTimeZone localTimeZone];
//    [objDateFormatter setTimeZone:tz];
//    NSDate *dateNew = [objDateFormatter dateFromString:date];
//
//
//    [objDateFormatter setTimeZone:tz];
//    [objDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//    NSString *newDateString = [objDateFormatter stringFromDate:dateNew];
//    dateNew = [objDateFormatter dateFromString:newDateString];
//
//    return dateNew;
//    }
    
    class func getProperDateFromString(dateString : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        var date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MMM dd yyyy hh:mm:ss a"
        dateFormatter.timeZone = TimeZone.current
        
        let string = dateFormatter.string(from: date!)
        date = dateFormatter.date(from: string)
        
        return date!
    }
    
    class func getStartMonthDate(dateString : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MMM dd"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: date!)
    }
    
    class func getEndDateAndYear(dateString : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd, yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: date!)
    }
    
    
    class func getCurrentFullDate(date : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateFormatter.string(from: dt!)
    }
    
    class func getCurrentDate(date : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM dd, yyyy - EEEE"
        return dateFormatter.string(from: dt!)
    }
    class func getCurrentDateWithoutDayName(date : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: dt!)
    }
    class func getTime(date : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: dt!)
    }
    
    
    class func getDateComponent(date : Date) -> DateModel
    {
        let dateModel = DateModel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.string(from: date).capitalized
        dateModel.dayName = dayName
        dateFormatter.dateFormat = "MMM, yyyy"
        let monthYear = dateFormatter.string(from: date).capitalized
        dateModel.monthAndYear = monthYear
        
        dateFormatter.dateFormat = "MMM dd"
        let monthWithDate = dateFormatter.string(from: date).capitalized
        dateModel.monthWithDate = monthWithDate
        
        dateFormatter.dateFormat = "dd"
        let dayOfMonth = dateFormatter.string(from: date).capitalized
        dateModel.dayOfMonth = dayOfMonth
        dateFormatter.dateFormat = "hh:mm"
        let time = dateFormatter.string(from: date).capitalized
        dateModel.time = time
        dateFormatter.dateFormat = "a"
        let amORPM = dateFormatter.string(from: date).capitalized
        dateModel.amOrPM = amORPM
        return dateModel
    }
    class func createAttributedString(_ startText : String, textSize: CGFloat ,textColor: UIColor )-> NSAttributedString
    {
        let attributes :[NSAttributedStringKey:Any] = [NSAttributedStringKey.font: UIFont(name: FontNames.medium, size: textSize) as Any,NSAttributedStringKey.foregroundColor: textColor]
        let mutableAttributedString = NSMutableAttributedString(string:startText,attributes: attributes)
        return mutableAttributedString
    }
    class func openMailApp(email: String)
    {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    class func distanceInMeters(_ start :CLLocationCoordinate2D ,destination : CLLocationCoordinate2D) -> CLLocationDistance {
        let firstLoc = CLLocation(latitude: start.latitude, longitude: start.longitude)
        let secondLoc = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        return firstLoc.distance(from: secondLoc)
    }
    class func callToNumber(number : String )
    {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    class func isValidNumber(testStr:String) -> Bool {
        let statusCode = "^(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$"
        let code = NSPredicate(format:"SELF MATCHES %@", statusCode)
        return code.evaluate(with: testStr)
    }
    
    class func isValidateUrl(isValidUrl : String) -> Bool{
        let urlRegEx = "http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?"
        let code = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return code.evaluate(with: isValidUrl)
    }
    

    class func extractVideoID(url :String) -> String{
        
        let regExp = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try! NSRegularExpression(pattern: regExp, options: .caseInsensitive)
        let match = regex.matches(in: url, options: [], range: NSRange(location: 0, length: url.length))
        if match.count > 0{
            let nsLink = url as NSString
            if let firstMatch = match.first {
                return nsLink.substring(with: firstMatch.range)
            }
        }
        
        return ""
    }
    
    
    class func clearUserDefault()
    {
        let appDomain = Bundle.main.bundleIdentifier!
        let profileToken = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.deviceToken)
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        HelperFunction.saveValueInUserDefaults(key: ProfileKeys.deviceToken, value: profileToken)
    }
    
    class func getBannerMediaList(arrayList : [Media]?) -> [Media]?
    {
        var mediaArray = [Media]()
        if arrayList != nil {
            for mediaItem in (arrayList)!{
                if mediaItem.media_sub_type == MediaTypes.BNR{
                    mediaArray.append(mediaItem)
                }
            }
        }
        return mediaArray
    }
    
    class func getLGOMedia(arrayList : [Media]?) -> Media?
    {
        var media : Media? = nil
        if arrayList != nil {
            for mediaItem in (arrayList)!{
                if mediaItem.media_sub_type == MediaTypes.LGO{
                    media = mediaItem
                    break
                }
            }
        }
        return media
    }
    
    class func getWizcardThumbnail(arrayList : [Media]?) -> Media?
    {
        var media : Media? = nil
        if arrayList != nil {
            for mediaItem in (arrayList)!{
                if mediaItem.media_sub_type == MediaTypes.THB{
                    media = mediaItem
                    break
                }
            }
        }
        return media
    }
    
    class func getWizcardVideo(arrayList : [Media]?) -> Media?
    {
        var media : Media? = nil
        if arrayList != nil {
            for mediaItem in (arrayList)!{
                if mediaItem.media_sub_type == MediaTypes.ROL{
                    media = mediaItem
                    break
                }
            }
        }
        return media
    }
    
}
