//
//  CourseStore+UICollectionViewDataSource.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-21.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension CourseStore: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sectionsToCollapse.index(of: section) != nil {
            return numberOfRowsInEachGroup(section)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseIcon", for: indexPath) as! CourseCollectionViewCell
        let course = courseFor(indexPath: indexPath)
        
        cell.courseLabel.text = course?.code
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfGroups()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? DepartmentCollectionReusableView else {
            return UICollectionReusableView()
        }

        headerView.button.tag = indexPath.section
        headerView.button.addTarget(self, action: #selector(headerButtonTapped(with:)), for: .touchUpInside)

        if sectionsToCollapse.index(of: indexPath.section) != nil {
            headerView.button.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        }
        else {
            headerView.button.transform = CGAffineTransform(rotationAngle: 0)
        }

        headerView.departmentLabel.text = getGroupLabelAtIndex(indexPath.section)

        headerView.backgroundColor = .black

        return headerView
    }

    func headerButtonTapped(with button: UIButton){

        defer { delegate.reloadData() }
        
        //rotate the button
        button.transform = button.transform.rotated(by: CGFloat.pi/2)

        guard let index = sectionsToCollapse.index(of: button.tag) else {
            sectionsToCollapse.append(button.tag)
            return
        }
        sectionsToCollapse.remove(at: index)
    }
}
