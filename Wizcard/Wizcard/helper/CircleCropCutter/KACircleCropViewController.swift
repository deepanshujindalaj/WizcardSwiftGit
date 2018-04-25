

import UIKit

protocol KACircleCropViewControllerDelegate
{
    
    func circleCropDidCancel()
    func circleCropDidCropImage(_ image: UIImage)
    
}

class KACircleCropViewController: UIViewController, UIScrollViewDelegate {
    
    var delegate: KACircleCropViewControllerDelegate?
    
    var image: UIImage
    let imageView = UIImageView()
    let scrollView = KACircleCropScrollView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
    let cutterView = KACircleCropCutterView()
    
    
    
    init(withImage image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    lazy var  bottomView : UIView = {
        let bottomView = UIView(frame: CGRect.zero)
        bottomView.backgroundColor = UIColor.white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    lazy var roundedButton : RoundableButton =
        {
            let roundedButton  = RoundableButton(frame: CGRect.zero)
            roundedButton.round = true
            roundedButton.setTitle("CROP IMAGE", for: .normal)
            roundedButton.backgroundColor = UIColor.black
            roundedButton.translatesAutoresizingMaskIntoConstraints = false
            roundedButton.backgroundColor = UIColor.driverTheme
            roundedButton.addTarget(self, action: #selector(didTapOk), for: .touchUpInside)
            roundedButton.titleLabel?.font = UIFont.init(name: FontNames.medium, size: 15)
            return roundedButton
    }()
    // MARK: View management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        scrollView.backgroundColor = UIColor.black
        
        imageView.image = image
        imageView.frame = CGRect(origin: CGPoint.zero, size: image.size)
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
        
        let scaleWidth = scrollView.frame.size.width / scrollView.contentSize.width
        scrollView.minimumZoomScale = scaleWidth
        if imageView.frame.size.width < scrollView.frame.size.width {
            //print("We have the case where the frame is too small")
            scrollView.maximumZoomScale = scaleWidth * 2
        } else {
            scrollView.maximumZoomScale = 1.0
        }
        scrollView.zoomScale = scaleWidth
        
        //Center vertically
        scrollView.contentOffset = CGPoint(x: 0, y: (scrollView.contentSize.height - scrollView.frame.size.height)/2)
        
        //Add in the black view. Note we make a square with some extra space +100 pts to fully cover the photo when rotated
        cutterView.frame = view.frame
        cutterView.frame.size.height += 100
        cutterView.frame.size.width = cutterView.frame.size.height
        setLabelAndButtonFrames()
        view.addSubview(scrollView)
        view.addSubview(cutterView)
        view.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant:80).isActive = true
        bottomView.addSubview(roundedButton)
        roundedButton.leadingAnchor.constraint(equalTo: self.bottomView.leadingAnchor, constant:17).isActive = true
        roundedButton.trailingAnchor.constraint(equalTo: self.bottomView.trailingAnchor, constant: -17).isActive = true
        roundedButton.centerYAnchor.constraint(equalTo: self.bottomView.centerYAnchor).isActive = true
        roundedButton.heightAnchor.constraint(equalToConstant:45).isActive = true
    }
    func setLabelAndButtonFrames() {
        
        scrollView.center = view.center
        cutterView.center = view.center
    }
    /* use if rotation needed
     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
     
     
     coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
     
     self.setLabelAndButtonFrames()
     
     }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
     }
     }*/
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    
    
    // MARK: Button taps
    
    @objc func didTapOk() {
        
        
        let newSize = CGSize(width: image.size.width*scrollView.zoomScale, height: image.size.height*scrollView.zoomScale)
        
        let offset = scrollView.contentOffset
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 240, height: 240), false, 0)
        let circlePath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 240, height: 240))
        circlePath.addClip()
        var sharpRect = CGRect(x: -offset.x, y: -offset.y, width: newSize.width, height: newSize.height)
        sharpRect = sharpRect.integral
        
        image.draw(in: sharpRect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let imageData = UIImagePNGRepresentation(finalImage!) {
            if let pngImage = UIImage(data: imageData) {
                delegate?.circleCropDidCropImage(pngImage)
            } else {
                delegate?.circleCropDidCancel()
            }
        } else {
            delegate?.circleCropDidCancel()
        }
        
        
        
    }
    
    func didTapBack() {
        
        delegate?.circleCropDidCancel()
        
    }

}

