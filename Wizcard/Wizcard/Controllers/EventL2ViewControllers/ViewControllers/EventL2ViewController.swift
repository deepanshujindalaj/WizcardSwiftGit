//
//  EventL2ViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation
import SwiftyJSON

class EventL2ViewController: UIViewController {

    //From previous Controller...
    var event : Event!
    var cordinateLocation: CLLocationCoordinate2D!
    
    var sideBarMenu : UISideMenuNavigationController!
    
    @IBOutlet weak var venueIconOutlet: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var eventNameLblOutlet: UILabel!
    @IBOutlet weak var eventStartDateLblOutlet: UILabel!
    
    //Sponsor view height constraint 96
    @IBOutlet weak var sponsoredViewOutlet: UIView!
    @IBOutlet weak var sponsoredHeightConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var sponsorViewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var sponsorsCollectionView: UICollectionView!
    
    //Speaker view height constraint 101
    @IBOutlet weak var speakerViewOutlet: UIView!
    @IBOutlet weak var speakerHeightConstraintOutlet: NSLayoutConstraint!
    
    //Media view height constraint 161
    @IBOutlet weak var mediaViewOutlet: UIView!
    @IBOutlet weak var mediaViewHeightConstraintOutlet: NSLayoutConstraint!
    //Campaign view height constraint 209
    @IBOutlet weak var campaignsViewOutlet: UIView!
    @IBOutlet weak var campaignViewHeightConstraintOutlet: NSLayoutConstraint!
    
    @IBOutlet weak var emailLblOutlet: UILabel!
    @IBOutlet weak var venueLblOutlet: UILabel!
    
    
    @IBOutlet weak var descriptionShortLblOutlet: UILabel!
    @IBOutlet weak var descriptionFullLblOutlet: UILabel!
    @IBOutlet weak var viewMoreDescriptionButtonOutlet: UIButton!
    
    //Attendees...Height constraint 128
    @IBOutlet weak var attandeeViewHeightConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var firstImageViewOutlet: RoundableUIImageView!
    @IBOutlet weak var secondImageViewOutlet: RoundableUIImageView!
    @IBOutlet weak var thirdImageViewOutlet: RoundableUIImageView!
    @IBOutlet weak var attndeeActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var attandeeViewParent: UIView!
    @IBOutlet weak var attndeeViewInner: UIView!
    @IBOutlet weak var attendeeButtonOutlet: RoundableButton!
    
    var joinPopUp : JoinPopUp!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        venueIconOutlet.image       =   venueIconOutlet.image!.withRenderingMode(.alwaysTemplate)
        venueIconOutlet.tintColor   =   UIColor.buttonSelected
        
        populateEventData()
        
        if event.state?.intValue != EVENTSTATE.kEDS_Joined.rawValue{
            joinPopUp = JoinPopUp.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            joinPopUp.delegate = self
            UIApplication.shared.keyWindow?.addSubview(joinPopUp)
        }
        populateAttendeeData()
        populateSponsors()
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
        
        if let eventL2PageViewSlider = segue.destination as? EventL2PageViewSlider {
            eventL2PageViewSlider.event = event
            eventL2PageViewSlider.pageControl = pageControl
//            eventL2PageViewSlider.delegateProperty = self
        }else if let sideMenuController = segue.destination as? UISideMenuNavigationController{
            sideBarMenu = sideMenuController
            let leftMenuViewController = sideMenuController.viewControllers[0] as! LeftMenuViewController
            leftMenuViewController.eventL2ViewController = self
            leftMenuViewController.delegate = self
        }
    }
    
    func populateEventData(){
        eventNameLblOutlet.text         =   event.name
        eventStartDateLblOutlet.text    =   HelperFunction.getCurrentDateWithoutDayName(date: event.start!)
        descriptionShortLblOutlet.text  =   event.eventDescription
        
        emailLblOutlet.text             =   event.email
        venueLblOutlet.text             =   event.venue
    }

    @IBAction func showFullDescriptionButtonClicked(_ sender: Any) {
        if descriptionFullLblOutlet.isHidden {
            descriptionFullLblOutlet.text = event.eventDescription
            descriptionFullLblOutlet.isHidden = false
            descriptionShortLblOutlet.text = ""
            descriptionShortLblOutlet.isHidden = true
            viewMoreDescriptionButtonOutlet.setTitle("View Less", for: .normal)
        }
        else
        {
            descriptionFullLblOutlet.text = ""
            descriptionFullLblOutlet.isHidden = true
            descriptionShortLblOutlet.text = event.eventDescription
            descriptionShortLblOutlet.isHidden = false
            viewMoreDescriptionButtonOutlet.setTitle("View More", for: .normal)
        }
    }
}

