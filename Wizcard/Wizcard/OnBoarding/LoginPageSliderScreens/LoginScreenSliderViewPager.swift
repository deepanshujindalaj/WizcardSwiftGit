//
//  LoginScreenSliderViewPager.swift
//  Wizcard
//
//  Created by Akash Jindal on 21/02/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit



class LoginScreenSliderViewPager: UIPageViewController {

    let pagesImages = ["discover", "exchange", "connect"];
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
        
        if pagesImages.count == 0 || index >= pagesImages.count {
            return nil
        }
        
        let storyBoard = UIStoryboard(name: StoryboardNames.OnBoarding, bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.OnBoarding.loginPageContentViewController) as! LoginPageContentViewController
        viewController.imageFile = pagesImages[index]
        viewController.currentIndex = index
        
        return viewController;
    }
    
    

}


extension LoginScreenSliderViewPager : UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = 0;
        if viewController is LoginPageContentViewController {
            let firstPageViewController  = (viewController as! LoginPageContentViewController)
            index = firstPageViewController.currentIndex
        }
        
        if index == 0{
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = 0;
        if viewController is LoginPageContentViewController {
            let firstPageViewController  = (viewController as! LoginPageContentViewController)
            index = firstPageViewController.currentIndex
        }
        
        
        if index == NSNotFound{
            return nil
        }
        
        index += 1
        
        if index  == 3 {
            return nil
        }
        
        if index == 1 {
            
        }
        
        return viewControllerAtIndex(index: index)
    }
}
