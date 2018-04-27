//
//  HelpViewController.swift
//  Wizcard
//
//  Created by Akash Jindal on 17/02/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController{
    
    

    @IBOutlet weak var helpButtonOutlet: RoundableButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var pageViewParentViewOutlet: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
        let pageViewControler = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.pageViewController) as! PageViewController
        pageViewControler.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        pageViewControler.dataSource = self
        pageViewControler.delegate = self
        
        
        let viewController = viewControllerAtIndex(index: 0)
        let viewControllers:[UIViewController] = [viewController];
        pageViewControler.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        self.addChildViewController(pageViewControler)
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
    
    @IBAction func helpButtonClicked(_ sender: Any) {
        
        HelperFunction.saveBooleanValueInUserDefaults(key: UserDefaultKeys.kKeyForIsHelpShown, value: true)
        let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.loginViewCon) as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }

    
    
    
    func viewControllerAtIndex(index : Int)-> UIViewController{
        var viewController = UIViewController()
        switch index {
        case 0:
            
            let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
            viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.firstPageViewController) as! FirstPageViewController
            (viewController as! FirstPageViewController).currentIndex = index
            
        case 1:
            
            let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
            viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.secondPageViewController) as! SecondPageViewController
            (viewController as! SecondPageViewController).currentIndex = index
          
        case 2:
            
            let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
            viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.thirdPageViewController) as! ThirdPageViewController
            (viewController as! ThirdPageViewController).currentIndex = index
            
        case 3:
            
            let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
            viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.fourthPageViewController) as! FourthPageViewController
            (viewController as! FourthPageViewController).currentIndex = index
            
        default:
            print("")
        }
        
        return viewController;
    }
    

}
extension HelpViewController : UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = 0;
        if viewController is FirstPageViewController {
            let firstPageViewController  = (viewController as! FirstPageViewController)
            index = firstPageViewController.currentIndex
        }else if viewController is SecondPageViewController{
            let firstPageViewController  = (viewController as! SecondPageViewController)
            index = firstPageViewController.currentIndex
        }else if viewController is ThirdPageViewController{
            let firstPageViewController  = (viewController as! ThirdPageViewController)
            index = firstPageViewController.currentIndex
        }else {
            let firstPageViewController  = (viewController as! FourthPageViewController)
            index = firstPageViewController.currentIndex
        }
        pageController.currentPage = index
        if index == 0{
            return nil
        }
        
        index -= 1
        
        if index == 1 {
            self.helpButtonOutlet.alpha = 1;
            // swift:
            UIView.animate(withDuration: 0.3) {
                self.helpButtonOutlet.alpha = 0
            }
        }
        
        
        return viewControllerAtIndex(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = 0;
        if viewController is FirstPageViewController {
            let firstPageViewController  = (viewController as! FirstPageViewController)
            index = firstPageViewController.currentIndex
        }else if viewController is SecondPageViewController{
            let firstPageViewController  = (viewController as! SecondPageViewController)
            index = firstPageViewController.currentIndex
        }else if viewController is ThirdPageViewController{
            let firstPageViewController  = (viewController as! ThirdPageViewController)
            index = firstPageViewController.currentIndex
        }else {
            let firstPageViewController  = (viewController as! FourthPageViewController)
            index = firstPageViewController.currentIndex
        }
        
        pageController.currentPage = index
        if index == NSNotFound{
            return nil
        }
        
        index += 1
        
        if index == 4 {
      
            self.helpButtonOutlet.alpha = 0;
            // swift:
            UIView.animate(withDuration: 0.3) {
                self.helpButtonOutlet.alpha = 1
            }
        }
        
        if index  == 4 {
            return nil
        }
        
        
        
        return viewControllerAtIndex(index: index)
    }
}
