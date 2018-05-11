//
//  RolodexL2ViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 06/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class RolodexL2ViewController: UIViewController {

    var wizcard : Wizcard!
    
    @IBOutlet weak var phoneNumberLblOutlet: UILabel!
    @IBOutlet weak var emailLblOutlet: UILabel!
    
    @IBOutlet weak var socialViewParent: CornerRadiousAndShadowView!
    @IBOutlet weak var socialMediaView: SocialMediaView!
    
    @IBOutlet weak var aboutmeLblOutlet: UILabel!

    @IBOutlet weak var profileButtonOutlet: UIButton!
    @IBOutlet weak var businesscardButtonOutlet: UIButton!
    @IBOutlet weak var videoButtonOutlet: UIButton!
    @IBOutlet weak var businessCardWidthOutletConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileWidthOutletConstraint: NSLayoutConstraint!
    @IBOutlet weak var videoViewConstraintOutlet: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewParentPropotational: UIView!
    @IBOutlet weak var profileCardView: UIView!
    @IBOutlet weak var videocardView: UIView!
    @IBOutlet weak var businessCardView: UIView!
    
    var rolodexPageViewController : RolodexPageViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(#imageLiteral(resourceName: "myprofile_edit"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
    
        
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        phoneNumberLblOutlet.text   =   wizcard.phone
        emailLblOutlet.text         =   wizcard.email
        socialMediaView.wizcard     =   wizcard
        socialMediaView.updateExtFields()
        
        let extFields           =   wizcard.extfields?.allObjects as! [ExtFields]
        
        let filteredArrayAboutMe   =   extFields.filter() { $0.key == SocialMedia.ABOUTME }
        
        if filteredArrayAboutMe.count > 0{
            let extField    =   filteredArrayAboutMe[0]
            aboutmeLblOutlet.text    =   extField.value
        }
        
        
        let contactConainers =  wizcard.contactContainers?.allObjects as! [ContactContainer]
        if let mediaSet     =   contactConainers[0].media{
            let media       =   mediaSet.allObjects as! [Media]
            if media.count == 0{
                    hideBusinesscardView()
            }
        }

        if let media = HelperFunction.getWizcardVideo(arrayList: wizcard.media?.allObjects as? [Media]){
            if let _ = URL(string:media.media_element!)
            {
                showVideoView()
            }else{
                hideVideoView()
            }
        }else{
            hideVideoView()
        }
//        if rolodexPageViewController != nil {
//            self.rolodexPageViewController.wizcard = wizcard
//        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let rolodexPageViewController = segue.destination as? RolodexPageViewController {
            self.rolodexPageViewController = rolodexPageViewController
            rolodexPageViewController.wizcard = wizcard
            rolodexPageViewController.delegateProperty = self
        }
    }
    
    @objc func editButtonClicked(){
        let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
        let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
        confirmViewController.wizcard = wizcard
        confirmViewController.screenOpenFrom = EditProfileFrom.MYPROFILE
        self.navigationController?.pushViewController(confirmViewController, animated: true)
    }
    
    func hideBusinesscardView(){
        businessCardView.isHidden = true
        self.view.removeConstraint(businessCardWidthOutletConstraint)
        businessCardWidthOutletConstraint = NSLayoutConstraint.init(item: businessCardView, attribute: .width, relatedBy: .equal, toItem: mainViewParentPropotational, attribute: .width, multiplier: 0, constant: 0)
        self.view.addConstraint(businessCardWidthOutletConstraint)
    }

    func showVideoView(){
        videocardView.isHidden = false
        self.view.removeConstraint(videoViewConstraintOutlet)
        videoViewConstraintOutlet = NSLayoutConstraint.init(item: videocardView, attribute: .width, relatedBy: .equal, toItem: mainViewParentPropotational, attribute: .width, multiplier: 0.33, constant: 0)
        self.view.addConstraint(videoViewConstraintOutlet)
    }
    
    func hideVideoView(){
        videocardView.isHidden = true
        self.view.removeConstraint(videoViewConstraintOutlet)
        videoViewConstraintOutlet = NSLayoutConstraint.init(item: videocardView, attribute: .width, relatedBy: .equal, toItem: mainViewParentPropotational, attribute: .width, multiplier: 0, constant: 0)
        self.view.addConstraint(videoViewConstraintOutlet)
    }
    
    
    @IBAction func profileButtonClicked(_ sender: Any) {
        
        if rolodexPageViewController.currentIndex != 0{
            rolodexPageViewController.currentIndex = 0
            let viewController = rolodexPageViewController.viewControllerAtIndex(index: 0)
            let viewControllers:[UIViewController] = [viewController!];
            rolodexPageViewController.setViewControllers(viewControllers, direction: .reverse, animated: true, completion: nil)
            
            currentSelectedIndex(index: 0)
        }
    }
    
    
    @IBAction func businessCardClicked(_ sender: Any) {
        let earlierIndex = rolodexPageViewController.currentIndex
        if rolodexPageViewController.currentIndex != 1{
            rolodexPageViewController.currentIndex = 1
            let viewController = rolodexPageViewController.viewControllerAtIndex(index: 1)
            let viewControllers:[UIViewController] = [viewController!];
            
            if earlierIndex == 0 {
                rolodexPageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
            }else if earlierIndex == 2 {
                rolodexPageViewController.setViewControllers(viewControllers, direction: .reverse, animated: true, completion: nil)
            }
            currentSelectedIndex(index: 1)
        }
    }
    
    @IBAction func videoButtonClicked(_ sender: Any) {
        let viewController = rolodexPageViewController.viewControllerAtIndex(index: 2)
        let viewControllers:[UIViewController] = [viewController!];
        rolodexPageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        currentSelectedIndex(index: 2)
    }
}

extension RolodexL2ViewController : RolodexPageViewControllerDelegate{
    func currentSelectedIndex(index: Int) {
        if index == 0 {
            profileButtonOutlet.setImage(#imageLiteral(resourceName: "profileActive"), for: .normal)
            businesscardButtonOutlet.setImage(#imageLiteral(resourceName: "businessInActive"), for: .normal)
            videoButtonOutlet.setImage(#imageLiteral(resourceName: "videoInActive"), for: .normal)
        }else if index == 1 {
            profileButtonOutlet.setImage(#imageLiteral(resourceName: "profileInActive"), for: .normal)
            businesscardButtonOutlet.setImage(#imageLiteral(resourceName: "businessActive"), for: .normal)
            videoButtonOutlet.setImage(#imageLiteral(resourceName: "videoInActive"), for: .normal)
        }else if index == 2{
            profileButtonOutlet.setImage(#imageLiteral(resourceName: "profileInActive"), for: .normal)
            businesscardButtonOutlet.setImage(#imageLiteral(resourceName: "businessInActive"), for: .normal)
            videoButtonOutlet.setImage(#imageLiteral(resourceName: "videoActive"), for: .normal)
        }
    }
}
