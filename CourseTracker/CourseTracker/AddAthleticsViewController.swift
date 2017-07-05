//
//  AddAthleticsViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-23.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

protocol AddAthleticsDelegate: class {
    func updateCalendarCell(for date: Date) -> Void
}

class AddAthleticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    //MARK: Properties

    @IBOutlet weak var athleticTableView: UITableView!
    @IBOutlet weak var athleticCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!

    var date: Date!
    var athleticDate: AthleticDate? {
        get {
            let dateFormatter : DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            }()
            return realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: date ?? Date()))'").first
        }
    }
    var student: Student!
    var realm: Realm!
    weak var delegate: AddAthleticsDelegate?
    
    let categories = ["Gym", "Pool", "Studio", "Fitness Centre", "Rock Climbing Wall"]
    let categoryImages: [UIImage] = [
        UIImage(named: "Gym")!,
        UIImage(named: "Pool")!,
        UIImage(named: "Studio")!,
        UIImage(named: "Fitness")!,
        UIImage(named: "Rock")!     ]
    let categoryColors: [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.orange]
    
    var tableViewDataSource = [AthleticEvent]()
    
    //cell scaling
    let cellScaling: CGFloat = 0.79
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Collectionview Layouts
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = athleticCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

        athleticCollectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        //Tableview scrolling fix
//        athleticTableView.setContentOffset(CGPoint.zero, animated: true

        athleticCollectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        //Tableview scrolling fix
//        athleticTableView.setContentOffset(CGPoint.zero, animated: true)
        
        //data/ delegate
        athleticCollectionView.dataSource = self
        athleticCollectionView.delegate = self

        athleticTableView.rowHeight = UITableViewAutomaticDimension
        athleticTableView.estimatedRowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Methods
    
    @IBAction func courseButtonTapped(_ sender: Any) {
    }
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        delegate?.updateCalendarCell(for: date)
    }

    //MARK: Scrollview Delegate

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if scrollView == athleticTableView {
            return
        }
        
        let layout = self.athleticCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)

        targetContentOffset.pointee = offset
    }
    
    //MARK: TableView Delegate/ Data

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //when selecting a row in the tableview, populate calendar tableview with the data
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell

        let athleticEvent = tableViewDataSource[indexPath.row]

        try! realm.write {
            athleticEvent.studentAttending = !athleticEvent.studentAttending
        }

        let bgcolor = currentCell.backgroundColor
        currentCell.backgroundColor = .gray

        UIView.animate(withDuration: 0.4) {
            currentCell.accessoryType = (athleticEvent.studentAttending) ? .checkmark : .none
            currentCell.backgroundColor = bgcolor
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AthleticCell", for: indexPath) as! AthleticTableViewCell
        cell.athleticEvent = tableViewDataSource[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = (cell.athleticEvent.studentAttending) ? .checkmark : .none
        cell.update()
        
        return cell
    }
    
    //MARK: CollectionView Delegate/ Data
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    //when selecting an item populate tableview with the data of the item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let predicate = NSPredicate(format: "location contains '\(categories[indexPath.item])'")
        guard let dataSource = athleticDate?.athleticEvents.filter(predicate).sorted(byKeyPath: "startTime") else { return }

        tableViewDataSource = Array(dataSource)
        athleticTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = athleticCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! AthleticCollectionViewCell
        cell.athleticEvent = athleticDate?.athleticEvents.sorted(byKeyPath: "startTime")[indexPath.item]
        cell.category = categories[indexPath.item]
        
        
        cell.eventImageView.image = categoryImages[indexPath.item]
        cell.eventBackgroundView.backgroundColor  = categoryColors[indexPath.item].withAlphaComponent(0.30)
        
        cell.updateUI()
        
        return cell
    }
}

//random color extension
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
