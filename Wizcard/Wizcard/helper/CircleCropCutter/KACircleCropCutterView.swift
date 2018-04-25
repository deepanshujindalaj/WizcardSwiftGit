

import UIKit

class KACircleCropCutterView: UIView {
    
    override var frame: CGRect {
        
        didSet {
            setNeedsDisplay()
        }
        
    }
    var backgroundImage = UIImageView(image:#imageLiteral(resourceName: "ic_center_focus_strong"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.addSubview(backgroundImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubview(backgroundImage)
        self.isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        UIColor(red: 1, green: 1, blue:1, alpha: 0.5).setFill()
        UIRectFill(rect)
        
        //This is the same rect as the UIScrollView size 240 * 240, remains centered
        let circle = UIBezierPath(ovalIn: CGRect(x: rect.size.width/2 - 240/2, y: rect.size.height/2 - 240/2, width: 240, height: 240))
        backgroundImage.center = CGPoint(x:rect.size.width/2 ,y:rect.size.height/2 )
        context?.setBlendMode(.clear)
        UIColor.clear.setFill()
        circle.fill()
        
        //This is the same rect as the UIScrollView size 240 * 240, remains centered
        let square = UIBezierPath(rect: CGRect(x: rect.size.width/2 - 240/2, y: rect.size.height/2 - 240/2, width: 240, height: 240))
        UIColor.lightGray.setStroke()
        square.lineWidth = 1.0
        context?.setBlendMode(.normal)
        // square.stroke()
        
    }
    
    //Allow touches through the circle crop cutter view
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}

