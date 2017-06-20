//
//  PopoverViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-19.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

protocol CourseAdded {
    var courseTitle : String {get set}
}

class PopoverViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet var popCourseLabel: UILabel!
    @IBOutlet weak var popDescriptionLabel: UILabel!
    @IBOutlet weak var popTextbookLabel: UILabel!
    

    //buttons
    @IBOutlet weak var addSelected: UIButton!
    
    @IBOutlet weak var cancelSelected: UIButton!
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Helper Methods
    @IBAction func addSelectedTapped(_ sender: Any) {
        //add the selected cell to the tableview Cell
//        
//        
//        self.yourArray.append(msg)
//        
//        self.tblView.beginUpdates()
//        self.tblView.insertRows(at: [IndexPath.init(row: self.yourArray.count-1, section: 0)], with: .automatic)
//        self.tblView.endUpdates()
//    
    }

    @IBAction func cancelSelectedTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
