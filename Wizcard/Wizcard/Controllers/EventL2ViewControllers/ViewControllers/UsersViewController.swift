//
//  UsersViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 21/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    var wizcardArray : [Wizcard]!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "Attendees"
        // Do any additional setup after loading the view.
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

}

extension UsersViewController : UITableViewDataSource, UITableViewDelegate{
 
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return wizcardArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
        cell.populateWizcardData(wizcard: wizcardArray[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let storyboard = UIStoryboard(name: StoryboardNames.LandingScreen, bundle: nil)
        let mecreenViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.LandinScreen.rolodexL2ViewController) as! RolodexL2ViewController
        mecreenViewController.wizcard = wizcardArray[indexPath.row]
        self.navigationController?.pushViewController(mecreenViewController, animated: true)
    }
    
}
