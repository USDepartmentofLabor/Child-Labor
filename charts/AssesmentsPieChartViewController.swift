//
//  AssesmentsPieChartViewController.swift
//  Child Labor
//
//  Created by Gnanendra Kumar on 07/07/22.
//  Copyright © 2022 U.S. Department of Labor. All rights reserved.
//

import Foundation
import UIKit

class AssesmentsPieChartViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var centerCircularView : UIView!
    @IBOutlet weak var circularPieView : CircularSliceView!
    
    @IBOutlet weak var colorCodesCollectionView : UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    var chartDetails: AssesmentPageDetails!
    
    var chartOrderedArr = ["Significant Advancement", "Moderate Advancement", "Minimal Advancement", "No Advancement", "No Assessment"]
        
    private(set) var leadingSpace = UIDevice.isIPad() ? 16.0 : 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = self.chartDetails.mainTitle
        self.setupCollectionView()
        self.setupPieChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupCollectionView() {
        
        self.colorCodesCollectionView.layer.borderColor = UIColor.black.cgColor
        self.colorCodesCollectionView.layer.borderWidth = 2
        
        if #available(iOS 12.0, *) {
            if (self.traitCollection.userInterfaceStyle == .dark) {
                self.colorCodesCollectionView.backgroundColor = .black
                self.colorCodesCollectionView.layer.borderColor = UIColor.white.cgColor
            }
        }
        
        self.colorCodesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCollectionCell")
        self.colorCodesCollectionView.register(UINib(nibName:"CustomColorCodeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomColorCodeCollectionViewCell")
    }
    
    private func setupPieChart() {
        self.centerCircularView.layer.cornerRadius = 55
        circularPieView.segments = (chartDetails.chartData.count > 0) ? chartDetails.chartData : [Segment]()
                
        let chartTitles = chartDetails.chartData.map { $0.title }
        chartOrderedArr = chartOrderedArr.filter{ chartTitles.contains($0) }
    }
}

// MARK: - UICollectionView Delegate & Datasource
extension AssesmentsPieChartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartOrderedArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCollectionCell", for: indexPath)
        
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomColorCodeCollectionViewCell", for: indexPath) as? CustomColorCodeCollectionViewCell else {
            return cell
        }
        let currentTitleValue = chartOrderedArr[indexPath.item]
        let chartData = chartDetails.chartData.filter{($0.title == currentTitleValue)}
        let title = chartData[0].title
        let color = chartData[0].color
        colorCell.lblTitle.numberOfLines = 2
        colorCell.lblTitle.text = title
        colorCell.colorCodeLbl.backgroundColor = color
        
        if #available(iOS 12.0, *) {
            if (self.traitCollection.userInterfaceStyle == .dark) {
                colorCell.lblTitle.textColor = .white
            }
        } else {
            colorCell.lblTitle.textColor = .black
        }
        
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize = .zero
        
        if UIDevice.isIPad() {
            size = self.getIpadSize(with: leadingSpace)
        } else {
            let screenWidth = UIScreen.main.bounds.size.width
            let cellDimension = screenWidth - leadingSpace
            size = CGSize(width: cellDimension, height: 40)
        }
        
        return size
    }
    
    func getIpadSize(with lineSpacing: CGFloat = 0.0) -> CGSize {
        let deviceWidth = UIScreen.main.bounds.size.width
        var size = CGSize.zero
        let currentOrientation = UIDevice.current.currentOrientation
        let portraitDimension = deviceWidth - lineSpacing
        let landScapeDimension = deviceWidth - lineSpacing
        let portraitSize = CGSize(width: portraitDimension, height: 50)
        let landscapeSize = CGSize(width: landScapeDimension, height: 50)
        switch currentOrientation {
        case .portrait, .portraitUpsideDown:
            size = portraitSize
        default :
            size = landscapeSize
        }
        return size
    }
    
}
