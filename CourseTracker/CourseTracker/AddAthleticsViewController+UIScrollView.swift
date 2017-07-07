//
//  AddAthleticsViewController+ScrollView.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension AddAthleticsViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        guard
            let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
                return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let index = (targetContentOffset.pointee.x + scrollView.contentInset.left) / cellWidthIncludingSpacing

        targetContentOffset.pointee = CGPoint(x: round(index) * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
    }
}
