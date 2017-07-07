//
//  AddAthleticsViewController+UICollectionView.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension AddAthleticsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AthleticCategory.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let predicate = NSPredicate(format: "location contains '\(AthleticCategory.categories[indexPath.item].category)'")
        guard let dataSource = athleticDate?.athleticEvents.filter(predicate).sorted(byKeyPath: "startTime") else { return }

        tableViewDataSource = Array(dataSource)
        athleticTableView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = athleticCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! AthleticCollectionViewCell
        cell.athleticEvent = athleticDate?.athleticEvents.sorted(byKeyPath: "startTime")[indexPath.item]
        cell.category = AthleticCategory.categories[indexPath.item]
        cell.updateUI()

        return cell
    }
}
