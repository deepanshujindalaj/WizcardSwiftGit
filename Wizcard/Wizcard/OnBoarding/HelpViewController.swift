//
//  HelpViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 17/02/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIPageViewControllerDelegate{
    
    

    @IBOutlet weak var pageViewParentViewOutlet: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
        let pageViewControler = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.pageViewController) as! PageViewController
        pageViewControler.dataSource = self
        
        
        let viewController = viewControllerAtIndex(value: 0)
        let viewControllers:[UIViewController] = [viewController];
        pageViewControler.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        
        pageViewParentViewOutlet.addSubview(pageViewControler.view)
        
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
    
    func viewControllerAtIndex(value : Int)-> UIViewController{
        var viewController = UIViewController()
        switch value {
        case 0:
            
            let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
            viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.firstPageViewController) as! FirstPageViewController
            
        default:
            print("")
        }
        
        return viewController;
    }
    

}
extension HelpViewController : UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let firstPageViewController  = (viewController as! FirstPageViewController)
        
        
        return viewControllerAtIndex(value: 0)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewControllerAtIndex(value: 0)
    }
}
