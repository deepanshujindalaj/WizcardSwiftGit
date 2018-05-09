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
import TwitterKit


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
    var scannedImage : UIImage!
    var profileImage : UIImage!
    var videoThumbnailURL : String!
    var businessCardUrl : String!
    var profileImageUrl : String!
    var extFields : [ExtFields]!
    var clickImageType = ClickImageType.SELFIMAGE_CLICKED
    var screenOpenFrom = EditProfileFrom.ONBOARDING
    
    let heightOfOcrVideoThumbnail           =   225.0
    let heightOfOcrVideoWithoutThumbnail    =   116.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        phoneNumber.text    =   HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.phone)
        if wizcard != nil {
            firstName.text      =   wizcard.firstName;
            lastName.text       =   wizcard.lastName;
            email.text          =   wizcard.email
            let contactConainers =  wizcard.contactContainers?.allObjects as! [ContactContainer]
            
            companyName.text    =   contactConainers[0].company
            titleName.text      =   contactConainers[0].title
            if let mediaSet     =   contactConainers[0].media{

                let media       =   mediaSet.allObjects as! [Media]
                if media.count > 0{
                    if let picUrl = URL(string:media[0].media_element!)
                    {
                        ocrImageView.af_setImage(withURL:  picUrl)
                        self.ocrCardHeight.constant = CGFloat(heightOfOcrVideoThumbnail);
                    }
                }
                
            }
            
            extFields           =   wizcard.extfields?.allObjects as! [ExtFields]
            
            let filteredArrayAboutMe   =   extFields.filter() { $0.key == SocialMedia.ABOUTME }
            
            if filteredArrayAboutMe.count > 0{
                let extField    =   filteredArrayAboutMe[0]
                aboutME.text    =   extField.value
            }
            
            let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }
            
            if filteredArrayLinkedInArray.count > 0{
                linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedindelete"), for: .normal)
            }
            
            
            let filteredArrayFacebookArray   =   extFields.filter() { $0.key == SocialMedia.FACEBOOK }
            
            if filteredArrayFacebookArray.count > 0{
                facebookButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "facebookdelete"), for: .normal)
            }
            
            let filteredArrayTwitterArray   =   extFields.filter() { $0.key == SocialMedia.TWITTER }
            
            if filteredArrayTwitterArray.count > 0{
                twitterButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "twitterdelete"), for: .normal)
            }
            
            
            
            
            if let media = HelperFunction.getWizcardThumbnail(arrayList: wizcard.media?.allObjects as? [Media]){
                if let picUrl = URL(string:media.media_element!)
                {
                    profileImageUrl = media.media_element
                    profilePicOutlet.af_setImage(withURL:  picUrl)
                }
            }
        }else{
           extFields = [ExtFields]()
        }
        
        setTextDelegate()
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

    func setTextDelegate(){
        
        firstName.addTarget(lastName, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        
        lastName.addTarget(companyName, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        
        companyName.addTarget(titleName, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        
        titleName.addTarget(email, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        
        email.addTarget(website, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
        
        website.addTarget(aboutME, action: #selector(becomeFirstResponder), for: .editingDidEndOnExit)
    }
    
    
    @IBAction func linkedInButtonClicked(_ sender: Any) {
            let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }
            
            if filteredArrayLinkedInArray.count > 0{
                extFields.remove(at: extFields.index(of: filteredArrayLinkedInArray[0])!)
                linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedinadd"), for: .normal)
            }else{
                SocialMediaManager.processLinkedAccount(viewController: self) { (wizcardLocal) in
                    let extFields       =   wizcardLocal?.extfields?.allObjects as! [ExtFields]
                    let filteredArrayLinkedInArray   =   extFields.filter() { $0.key == SocialMedia.LINKEDIN }

                    if filteredArrayLinkedInArray.count > 0{
                        self.extFields.append(filteredArrayLinkedInArray[0])
                        self.linkedButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "linkedindelete"), for: .normal)
                    }
                }
            }
    }
    
    
    
    @IBAction func twitterButtonClicked(_ sender: Any) {
        
        let filteredArrayTwitterArray   =   extFields.filter() { $0.key == SocialMedia.TWITTER }
        if filteredArrayTwitterArray.count > 0 {
            extFields.remove(at: extFields.index(of: filteredArrayTwitterArray[0])!)
            twitterButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "twitteradd"), for: .normal)
        }else{
            // Swift
            TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
                if (session != nil) {

                    let extField = ExtFieldManager.extFieldManager.getAllocatedExtFieldsUnAssociated(isUnAssociate: true)
                    extField.key    =   SocialMedia.TWITTER
                    extField.value  =   "https://twitter.com/\(session?.userName ?? "")"
                    self.extFields.append(extField)
                    self.twitterButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "twitterdelete"), for: .normal)
                } else {
                    print("error: \(String(describing: error?.localizedDescription))");
                }
            })
        }
    }
    
    @IBAction func facebookButtonClicked(_ sender: Any) {
        
        let filteredArrayFacebookArray   =   extFields.filter() { $0.key == SocialMedia.FACEBOOK }
        if filteredArrayFacebookArray.count > 0 {
            extFields.remove(at: extFields.index(of: filteredArrayFacebookArray[0])!)
            facebookButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "facebookadd"), for: .normal)
        }else{
            let loginManager = FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: [ "email", "public_profile" ], from: self) { (loginResult, error) in
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = loginResult!
                    if fbloginresult.grantedPermissions != nil {
                        self.showProgressBar()
                        if(fbloginresult.grantedPermissions.contains("email")) {
                            if((FBSDKAccessToken.current()) != nil){
                                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, link ,picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                    if (error == nil){
                                        
                                        let dict = result as! [String : AnyObject]
                                        let extField = ExtFieldManager.extFieldManager.getAllocatedExtFieldsUnAssociated(isUnAssociate: true)
                                        print("\(dict)")
                                        extField.key    =   SocialMedia.FACEBOOK
                                        extField.value  =   dict["link"] as? String
                                        self.extFields.append(extField)
                                        self.facebookButtonOutlet.setBackgroundImage(#imageLiteral(resourceName: "facebookdelete"), for: .normal)
                                        self.hideProgressBar()
                                    }
                                })
                            }
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
        else if !HelperFunction.validateEmail(email: email.text!){
            showMessage(ValidationMessages.invalidEmail, type: .info)
            isValid = false
        }
        return isValid
    }
    
    
    func uploadBusinessCard(){
        showProgressBar()
        if scannedImage != nil {
            CommonFunction.uploadBusinessCardImage(image: scannedImage, completion: { (url, error) in
                self.businessCardUrl = url
                self.uploadProfileImage()
            })
        }else{
            uploadProfileImage()
        }
    }
    
    func uploadProfileImage(){
        if profileImage != nil{
            CommonFunction.uploadProfileImage(image: profileImage, completion: { (url, error) in
                self.profileImageUrl = url
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
        
        if aboutME.text?.length != 0 {
            let filteredArrayAboutMe   =   extFields.filter() { $0.key == SocialMedia.ABOUTME }
            
            if filteredArrayAboutMe.count > 0{
                let extField    =   filteredArrayAboutMe[0]
                extField.value  =   aboutME.text
            }else{
                let extField    =   ExtFieldManager.extFieldManager.getAllocatedExtFieldsUnAssociated(isUnAssociate: true)
                extField.key    =   SocialMedia.ABOUTME
                extField.value  =   aboutME.text
                extFields.append(extField)
            }
        }
        
        var extFieldsDic = [String : Any]()
        for extField in extFields {
            extFieldsDic[extField.key!]  =   extField.value
        }
        params[ProfileKeys.ext_fields] = extFieldsDic
        
        
        if embedVideoLinkTextField.text?.length != 0 {
            params[ProfileKeys.video_url]           =   embedVideoLinkTextField.text!
            params[ProfileKeys.video_thumbnail_url] =   videoThumbnailURL;
        }
        
        
        var mediaArray = Array<Any>()
        if profileImageUrl != nil{
            var media = [String : Any]()
            media = [
                MediaKeys.media_element : profileImageUrl,
                MediaKeys.media_iframe : "",
                MediaKeys.media_sub_type : MediaTypes.THB,
                MediaKeys.media_type : MediaTypes.IMG
            ]
            mediaArray.append(media)
            params[ProfileKeys.media] = mediaArray
        }else{
            
            params[ProfileKeys.media] = mediaArray
        }

        var contactContainerMediaArray = Array<Any>()
        if businessCardUrl != nil{
            var media = [String : Any]()
            media = [
                MediaKeys.media_element : businessCardUrl,
                MediaKeys.media_iframe : "",
                MediaKeys.media_sub_type : MediaTypes.FBZ,
                MediaKeys.media_type : MediaTypes.IMG
            ]
            contactContainerMediaArray.append(media)
        }
        
        
        
        
        var contactContainerArray = Array<Any>()
        var contactContainer : [String: Any] = [
            ContactContainerKeys.title      : titleName.text!,
            ContactContainerKeys.company    : companyName.text!
        ]
        if contactContainerMediaArray.count > 0{
            contactContainer[ProfileKeys.media] = contactContainerMediaArray
        }
        contactContainerArray.append(contactContainer)
        params[ProfileKeys.contact_container] = contactContainerArray
        
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForEdit_Card, jsonToPost: params) { (json) in
            
            if let json = json{
                if json[ServerKeys.data].exists(){
                    let data = json[ServerKeys.data]
                    if data[ProfileKeys.wizcard].exists(){
                        let wizcardJSON = data[ProfileKeys.wizcard]
                        let wizcard = WizcardManager.wizcardManager.populateWizcardFromServerNotif(wizcard: wizcardJSON, createUnAssociate: false)
                        wizcard.userId = HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id)
                        HelperFunction.saveValueInUserDefaults(key: ProfileKeys.wizcard_id, value: wizcard.wizcard_id ?? 0)
                        self.wizcard = wizcard
                        WizcardManager.wizcardManager.saveContext()
                    }
                }
            }
            
            
            if self.screenOpenFrom == EditProfileFrom.ONBOARDING{
                let storyboard = UIStoryboard(name: StoryboardNames.LandingScreen, bundle: nil)
                let landingScreenViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.LandinScreen.landingScreen) as! LandingScreenViewController
                self.navigationController?.pushViewController(landingScreenViewController, animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
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
            
            let fcImageCaptureViewController = FCImageCaptureViewController()
            fcImageCaptureViewController.delegate = self
            fcImageCaptureViewController.onlyDisplayTheImagePicker = true
            self.present(fcImageCaptureViewController, animated: true, completion: nil)
            
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
        dismiss(animated: true, completion: nil)
    }
    
    func imageCapture(_ controller: FCImageCaptureViewController!, capturedImage image: UIImage!) {
        
        if clickImageType == ClickImageType.BUSINESSCARD_IMAGECLICK {
            updateBusinessCardImage(image: image)
            dismiss(animated: true, completion: nil)
        }else{
            
            dismiss(animated: true, completion: nil)
            let circleCropController = KACircleCropViewController(withImage: image)
            circleCropController.delegate = self
            present(circleCropController, animated: false, completion: nil)
        }
        
    }
    
    
}

