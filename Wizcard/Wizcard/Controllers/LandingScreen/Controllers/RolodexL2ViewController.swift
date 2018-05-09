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
            rolodexPageViewController.wizcard = wizcard
        }
    }
    
    @objc func editButtonClicked(){
        let storyboard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: nil)
        let confirmViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.OnBoarding.createProfileScreenViewController) as! CreateProfileScreenViewController
        confirmViewController.wizcard = wizcard
        confirmViewController.screenOpenFrom = EditProfileFrom.MYPROFILE
        self.navigationController?.pushViewController(confirmViewController, animated: true)
    }

}
