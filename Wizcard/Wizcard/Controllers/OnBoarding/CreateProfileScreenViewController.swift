//
//  CreateProfileScreenViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 17/04/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import FacebookCore
import FBSDKLoginKit


enum ClickImageType : Int{
    case SELFIMAGE_CLICKED = 0
    case BUSINESSCARD_IMAGECLICK
}


class CreateProfileScreenViewController: UIViewController, UINavigationControllerDelegate{

    @IBOutlet weak var videoThumbnailImageViewOutlet: UIImageView!
    @IBOutlet weak var deleteVideoThumbnailVideoButtonOutlet: UIButton!
    @IBOutlet weak var imageViewParent: UIView!
    @IBOutlet weak var videoImageHeightLayoutConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var videoActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var embedVideoLinkTextField: UITextField!
    @IBOutlet weak var ocrCardHeight: NSLayoutConstraint!
    @IBOutlet weak var ocrImageView: UIImageView!
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
    var scannedImage : UIImage!
    var profileImage : UIImage!
    var videoThumbnailURL : String!
    
    var clickImageType = ClickImageType.SELFIMAGE_CLICKED
    
    let heightOfOcrVideoThumbnail           =   225.0
    let heightOfOcrVideoWithoutThumbnail    =   116.0
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: [ "email", "public_profile" ], from: self) { (loginResult, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = loginResult!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((FBSDKAccessToken.current()) != nil){
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                    let dict = result as! [String : AnyObject]
                                    print(result!)
                                    print(dict)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func addProfileImageButtonClicked(_ sender: Any) {
        clickImageType = ClickImageType.SELFIMAGE_CLICKED
        showActionSheetCardImage()
    }
    
    @IBAction func addBusinessImageClicked(_ sender: Any) {
        clickImageType = ClickImageType.BUSINESSCARD_IMAGECLICK
        showActionSheetCardImage()
    }
    
    func showVideoThumbnailProcessingView(){
        videoActivityIndicator.startAnimating()
        self.imageViewParent.isHidden                           = false
        self.videoImageHeightLayoutConstraintOutlet.constant    = CGFloat(heightOfOcrVideoThumbnail);
    }
    
    func hideVideoThumbnail(){
        videoThumbnailURL                                       = nil
        self.videoImageHeightLayoutConstraintOutlet.constant    = CGFloat(heightOfOcrVideoWithoutThumbnail)
        self.imageViewParent.isHidden                           = true
        self.videoThumbnailImageViewOutlet.image                = nil
        self.deleteVideoThumbnailVideoButtonOutlet.isHidden     = true
    }
    
    @IBAction func deleteVideoThumbnailClicked(_ sender: Any) {
        hideVideoThumbnail()
    }
    func downloadVideoThumbnail(url : String){
        videoThumbnailURL = url
        Alamofire.request(url).responseImage { response in
            if let image = response.result.value {
                self.displayVideoThumbnailImage(image: image)
            }
        }
    }
    func displayVideoThumbnailImage(image : UIImage){
        self.videoThumbnailImageViewOutlet.image = image
        videoActivityIndicator.stopAnimating()
        self.deleteVideoThumbnailVideoButtonOutlet.isHidden       = false
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if !isValid() {
            return
        }
        uploadBusinessCard()
    }
    
    func isValid() -> Bool{
        var isValid = true
        
        if firstName.text?.length == 0{
            showMessage(ValidationMessages.invalidFirstName, type: .info)
            isValid = false
        }else if lastName.text?.length == 0{
            showMessage(ValidationMessages.invalidLastName, type: .info)
            isValid = false
        }else if companyName.text?.length == 0{
            showMessage(ValidationMessages.invalidCompanyName, type: .info)
            isValid = false
        }
        else if titleName.text?.length == 0{
            showMessage(ValidationMessages.invalidDesignationName, type: .info)
            isValid = false
        }
        else if email.text?.length == 0{
            showMessage(ValidationMessages.invalidEmail, type: .info)
            isValid = false
        }
        else if HelperFunction.validateEmail(email: email.text!){
            showMessage(ValidationMessages.invalidEmail, type: .info)
            isValid = false
        }
        return isValid
    }
    
    
    func uploadBusinessCard(){
        if scannedImage != nil {
            CommonFunction.uploadBusinessCardImage(image: scannedImage, completion: { (url, error) in
                self.uploadProfileImage()
            })
        }else{
            uploadProfileImage()
        }
    }
    
    func uploadProfileImage(){
        if profileImage != nil{
            CommonFunction.uploadProfileImage(image: profileImage, completion: { (url, error) in
                self.uploadProfile()
            })
        }else{
            uploadProfile()
        }
    }
    
    func uploadProfile(){
        var params : [String:Any] = [
            ProfileKeys.first_name  :   firstName.text!,
            ProfileKeys.last_name   :   lastName.text!,
            CommonKeys.email        :   email.text!,
            CommonKeys.phone        :   phoneNumber.text!,
            ProfileKeys.wizuser_id  :   HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id),
            ProfileKeys.user_id     :   HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id)
        ]
        
        if embedVideoLinkTextField.text?.length != 0 {
            params[ProfileKeys.video_url]           =   embedVideoLinkTextField.text!
            params[ProfileKeys.video_thumbnail_url] =   videoThumbnailURL;
        }
        
        var contactContainerArray = Array<Any>()
        let contactContainer : [String: Any] = [
            ContactContainerKeys.title      : titleName.text!,
            ContactContainerKeys.company    : companyName.text!
        ]
        contactContainerArray.append(contactContainer)
        params[ProfileKeys.contact_container] = contactContainerArray
        
    }
    
    @IBAction func videoDoneButtonClicked(_ sender: Any) {
        if embedVideoLinkTextField.text?.length != 0 {
            
            if HelperFunction.isValidateUrl(isValidUrl: embedVideoLinkTextField.text!){
                if (embedVideoLinkTextField.text?.contains("youtube"))! || (embedVideoLinkTextField.text?.contains("youtu.be"))!{
                    let videoID = HelperFunction.extractVideoID(url: embedVideoLinkTextField.text!)
                    print("\(videoID)")
                    showVideoThumbnailProcessingView()
                    let url = "http://img.youtube.com/vi/\(videoID)/0.jpg"
                    downloadVideoThumbnail(url: url)
                }
            }
            
        }else{
            showMessage(ValidationMessages.invalidVideoLink, type: .info)
        }
    }
    
    func updateBusinessCardImage(image : UIImage){
        scannedImage           = image;
        self.ocrCardHeight.constant = CGFloat(heightOfOcrVideoThumbnail);
        ocrImageView.image     = scannedImage
    }
    
    func clearBusinesscardImage(){
        self.scannedImage = nil;
        self.ocrCardHeight.constant = CGFloat(heightOfOcrVideoWithoutThumbnail);
        self.ocrImageView.image = nil;
    }
    
    func clearProfileImage(){
        self.profileImage = nil;
        self.profilePicOutlet.image = #imageLiteral(resourceName: "createProfilePlaceholder");
    }


    
    
    @objc func showActionSheetCardImage()
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select Mode", message: nil, preferredStyle:UIAlertControllerStyle.actionSheet)
        let cancelActionButton = UIAlertAction(title: "Close", style: .cancel) { _ in
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            self.checkCameraPermission(completion: { (action) in
                if action {
                    
                    let fcImageCaptureViewController = FCImageCaptureViewController()
                    fcImageCaptureViewController.delegate = self
                    if self.clickImageType == ClickImageType.SELFIMAGE_CLICKED{
                        fcImageCaptureViewController.isSelfPicture = true
                    }
                    self.present(fcImageCaptureViewController, animated: true, completion: nil)
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
        
        
        let clearActionButton = UIAlertAction(title: "Clear", style: .default)
        { _ in
                self.clearBusinesscardImage()
        }
        actionSheetControllerIOS8.addAction(clearActionButton)
        
        
        
        
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
        profileImage = image
        profilePicOutlet.image = image
        dismiss(animated: false, completion: nil)
//        uploadImageToServer(image: image)
    }
}


extension CreateProfileScreenViewController : FCImageCaptureViewControllerDelegate{
   
    func imageCaptureControllerCancelledCapture(_ controller: FCImageCaptureViewController!) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imageCapture(_ controller: FCImageCaptureViewController!, capturedImage image: UIImage!) {
        
        if clickImageType == ClickImageType.BUSINESSCARD_IMAGECLICK {
            updateBusinessCardImage(image: image)
            controller.dismiss(animated: true, completion: nil)
        }else{
            
            controller.dismiss(animated: true, completion: nil)
            
            let circleCropController = KACircleCropViewController(withImage: image)
            circleCropController.delegate = self
            present(circleCropController, animated: false, completion: nil)
        }
        
    }
    
    
}

