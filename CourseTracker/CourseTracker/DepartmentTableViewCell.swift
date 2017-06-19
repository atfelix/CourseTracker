//
//  DepartmentTableViewCell.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-18.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {
    
    //collectionView
    @IBOutlet weak var courseCollectionView: UICollectionView!
    
}

extension DepartmentTableViewCell : UICollectionViewDataSource {
    //DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = courseCollectionView.dequeueReusableCell(withReuseIdentifier: "CourseIcon", for: indexPath) as! CourseCollectionViewCell
        //implement cell selection
        if cell.isSelected == true{
            cell.backgroundColor = UIColor.black
        }else{
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = courseCollectionView.cellForItem(at: indexPath)
        //implement cell selection
        if cell?.isSelected == true{
            cell?.backgroundColor = UIColor.black
        }else{
            cell?.backgroundColor = UIColor.clear
        }
    }
    
}

extension DepartmentTableViewCell : UICollectionViewDelegateFlowLayout {
    //FlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}



