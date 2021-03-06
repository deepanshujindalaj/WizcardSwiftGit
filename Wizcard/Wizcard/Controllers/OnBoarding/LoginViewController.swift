//
//  LoginViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 19/02/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import CountryPicker
import CoreLocation

class LoginViewController: UIViewController, CountryPickerDelegate {

    @IBOutlet weak var picker: CountryPicker!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var showCountryButtonOutlet: UIButton!
    @IBOutlet weak var countryPickerParent: UIView!
    @IBOutlet weak var phoneNumber: UITextField!
    var locationManager : LocationManager!
    var phoneCode : String = ""
    var isProcessingFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        locationManager = LocationManager(delegate:self)
        locationManager.requestAutorizationWhenInUse();
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
//        picker.displayOnlyCountriesWithCodes = ["DK", "SE", "NO", "DE"] //Optional, must be set before showing
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry(code!)
        showCountryButtonOutlet.setTitle(phoneCode, for: .normal)
        
        HelperFunction.saveValueInUserDefaults(key: "", value: UIDevice.current.identifierForVendor!.uuidString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination is LoginScreenSliderViewPager {
            let loginPageSlider = segue.destination as! LoginScreenSliderViewPager
            loginPageSlider.delegateProperty = self
            
        }
    }
    
    
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        
        self.phoneCode = phoneCode;
        
        if isProcessingFirstTime{
            isProcessingFirstTime = false
            showCountryButtonOutlet.setTitle(self.phoneCode, for: .normal)
        }
    }
    
    @IBAction func selectCountryButtonClicked(_ sender: Any) {
        if countryPickerParent.isHidden {
            countryPickerParent.isHidden = false
        }
        else
        {
            countryPickerParent.isHidden = true
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        countryPickerParent.isHidden = true
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        showCountryButtonOutlet.setTitle(phoneCode, for: .normal)
        countryPickerParent.isHidden = true
    }
    
    @IBAction func verifyButtonClicked(_ sender: Any) {
        
        if !isValid(){
            return
        }
        
        let target = showCountryButtonOutlet.currentTitle! + phoneNumber.text!
        let userName = target + "@wizcard.com"

        let params :[String:Any] = [
            "response_mode":"sms",
            "target":target,
            "username": userName
        ]
        
        
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForPhone_Check_Request, jsonToPost: params) { (json) in
            
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
                    let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.confirmViewController) as! ConfirmViewController
                    confirmViewController.phoneNumber = target
                    HelperFunction.saveValueInUserDefaults(key: ProfileKeys.phone, value: target)
                    
                    self.navigationController?.pushViewController(confirmViewController, animated: true)
                }
            }
        }
    }
    
    
    func isValid() -> Bool{
        var isValid = true
        if phoneNumber.text?.length == 0{
            showMessage(ValidationMessages.invalidPhone, type: .info)
            isValid = false
        }
        return isValid
    }

    
}


extension LoginViewController : LoginScreenSliderViewPagerDelegate
{
    func currentSelectedIndex(index: Int) {
        pageControl.currentPage = index
    }
}


extension LoginViewController : LocationManagerDelegate
{
    func locationDenied() {
        
    }
    
    func didChangeinLocation(cordinate: CLLocationCoordinate2D){
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func didErrorinLocation(error: Error){
        DispatchQueue.main.async {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func locationNotAvailable(){
        DispatchQueue.main.async {
            if let _ = self.presentedViewController { return }
//            self.showLocationAlert()
        }
    }
    
    func locationFaliedToUpdate(status:CLAuthorizationStatus)
    {
//        DispatchQueue.main.async {
//            self.showLocationAlert()
//        }
    }
    
}