extension EventL2ViewController: LeftMenuViewControllerDelegate, JoinPopUpDelegate{
    func joinButtonClicked() {
        let params :[String:Any] = [
            ProfileKeys.user_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id),
            ProfileKeys.wizuser_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id),
            ProfileKeys.lat : cordinateLocation.latitude,
            ProfileKeys.lng : cordinateLocation.longitude,
            EventsKeys.entity_type: "EVT",
            EventsKeys.entity_id : event.eventId ?? 0.0,
            ProfileKeys.device_type : ProfileKeys.iOS,
            "level" : 2,
            "state" : EVENTSTATE.kEDS_Joined.rawValue
        ]
        
    
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyEntity_access, jsonToPost: params, isResponseRequired : true) { (json) in
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    let jsonData = json[ServerKeys.data]
                    if jsonData[ServerKeys.result].exists(){
                        self.joinPopUp.removeFromSuperview()
                        let eventData = jsonData[ServerKeys.result]
                        self.event = EventManager.eventManager.populateSingleEventFromServerNotif(eventJSON: eventData, createUnAssociate: false)
                        
                        self.event.is_detailed_saved = true
                        self.event.state = EVENTSTATE.kEDS_Joined.rawValue as NSNumber
                        self.populateEventData()
                        self.processEventAttendee(eventData: eventData)
                        
                        self.processSponsorsData(eventData: eventData)
                        EventManager.eventManager.saveContext()
                    }
                }
            }
        }
    }
    
    
    func processSponsorsData(eventData : JSON){
        
        var sponsorsArraySuper = [Sponsors]()
        if eventData[EventsKeys.sponsors].exists(){
            if let sponsorsArray = eventData[EventsKeys.sponsors].array{
                if sponsorsArray.count > 0{
                    for sponsor in sponsorsArray{
                    sponsorsArraySuper.append(SponsorsManager.sponsorsManager.populateSingleSponsorsFromServerNotif(eventJSON: sponsor, createUnAssociate: false))
                    }
                    self.event.sponsors = NSSet(array : sponsorsArraySuper)
                    populateSponsors()
                }
            }
        }
    }
    
    func populateSponsors(){
        
        if event.sponsors?.allObjects.count != 0 {
            self.sponsoredViewOutlet.isHidden = false
            sponsoredHeightConstraintOutlet.constant = 96
            self.sponsorsCollectionView.reloadData()
        }
    }
    
    func processEventAttendee(eventData : JSON){
        var rolodexArraySuper = [Wizcard]()
        if eventData[EventsKeys.users].exists(){
            let usersData = eventData[EventsKeys.users]
            if usersData[ServerKeys.data].exists(){
                event.attendeeCount = usersData[EventsKeys.count].intValue as NSNumber
                if let jsonArray = usersData[ServerKeys.data].array
                {
                    attandeeViewHeightConstraintOutlet.constant = 108
                    attandeeViewParent.isHidden = false
                    attndeeActivityIndicator.startAnimating()
                    if jsonArray.count > 0{
                        for wizcard in jsonArray{
                            rolodexArraySuper.append(WizcardManager.wizcardManager.populateWizcardFromServerNotif(wizcard: wizcard, createUnAssociate: false))
                        }
                    }
                    attndeeActivityIndicator.stopAnimating()
                    attndeeViewInner.isHidden = false
                }
            }
            self.event.eventusers = NSSet(array : rolodexArraySuper)
            populateAttendeeData()
        }
    }
    
    func populateAttendeeData(){
        
        let rolodexArraySuper =  self.event.eventusers?.allObjects as! [Wizcard]
        
        if self.event.attendeeCount != 0{
            attendeeButtonOutlet.setTitle("\(self.event.attendeeCount ?? 0) Attendees", for: .normal)
            attandeeViewHeightConstraintOutlet.constant = 108
            attandeeViewParent.isHidden = false
            attndeeViewInner.isHidden = false
            
            if self.event.attendeeCount == 1{
                
                firstImageViewOutlet.isHidden = true
                secondImageViewOutlet.isHidden = false
                thirdImageViewOutlet.isHidden = true
                
                let wizcard = rolodexArraySuper[0]
                
                CommonFunction.showProfileImage(profilePicOutlet: secondImageViewOutlet, firstandLastNameLblOutlet: nil, titleLblOutlet: nil, destination: nil, wizcard: wizcard)
                
            }else if self.event.attendeeCount == 2{
                firstImageViewOutlet.isHidden = false
                secondImageViewOutlet.isHidden = false
                thirdImageViewOutlet.isHidden = true
                
                let wizcard = rolodexArraySuper[0]
                CommonFunction.showProfileImage(profilePicOutlet: firstImageViewOutlet, firstandLastNameLblOutlet: nil, titleLblOutlet: nil, destination: nil, wizcard: wizcard)
                
                let wizcard1 = rolodexArraySuper[1]
                CommonFunction.showProfileImage(profilePicOutlet: secondImageViewOutlet, firstandLastNameLblOutlet: nil, titleLblOutlet: nil, destination: nil, wizcard: wizcard1)
                
            }else if self.event.attendeeCount!.intValue >= 3{
                firstImageViewOutlet.isHidden = false
                secondImageViewOutlet.isHidden = false
                thirdImageViewOutlet.isHidden = false
                
                let wizcard = rolodexArraySuper[0]
                CommonFunction.showProfileImage(profilePicOutlet: firstImageViewOutlet, firstandLastNameLblOutlet: nil, titleLblOutlet: nil, destination: nil, wizcard: wizcard)
                
                let wizcard1 = rolodexArraySuper[1]
                CommonFunction.showProfileImage(profilePicOutlet: secondImageViewOutlet, firstandLastNameLblOutlet: nil, titleLblOutlet: nil, destination: nil, wizcard: wizcard1)
                
                let wizcard2 = rolodexArraySuper[2]
                CommonFunction.showProfileImage(profilePicOutlet: thirdImageViewOutlet, firstandLastNameLblOutlet: nil, titleLblOutlet: nil, destination: nil, wizcard: wizcard2)
            }
        }
    }
    
    
    func dismissButtonClicked() {
        joinPopUp.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
    }
    
    func backButtonPressed() {
        sideBarMenu.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Click events
    @IBAction func viewAllAttendeeClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardNames.EventL2, bundle: nil)
        let userViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.EventL2.usersViewController) as! UsersViewController
        userViewController.wizcardArray = event.eventusers?.allObjects as! [Wizcard]
        self.navigationController?.pushViewController(userViewController, animated: true)
    }
    
    
}

extension EventL2ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.event.sponsors?.allObjects.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sponsoredCell", for: indexPath) as! SponsoredCollectionViewCell
        
        cell.populateCollectionCellData(sponsors: self.event.sponsors?.allObjects[indexPath.row] as! Sponsors)
        return cell
        
    }
    
    
}
