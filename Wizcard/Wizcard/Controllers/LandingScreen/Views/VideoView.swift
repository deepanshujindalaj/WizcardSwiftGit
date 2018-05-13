//
//  VideoView.swift
//  Wizcard
//
//  Created by Akash Jindal on 11/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit
import YouTubePlayer
import Alamofire


protocol  VideoViewDelegate{
    
    func deleteButtonClicked()
    
}




class VideoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegateProperty : VideoViewDelegate!
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    var wizcard : Wizcard!
    var media : Media!
    var contentView : UIView!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoViewParent: UIView!
    
    @IBOutlet weak var youtubeVideoView: YouTubePlayerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayout()
    }
    
    private func setUpLayout()
    {
        //        contentView = Bundle.main.loadNibNamed("SocialMediaView", owner: self, options:nil)?.first as! UIView
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
    }
    
    func startProcess(needToDisplayDeleteButton : Bool){
        
        self.isHidden = false
        if needToDisplayDeleteButton {
            deleteButtonOutlet.isHidden = false
        }
        
        // Do any additional setup after loading the view.
        acitivityIndicator.startAnimating()
        youtubeVideoView.delegate = self
        if let media = HelperFunction.getWizcardVideo(arrayList: wizcard.media?.allObjects as? [Media]){
            if let _ = URL(string:media.media_element!)
            {
                self.media = media
                Alamofire.request(media.media_iframe!).responseImage { response in
                    self.acitivityIndicator.stopAnimating()
                    if let image = response.result.value {
                        self.thumbnailImageView.image = image
                    }
                }
            }
        }
    }
    
    func startProcessingWithUrl(media : Media){
        self.isHidden = false
        
        acitivityIndicator.startAnimating()
        youtubeVideoView.delegate = self
        if let _ = URL(string:media.media_element!)
        {
            self.media = media
            Alamofire.request(media.media_iframe!).responseImage { response in
                self.acitivityIndicator.stopAnimating()
                if let image = response.result.value {
                    self.thumbnailImageView.image = image
                }
            }
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        self.isHidden = true
        self.delegateProperty.deleteButtonClicked()
    }
    @IBAction func playButtonClicked(_ sender: Any) {
        acitivityIndicator.startAnimating()
        let myVideoURL = URL(string: media.media_element!)
        youtubeVideoView.loadVideoURL(myVideoURL!)
    }
}


extension VideoView : YouTubePlayerDelegate{
    
    func playerReady(_ videoPlayer: YouTubePlayerView){
        print("hello")
        acitivityIndicator.stopAnimating()
        videoViewParent.isHidden = false
        videoPlayer.play()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState){
        print("hello")
        switch playerState {
        case .Paused, .Ended:
            videoViewParent.isHidden = true
            
        default:
            break
        }
    }
    
}
