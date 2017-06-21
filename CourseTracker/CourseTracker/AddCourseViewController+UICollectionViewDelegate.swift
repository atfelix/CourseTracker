//
//  AddCourseViewController+UICollectionViewDelegate.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-21.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension AddCourseViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let popover = self.storyboard?.instantiateViewController(withIdentifier: "Popover") as! PopoverViewController
        popover.course = courseStore.courseFor(indexPath: indexPath)
        popover.delegate = self
        self.present(popover, animated: true, completion: nil)

        courseCollectionView.reloadData()
    }

}
