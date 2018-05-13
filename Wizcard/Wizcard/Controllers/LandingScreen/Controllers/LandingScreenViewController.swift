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
    
    @IBOutlet weak var joinedViewOutlet: UIView!
    @IBOutlet weak var recommendedViewOutlet: UIView!
    @IBOutlet weak var joinedViewHeightConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
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
        joinedEvents = EventManager.eventManager.getAllEvents()!
        
        if joinedEvents.count > 0{
            joinedViewOutlet.isHidden = false
            joinedViewHeightConstraintOutlet.constant = 249.0
            
        }else{
            joinedViewOutlet.isHidden = true
            joinedViewHeightConstraintOutlet.constant = 0
        }
        
        if self.recommendedEvents.count > 0{
            self.recommendedViewOutlet.isHidden = false
            self.recommendedViewHeightConstarintOutlet.constant = 249.0
            self.recommendedCollectionView.reloadData()
        }else{
            self.recommendedViewOutlet.isHidden = true
            self.recommendedViewHeightConstarintOutlet.constant = 0
        }
        
        if pinnnedEvent.count > 0 {
            self.pinnedViewOutlet.isHidden = false
            self.pinnedViewHeightConstraint.constant = 249.0
        }else{
            self.pinnedViewOutlet.isHidden = true
            self.pinnedViewHeightConstraint.constant = 0
        }
    }

    func getEvents(){
        let params :[String:Any] = [
            ProfileKeys.user_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.user_id),
            ProfileKeys.wizuser_id: HelperFunction.getSrtingFromUserDefaults(key: ProfileKeys.wizuser_id),
            "lat" : cordinateLocation.latitude,
            "lng" : cordinateLocation.longitude,
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

extension LandingScreenViewController : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = recommendedEvents[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "joinCell", for: indexPath) as! LandingScreenCell
        cell.populateCollectionCellData(event: event)
        return cell
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
