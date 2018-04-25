//
//  CreateProfileScreenViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 17/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import AlamofireImage

class CreateProfileScreenViewController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var profilePicOutlet: UIImageView!
    @IBOutlet weak var facebookButtonOutlet: UIButton!
    @IBOutlet weak var twitterButtonOutlet: UIButton!
    @IBOutlet weak var linkedButtonOutlet: UIButton!
    @IBOutlet weak var aboutME: UITextField!
    @IBOutlet weak var website: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    var wizcard : Wizcard!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        if wizcard != nil {
            firstName.text      =   wizcard.firstName;
            lastName.text       =   wizcard.lastName;
            email.text          =   wizcard.email
            let contactConainers =  wizcard.contactContainers?.allObjects as! [ContactContainer]
            
            companyName.text    =   contactConainers[0].company
            titleName.text      =   contactConainers[0].title
            phoneNumber.text    =   HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.phone)
            
            let extFields       =   wizcard.extfields?.allObjects as! [ExtFields]
            
            let filteredArrayAboutMe   =   extFields.filter() { $0.key == SocialMedia.ABOUTME }
            
            if filteredArrayAboutMe.count > 0{
                let extField    =   filteredArrayAboutMe[0]
                aboutME.text    =   extField.value
            }
            
            let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }
            
            if filteredArrayLinkedInArray.count > 0{
                linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedindelete"), for: .normal)
            }
            
            
            if let media = HelperFunction.getWizcardThumbnail(arrayList: wizcard.media?.allObjects as? [Media]){
                if let picUrl = URL(string:media.media_element!)
                {
                    profilePicOutlet.af_setImage(withURL:  picUrl)
                }
            }
        }else{
            
        }
        
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
        if wizcard.extfields != nil {
            var extFields       =   wizcard.extfields?.allObjects as! [ExtFields]
            
            let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }
            
            if filteredArrayLinkedInArray.count > 0{
                extFields.remove(at: extFields.index(of: filteredArrayLinkedInArray[0])!)
                wizcard.extfields = NSSet(array : extFields)
                linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedinadd"), for: .normal)
            }else{
                
                SocialMediaManager.processLinkedAccount(viewController: self) { (wizcardLocal) in
                    let extFields       =   wizcardLocal?.extfields?.allObjects as! [ExtFields]
                    let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }

                    if filteredArrayLinkedInArray.count > 0{
                        var extFieldsGlobalWizcard       =   self.wizcard.extfields?.allObjects as! [ExtFields]
                        extFieldsGlobalWizcard.append(filteredArrayLinkedInArray[0])
                        self.wizcard.extfields = NSSet(array : extFieldsGlobalWizcard)
                        self.linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedindelete"), for: .normal)
                    }
                }
            }
        }
    }
    @IBAction func twitterButtonClicked(_ sender: Any) {
        
    }
    @IBAction func facebookButtonClicked(_ sender: Any) {
        
    }
    
    
    @IBAction func addProfileImageButtonClicked(_ sender: Any) {
        showActionSheet()
    }
    
    @objc func showActionSheet()
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select Mode", message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        let cancelActionButton = UIAlertAction(title: "Close", style: .cancel) { _ in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            self.checkCameraPermission(completion: { (action) in
                if action {
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                        self.imagePicker.allowsEditing = false
                        self.imagePicker.sourceType = .camera
                        self.imagePicker.cameraDevice = .front
                        self.imagePicker.cameraCaptureMode = .photo
                        self.imagePicker.modalPresentationStyle = .fullScreen
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                }
                else{
                    self.showCameraAlert()
                }
            })
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let galleryActionButton = UIAlertAction(title: "Gallery", style: .default)
        { _ in
            self.imagePicker = UIImagePickerController()
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.imagePicker.modalPresentationStyle = .popover
            self.imagePicker.popoverPresentationController?.sourceView = self.view
            self.imagePicker.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            self.imagePicker.popoverPresentationController?.permittedArrowDirections = []
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        actionSheetControllerIOS8.addAction(galleryActionButton)
        actionSheetControllerIOS8.popoverPresentationController?.sourceView = self.profilePicOutlet
        actionSheetControllerIOS8.popoverPresentationController?.sourceRect = self.profilePicOutlet.bounds
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
}


extension CreateProfileScreenViewController : UIImagePickerControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let circleCropController = KACircleCropViewController(withImage: image)
            circleCropController.delegate = self
            present(circleCropController, animated: false, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.showMessage("Picture selection cancelled", type: .error)
    }
}

extension CreateProfileScreenViewController: KACircleCropViewControllerDelegate {
    
    func circleCropDidCancel(){
        //Basic dismiss
        dismiss(animated: false, completion: nil)
    }
    
    func circleCropDidCropImage(_ image: UIImage) {
        //Same as dismiss but we also return the image
        
        profilePicOutlet.image = image
        //var data = image.convertImageToBase64(quality: 0.7, imageFormat: .png)
        //data = "data:image/png;base64,\(data)"
        dismiss(animated: false, completion: nil)
//        uploadImageToServer(image: image)
    }
}

