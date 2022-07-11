//
//  AssesmentsPageViewController.swift
//  Child Labor
//
//  Created by Gnanendra Kumar on 06/07/22.
//  Copyright © 2022 U.S. Department of Labor. All rights reserved.
//


import Foundation
import UIKit


struct AssesmentPageDetails {
    var name: String
    var mainTitle: String
    var index: Int
    var chartData: [Segment]
}

class AssesmentsPageViewController: UIPageViewController {
    
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var advancementsArr: [AssesmentPageDetails] = [AssesmentPageDetails]()
    
    var colorCodes = ["Moderate Advancement" : UIColor(red: 57.0/255.0, green: 89.0/255.0, blue: 122.0/255.0, alpha: 1),
                          "Minimal Advancement" : UIColor(red: 147.0/255.0, green: 78.0/255.0, blue: 80.0/255.0, alpha: 1),
                          "No Assessment" : UIColor(red: 108.0/255.0, green: 129.0/255.0, blue: 79.0/255.0, alpha: 1),
                          "No Advancement" : UIColor(red: 218.0/255.0, green: 142.0/255.0, blue: 57.0/255.0, alpha: 1),
                          "Significant Advancement" : UIColor(red: 130.0/255.0, green: 152.0/255.0, blue: 143.0/255.0, alpha: 1)]
    var goodsSectors = Dictionary<String, Any>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        self.setupNavigationBar()
        self.parseAssesmentLevelData()
    }
    
    private func setupPageController() {
        
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        self.pageController?.view.backgroundColor = .clear
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height)
        self.addChildViewController(self.pageController!)
        self.view.addSubview(self.pageController!.view)
        
        let initialVC = AssesmentsPieChartViewController.loadFromNib()
        if advancementsArr.count > 0 {
            initialVC.chartDetails = advancementsArr[0]
        }
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParentViewController: self)
    }
    
    private func setupNavigationBar() {
        
        self.title = "Assesment Level By Region"

        // Navigation bar color
        self.navigationController?.navigationBar.topItem?.title = " "
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
            appearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        }
    }
    
    private func parseAssesmentLevelData() {
        let parserModel = AssesmentLevelParser()
        parserModel.onCompletionGoodsParsing = { [weak self] goodsData in
            guard let self = self else { return }
            self.goodsSectors = goodsData as [String : Any]
            self.formatAssesmentData(assesmentData: self.goodsSectors)
            self.setupPageController()
        }
        parserModel.parseGoodsData()
    }
    
    private func formatAssesmentData(assesmentData : [String : Any]) {
        
        for (index, key) in assesmentData.keys.enumerated() {
            if let regionAssesmentsDict = assesmentData[key] as? [String : Any] {
                var chartSegments = [Segment]()
                for assesmentKey in regionAssesmentsDict.keys {
                    let assesmentSegment = Segment.init(color: colorCodes[assesmentKey] ?? .gray, value: CGFloat(regionAssesmentsDict[assesmentKey] as! Int), title : assesmentKey, isFloatType: false)
                    chartSegments.append(assesmentSegment)
                }
               let chartDetails = AssesmentPageDetails(name: key, mainTitle: "Advancement Level for \(key)", index: index, chartData: chartSegments)
                advancementsArr.append(chartDetails)
            }
        }
        
    }
}

extension AssesmentsPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? AssesmentsPieChartViewController else {
            return nil
        }
        
        var index = currentVC.chartDetails.index
        
        if index == 0 {
            return nil
        }
        
        index -= 1
        
        let vc: AssesmentsPieChartViewController = AssesmentsPieChartViewController.loadFromNib()
        vc.chartDetails = advancementsArr[index]
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentVC = viewController as? AssesmentsPieChartViewController else {
            return nil
        }
        
        var index = currentVC.chartDetails.index
        
        if index >= self.advancementsArr.count - 1 {
            return nil
        }
        
        index += 1
        
        let vc: AssesmentsPieChartViewController =  AssesmentsPieChartViewController.loadFromNib()
        vc.chartDetails = advancementsArr[index]
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.advancementsArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}

