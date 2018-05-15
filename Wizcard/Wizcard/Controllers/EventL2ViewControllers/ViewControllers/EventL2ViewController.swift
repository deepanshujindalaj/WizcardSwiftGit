//
//  EventL2ViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class EventL2ViewController: UIViewController {

    var event : Event!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
//            eventL2PageViewSlider.delegateProperty = self
        }
        
    }
    

}
