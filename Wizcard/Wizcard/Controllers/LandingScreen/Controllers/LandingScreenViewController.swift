//
//  LandingScreenViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 01/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation

class LandingScreenViewController: UIViewController {

    
    var selfwizcard : Wizcard!
    var locationManager : LocationManager!
    var cordinateLocation: CLLocationCoordinate2D!
    var recommendedEvents = [Event]()
    var joinedEvents = [Event]()
    var pinnnedEvent =  [Event]()
    
    @IBOutlet weak var pinnedCollectionView: UICollectionView!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    @IBOutlet weak var joinedCollectionView: UICollectionView!
    @IBOutlet weak var joinedViewOutlet: UIView!
    @IBOutlet weak var recommendedViewOutlet: UIView!
    @IBOutlet weak var joinedViewHeightConstraintOutlet: NSLayoutConstraint!
    
    @IBOutlet weak var pinnedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pinnedViewOutlet: UIView!
    @IBOutlet weak var recommendedViewHeightConstarintOutlet: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
        SideMenuManager.default.menuPresentMode                     =   .menuSlideIn
        SideMenuManager.default.menuAnimationTransformScaleFactor   =   0.8
        SideMenuManager.default.menuFadeStatusBar                   =   false
        SideMenuManager.default.menuWidth                           =   self.view.frame.width * 0.75
        selfwizcard = WizcardManager.wizcardManager.getSelfWizcard()
        
        locationManager = LocationManager(delegate:self)
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateEvent()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func updateEvent(){
        let allEvents = EventManager.eventManager.getAllEvents()!
        
        joinedEvents.removeAll()
        pinnnedEvent.removeAll()
        
        for event in allEvents {
            if event.state?.intValue == EVENTSTATE.kEDS_Joined.rawValue{
                joinedEvents.append(event)
            }else {
                pinnnedEvent.append(event)
            }
        }
        
        
        if joinedEvents.count > 0{
            joinedViewOutlet.isHidden = false
            joinedViewHeightConstraintOutlet.constant = 249.0
            
        }else{
            joinedViewOutlet.isHidden = true
            joinedViewHeightConstraintOutlet.constant = 0
        }
        joinedCollectionView.reloadData()
        
        if self.recommendedEvents.count > 0{
            self.recommendedViewOutlet.isHidden = false
            self.recommendedViewHeightConstarintOutlet.constant = 249.0
        }else{
            self.recommendedViewOutlet.isHidden = true
            self.recommendedViewHeightConstarintOutlet.constant = 0
        }
        self.recommendedCollectionView.reloadData()
        
        if pinnnedEvent.count > 0 {
            self.pinnedViewOutlet.isHidden = false
            self.pinnedViewHeightConstraint.constant = 249.0
        }else{
            self.pinnedViewOutlet.isHidden = true
            self.pinnedViewHeightConstraint.constant = 0
        }
        self.pinnedCollectionView.reloadData()
    }

    func getEvents(){
        let params :[String:Any] = [
            ProfileKeys.user_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id),
            ProfileKeys.wizuser_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id),
            ProfileKeys.lat : cordinateLocation.latitude,
            ProfileKeys.lng : cordinateLocation.longitude,
            EventsKeys.entity_type: "EVT"
        ]
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyForGet_events, jsonToPost: params) { (json) in
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    let jsonData = json[ServerKeys.data]
                    if jsonData[EventsKeys.recommended].exists(){
                        self.recommendedEvents = EventManager.eventManager.populateEventsFromServerNotif(eventJSON: jsonData[EventsKeys.recommended], createUnAssociate: true)
                        self.updateEvent()
                    }
                }
            }
        }
    }
}

extension LandingScreenViewController : UICollectionViewDataSource, UICollectionViewDelegate, LandingScreenCellDelegate{
    
    func pinButtonClicked(event: Event){
        
        var params :[String:Any] = [
            ProfileKeys.user_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id),
            ProfileKeys.wizuser_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id),
            ProfileKeys.lat : cordinateLocation.latitude,
            ProfileKeys.lng : cordinateLocation.longitude,
            EventsKeys.entity_type: "EVT",
            EventsKeys.entity_id : event.eventId ?? 0.0,
            ProfileKeys.device_type : ProfileKeys.iOS,
            "level" : 0,
        ]
        
        if event.state?.intValue == EVENTSTATE.kEDS_Pin.rawValue {
            params["state"] = EVENTSTATE.kEDS_UnPin.rawValue
        }
        else {
            params["state"] = EVENTSTATE.kEDS_Pin.rawValue
        }
        
        BaseServices.SendPostJson(viewController: self, serverUrl: ServerUrls.APICalls.kKeyEntity_access, jsonToPost: params) { (json) in
            if let json = json{
                let jsonObject = json[ServerKeys.result]
                if jsonObject[ServerKeys.error] == 0{
                    
                    
                    
                    if event.state?.intValue == EVENTSTATE.kEDS_Pin.rawValue{
                        EventManager.eventManager.deleteObject(object: event)
                    }else{
                        for media in event.mediaArray?.allObjects as! [Media]{
                            EventManager.eventManager.saveUnAssociatedObject(object: media)
                        }
                        event.state = EVENTSTATE.kEDS_Pin.rawValue as NSNumber
                        EventManager.eventManager.saveUnAssociatedObject(object: event)
                    }
                    
                    
                    let jsonData = json[ServerKeys.data]
                    if jsonData[EventsKeys.recommended].exists(){
                        self.recommendedEvents = EventManager.eventManager.populateEventsFromServerNotif(eventJSON: jsonData[EventsKeys.recommended], createUnAssociate: true)
                        self.updateEvent()
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if joinedCollectionView == collectionView {
            return joinedEvents.count
        }else if pinnedCollectionView == collectionView{
            return pinnnedEvent.count
        }
        return recommendedEvents.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var event : Event!
        if  joinedCollectionView == collectionView{
            event = joinedEvents[indexPath.row]
        }else if recommendedCollectionView == collectionView{
            event = recommendedEvents[indexPath.row]
        }else {
            event = pinnnedEvent[indexPath.row]
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "joinCell", for: indexPath) as! LandingScreenCell
        cell.delegate   = self
        cell.populateCollectionCellData(event: event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var event : Event!
        if  joinedCollectionView == collectionView{
            event = joinedEvents[indexPath.row]
        }else if recommendedCollectionView == collectionView{
            event = recommendedEvents[indexPath.row]
        }else {
            event = pinnnedEvent[indexPath.row]
        }
        let storyboard = UIStoryboard(name: StoryboardNames.EventL2, bundle: nil)
        let eventL2ViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.EventL2.eventL2ViewController) as! EventL2ViewController
        eventL2ViewController.event = event
        self.navigationController?.pushViewController(eventL2ViewController, animated: true)
        
    }
    
}


extension LandingScreenViewController : LocationManagerDelegate
{
    func locationDenied() {
        
    }
    
    func didChangeinLocation(cordinate: CLLocationCoordinate2D) {
        cordinateLocation = cordinate
        locationManager.stopUpdatingLocation()
        getEvents()
    }
    
    func didErrorinLocation(error: Error) {
        locationManager.stopUpdatingLocation()
    }
    
    func locationNotAvailable() {
        DispatchQueue.main.async {
            if let _ = self.presentedViewController { return }
            self.showLocationAlert()
        }
    }
    func locationFaliedToUpdate(status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.showLocationAlert()
        }
    }
    
}
