//
//  CreateProfileViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    @IBAction func linkedInButtonClicked(_ sender: Any) {
        SocialMediaManager.processLinkedAccount(viewController: self) { (wizcard) in
            if wizcard != nil{
                let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
                let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
                confirmViewController.wizcard = wizcard
                self.navigationController?.pushViewController(confirmViewController, animated: true)
            }
        }
    }
    
    @IBAction func scanYourBusinessCardClicked(_ sender: Any) {
        
        let fcImageCaptureViewController = FCImageCaptureViewController()
        fcImageCaptureViewController.delegate = self
        fcImageCaptureViewController.onlyDisplayTheImagePicker = true
        self.present(fcImageCaptureViewController, animated: true, completion: nil)
        
    }
    @IBAction func enterManuallyClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
        let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
        
        
        self.navigationController?.pushViewController(confirmViewController, animated: true)
    }
}


extension CreateProfileViewController : FCImageCaptureViewControllerDelegate{
    
    func imageCaptureControllerCancelledCapture(_ controller: FCImageCaptureViewController!){
        dismiss(animated: true, completion: nil)
    }
    
    func imageCapture(_ controller: FCImageCaptureViewController!, capturedImage image: UIImage!){
        
        let imageString = convertImageToBase64(image: image)
        let params :[String:Any] = [
            ProfileKeys.kKeyForf_OCRCardImage:imageString,
            ProfileKeys.user_id : HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id),
            ProfileKeys.wizuser_id : HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id)
            
        ]
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForOCRSELF, jsonToPost: params) { (json) in
            print("\(String(describing: json))")
            
            if let json = json{
                if json[ServerKeys.data].exists(){
                    let data = json[ServerKeys.data]
                    if data["ocr_result"].exists(){
                        let wizcardJSON = data["ocr_result"]
                        let wizcard = WizcardManager.wizcardManager.populateWizcardFromServerNotif(wizcard: wizcardJSON, createUnAssociate: true)
                        
                        let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
                        let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
                        confirmViewController.wizcard = wizcard
                        self.navigationController?.pushViewController(confirmViewController, animated: true)
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = UIImagePNGRepresentation(image)
        let base64String = imageData?.base64EncodedString(options: .lineLength64Characters)
        return base64String!
    }
    
    
}
