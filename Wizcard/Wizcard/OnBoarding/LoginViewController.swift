//
//  LoginViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 19/02/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import CountryPicker

class LoginViewController: UIViewController, CountryPickerDelegate {

    @IBOutlet weak var picker: CountryPicker!
    @IBOutlet weak var showCountryButtonOutlet: UIButton!
    
    @IBOutlet weak var countryPickerParent: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
//        picker.displayOnlyCountriesWithCodes = ["DK", "SE", "NO", "DE"] //Optional, must be set before showing
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry(code!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        showCountryButtonOutlet.setTitle(phoneCode, for: .normal)
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
    
    
}
