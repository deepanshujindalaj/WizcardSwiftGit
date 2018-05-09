//
//  ContactContainerViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 06/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class ContactContainerViewController: BaseViewController {

    var wizcard : Wizcard!
    @IBOutlet weak var businessImageViewOutlet: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let contactConainers =  wizcard.contactContainers?.allObjects as! [ContactContainer]
        if let mediaSet     =   contactConainers[0].media{
            let media       =   mediaSet.allObjects as! [Media]
            if media.count > 0{
                if let picUrl = URL(string:media[0].media_element!)
                {
                    businessImageViewOutlet.af_setImage(withURL:  picUrl)
                }
            }
        }
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
