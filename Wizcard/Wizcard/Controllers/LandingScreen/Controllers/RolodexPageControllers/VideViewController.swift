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

    var wizcard : Wizcard!
    @IBOutlet weak var thumbnailImage: UIImageView!
    var media : Media!
    
    @IBOutlet weak var youtubeVideoView: YouTubePlayerView!
    @IBOutlet weak var youtubeVideoPlayerParent: CornerRadiousAndShadowView!
    @IBOutlet weak var activityIndicatorOutlet: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicatorOutlet.stopAnimating()
        // Do any additional setup after loading the view.
        youtubeVideoView.delegate = self
        if let media = HelperFunction.getWizcardVideo(arrayList: wizcard.media?.allObjects as? [Media]){
            if let _ = URL(string:media.media_element!)
            {
                self.media = media
                Alamofire.request(media.media_iframe!).responseImage { response in
                    if let image = response.result.value {
                        self.thumbnailImage.image = image
                    }
                }       
            }
        }
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

    @IBAction func playVideoButtonClicked(_ sender: Any) {
        
        activityIndicatorOutlet.startAnimating()
        let myVideoURL = URL(string: media.media_element!)
        youtubeVideoView.loadVideoURL(myVideoURL!)
  
    }
    
}

extension VideViewController : YouTubePlayerDelegate{
    
    func playerReady(_ videoPlayer: YouTubePlayerView){
        print("hello")
        activityIndicatorOutlet.stopAnimating()
        youtubeVideoPlayerParent.isHidden = false
        videoPlayer.play()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState){
        print("hello")
        switch playerState {
            case .Paused, .Ended:
            youtubeVideoPlayerParent.isHidden = true
            
            default:
                break
        }
    }
    
}
