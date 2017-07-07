//
//  AddAthleticsViewController+ViewLifeCycle.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension AddAthleticsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionViewLayout()
        setupCollectionView()
    }

    private func setupCollectionViewLayout() {
        let (width, height) = getCellWidthAndHeight()
        let layout = athleticCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
    }

    private func setupCollectionView() {
        let (width, height) = getCellWidthAndHeight()
        let insetX = (view.bounds.width - width) / 2.0
        let insetY = (view.bounds.height - height) / 2.0

        athleticCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        athleticTableView.rowHeight = UITableViewAutomaticDimension
        athleticTableView.estimatedRowHeight = 60

        athleticCollectionView.dataSource = self
        athleticCollectionView.delegate = self
    }

    private func getCellWidthAndHeight() -> (width: CGFloat, height: CGFloat) {
        let cellScaling: CGFloat = 0.79
        let screenSize = UIScreen.main.bounds.size

        return (floor(screenSize.width * cellScaling), floor(screenSize.height * cellScaling))
    }

    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        delegate?.updateCalendarCell(for: date)
    }
}
