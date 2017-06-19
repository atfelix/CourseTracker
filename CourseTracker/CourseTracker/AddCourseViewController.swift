//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    //temp info
    var Courses = ["COSC2323", "JASS2323", "LAKL4242"]
    
    //MARK: Properties
    @IBOutlet weak var addButton: UIButton!
    //collectionView
    @IBOutlet weak var courseCollectionView: UICollectionView!
    //searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    var dataSource:[String]?
    var dataSourceForSearchResult:[String]?
    var searchBarActive:Bool = false
    var searchBarBoundsY:CGFloat?
    var refreshControl:UIRefreshControl?
    
    //MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        courseCollectionView.dataSource = self
        courseCollectionView.delegate = self
        
        self.dataSource = Courses
        self.dataSourceForSearchResult = [String]()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Methods
    //Add button
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowCalendar", sender: sender)
    }
    
    //MARK: SearchBar
    func filterContentForSearchText(searchText:String){
        self.dataSourceForSearchResult = self.dataSource?.filter({ (text:String) -> Bool in
            return text.contains(searchText)
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.searchBarActive    = true
            self.filterContentForSearchText(searchText: searchText)
            self.courseCollectionView?.reloadData()
        }else{
            self.searchBarActive = false
            self.courseCollectionView?.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self .cancelSearching()
        self.courseCollectionView?.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        self.searchBar.setShowsCancelButton(false, animated: false)
    }
    func cancelSearching(){
        self.searchBarActive = false
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
    }
    
    //MARK: DataSource/ Delegate

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
            //header
            case UICollectionElementKindSectionHeader:
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as UICollectionReusableView
                
                headerView.backgroundColor = UIColor.black
//                headerView.de
                return headerView
            //footer if needed
            case UICollectionElementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath) as UICollectionReusableView
                
                footerView.backgroundColor = UIColor.black
                return footerView
                
            default:
                
                assert(false, "Unexpected element kind")
            }
        }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //search is active then
        if self.searchBarActive {
            return self.dataSourceForSearchResult!.count;
        }else{
            return self.dataSource!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = courseCollectionView.dequeueReusableCell(withReuseIdentifier: "CourseIcon", for: indexPath) as! CourseCollectionViewCell
        cell.indexPath = indexPath
        //implement cell selection
        if cell.isSelected == true{
            cell.backgroundColor = UIColor.black
        }else{
            cell.backgroundColor = UIColor.clear
        }
        //implement search 
        if (self.searchBarActive) {
            cell.courseLabel!.text = self.dataSourceForSearchResult![indexPath.row];
        }else{
            cell.courseLabel!.text = self.dataSource![indexPath.row];
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = courseCollectionView.cellForItem(at: indexPath)
        //implement cell selection
        if cell?.isSelected == true{
            cell?.backgroundColor = UIColor.black
        }else{
            cell?.backgroundColor = UIColor.clear
        }
    }
    
}
