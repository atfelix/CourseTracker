//
//  PageViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    let pages = ["ViewController","AddUniversityViewController",]

//    var index : Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
        
        //initialize vc
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        setViewControllers([vc!], direction: .forward, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Delegate/ Datasource methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier{
            if let index = pages.index(of: identifier){
                if index > 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier{
            if let index = pages.index(of: identifier){
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier{
            if let index = pages.index(of: identifier){
                return index
            }
        }
        return 0
    }
    
    //MARK: Set the UIPageScroll
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in view.subviews{
            if view is UIScrollView{
                view.frame = UIScreen.main.bounds
            }
            else if view is UIPageControl{
                view.backgroundColor = UIColor.clear
            }
        }
    }

}
