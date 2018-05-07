//
//  RolodexPageViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 06/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

protocol  RolodexPageViewControllerDelegate{
    
    func currentSelectedIndex(index : Int)
    
}


class RolodexPageViewController: UIPageViewController {

    var delegateProperty : RolodexPageViewControllerDelegate!
    
    var wizcard : Wizcard!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.delegate = self
        self.dataSource = self
        let viewController = viewControllerAtIndex(index: 0)
        let viewControllers:[UIViewController] = [viewController!];
        self.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
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
    
    func viewControllerAtIndex(index : Int)-> UIViewController?{
        
        var viewController :UIViewController!
        let storyboard = UIStoryboard(name: StoryboardNames.LandingScreen, bundle: nil)
        switch index {
            case 0:
                let rolodexInforFirstPageViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.LandinScreen.rolodexInfoFirstPageConstroller) as! RolodexInforFirstPageViewController
                rolodexInforFirstPageViewController.currentIndex    =   index
                rolodexInforFirstPageViewController.wizcard         =   wizcard
                viewController = rolodexInforFirstPageViewController

            case 1:
            
                let contactContainerViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.LandinScreen.contactConatinerImageController) as! ContactContainerViewController
                contactContainerViewController.currentIndex = index
                contactContainerViewController.wizcard  =   wizcard
                viewController = contactContainerViewController
            
            case 2:
                let videViewController = storyboard.instantiateViewController(withIdentifier:IdentifierName.LandinScreen.videoViewController) as! VideViewController
                videViewController.currentIndex = index
                videViewController.wizcard  =   wizcard
                viewController = videViewController
        default:
            break
            
        }
        return viewController;
    }
    

}


extension RolodexPageViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = 0;
        
        let firstPageViewController  = (viewController as! RolodexInforFirstPageViewController)
        index = firstPageViewController.currentIndex
        
        
//        self.delegateProperty.currentSelectedIndex(index: index)
        
        if index == 0{
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = 0;

        let baseViewController : BaseViewController!
        baseViewController  = viewController as! BaseViewController
        index = (baseViewController?.currentIndex)!
        
        
        if index == NSNotFound{
            return nil
        }
        
        index += 1
//        self.delegateProperty.currentSelectedIndex(index: index)
        
        let contactContainer = wizcard.contactContainers?.allObjects as! [ContactContainer]
        if let mediaSet     =   contactContainer[0].media{
            let media       =   mediaSet.allObjects as! [Media]
            if media.count > 0{
                if URL(string:media[0].media_element!) != nil && index == 1
                {
                        return viewControllerAtIndex(index: index)
                }
            }
            
        }
        
        if wizcard.videoURL == nil || wizcard.videoURL == ""  {
            return nil
        }
        index+=1
        
        if index  >= 3 {
            return nil
        }
        
        
        return viewControllerAtIndex(index: index)
    }
}
