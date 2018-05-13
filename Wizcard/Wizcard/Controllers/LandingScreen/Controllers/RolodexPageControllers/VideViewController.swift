//
//  VideViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 06/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import Alamofire
import YouTubePlayer

class VideViewController: BaseViewController {

    @IBOutlet weak var videoView: VideoView!
    var wizcard : Wizcard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        videoView.wizcard = wizcard
        videoView.startProcess(needToDisplayDeleteButton: false)
    
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

