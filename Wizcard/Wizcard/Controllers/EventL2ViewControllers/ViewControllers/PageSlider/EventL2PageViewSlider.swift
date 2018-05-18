//
//  EventL2PageViewSlider.swift
//  Wizcard
//
//  Created by Akash Jindal on 15/05/18.
//  Copyright © 2018 Akash Jindal. All rights reserved.
//

import UIKit

class EventL2PageViewSlider: UIPageViewController {

    var event : Event!
    var images : [Media]!
    var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        images = HelperFunction.getBannerMediaList(arrayList: event.mediaArray?.allObjects as? [Media])
        if images.count > 0 {
            pageControl.numberOfPages = images.count
        }else{
            pageControl.numberOfPages = 1
        }
        
        
        self.delegate = self
        self.dataSource = self
        let viewController = viewControllerAtIndex(index: 0)
        if viewController != nil {
            let viewControllers:[UIViewController] = [viewController!];
            self.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        }else{
            let storyBoard = UIStoryboard(name: StoryboardNames.EventL2, bundle: Bundle.main)
            let viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.EventL2.eventSlisdingImagesViewController) as! EventSlisdingImagesViewController
            viewController.currentIndex = 0
            
            let viewControllers:[UIViewController] = [viewController];
            self.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
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

    
    func viewControllerAtIndex(index : Int)-> UIViewController?{
        
        if images.count == 0 || index >= images.count {
            return nil
        }
        
        let storyBoard = UIStoryboard(name: StoryboardNames.EventL2, bundle: Bundle.main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: IdentifierName.EventL2.eventSlisdingImagesViewController) as! EventSlisdingImagesViewController
        viewController.media = images[index]
        viewController.currentIndex = index
        
        return viewController;
    }
    
    
    
}


extension EventL2PageViewSlider : UIPageViewControllerDataSource, UIPageViewControllerDelegate{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = 0;
        if viewController is EventSlisdingImagesViewController {
            let firstPageViewController  = (viewController as! EventSlisdingImagesViewController)
            index = firstPageViewController.currentIndex
        }
        
        pageControl.currentPage = index
//        self.delegateProperty.currentSelectedIndex(index: index)
        
        if index == 0{
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = 0;
        if viewController is EventSlisdingImagesViewController {
            let firstPageViewController  = (viewController as! EventSlisdingImagesViewController)
            index = firstPageViewController.currentIndex
        }
        
//        self.delegateProperty.currentSelectedIndex(index: index)
        pageControl.currentPage = index
        if index == NSNotFound{
            return nil
        }
        
        index += 1
        
        if images.count < index{
            return viewControllerAtIndex(index: index)
        }
        
        if index  == 3 {
            return nil
        }
        
        if index == 1 {
            
        }
        
        return viewControllerAtIndex(index: index)
    }
}

