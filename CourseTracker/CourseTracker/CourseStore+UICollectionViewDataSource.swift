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
        if CourseStore.sectionsToCollapse.index(of: section) != nil {
            return CourseStore.numberOfRowsInEachGroup(section)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourseIcon", for: indexPath) as! CourseCollectionViewCell
        let course = CourseStore.courseFor(indexPath: indexPath)

        cell.courseLabel.text = course?.code ?? "NO COURSE LABEL INFO"
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CourseStore.numberOfGroups()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! DepartmentCollectionReusableView

        headerView.button.tag = indexPath.section
        headerView.button.addTarget(self, action: #selector(CourseStore.headerButtonTapped(with:)), for: .touchUpInside)

        if CourseStore.sectionsToCollapse.index(of: indexPath.section) != nil {
            headerView.button.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        }
        else {
            headerView.button.transform = CGAffineTransform(rotationAngle: 0)
        }

        headerView.departmentLabel.text = CourseStore.getGroupLabelAtIndex(indexPath.section)

        return headerView
    }

    func headerButtonTapped(with button: UIButton){
        CourseStore.headerViewTapped(with: button)
    }

    static func headerViewTapped(with button: UIButton) {

        defer { CourseStore.delegate?.reloadData() }

        button.transform = button.transform.rotated(by: CGFloat.pi/2)

        guard let index = CourseStore.sectionsToCollapse.index(of: button.tag) else {
            CourseStore.sectionsToCollapse.append(button.tag)
            return
        }
        CourseStore.sectionsToCollapse.remove(at: index)
    }
}
