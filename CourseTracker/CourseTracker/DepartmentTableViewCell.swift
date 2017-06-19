//
//  DepartmentTableViewCell.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-18.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseCollectionView: UICollectionView!
}

extension DepartmentTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = courseCollectionView.dequeueReusableCell(withReuseIdentifier: "CourseIcon", for: indexPath) as! CourseCollectionViewCell
        return cell
    }
    
}

extension DepartmentTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}



