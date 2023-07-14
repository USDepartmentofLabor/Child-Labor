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

enum ScreenType {
    case assesmentLevelByRegion
    case newDVASCountries
}

class AssesmentsPageViewController: UIPageViewController {
    
    private(set) var screenType: ScreenType?
    private var pageController: UIPageViewController?
    private var currentIndex: Int = 0
    private var advancementsArr: [AssesmentPageDetails] = [AssesmentPageDetails]()
    var colorCodes = [String: UIColor]()
    var goodsSectors = Dictionary<String, Any>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        if screenType == .assesmentLevelByRegion {
            colorCodes = ["Moderate Advancement" : UIColor(red: 36/255.0, green: 132/255.0, blue: 21/255.0, alpha: 1),
                            "Minimal Advancement" : UIColor(red: 63/255.0, green: 81/255.0, blue: 163/255.0, alpha: 1),
                            "No Assessment" : UIColor(red: 126/255.0, green: 105/255.0, blue: 165/255.0, alpha: 1),
                            "No Advancement" : UIColor(red: 202/255.0, green: 31/255.0, blue: 65/255.0, alpha: 1),
                            "Significant Advancement" : UIColor(red: 51/255.0, green: 128/255.0, blue: 116/255.0, alpha: 1)]
        } else if screenType == .newDVASCountries {
            colorCodes = ["Unknown" : UIColor(red: 63/255.0, green: 81/255.0, blue: 163/255.0, alpha: 1),
                          "N/A" : UIColor(red: 126/255.0, green: 105/255.0, blue: 165/255.0, alpha: 1),
                          "No" : UIColor(red: 202/255.0, green: 31/255.0, blue: 65/255.0, alpha: 1),
                          "Yes" : UIColor(red: 51/255.0, green: 128/255.0, blue: 116/255.0, alpha: 1)]
        }
        
        self.setupNavigationBar()
        self.parseAssesmentLevelData()
    }
    
    //MARK: - Initialisation methods.
    /// Convenience init declaration
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
    }
    
    /// Convenience delcaration for charttype view initialization.
    convenience init(screenType: ScreenType? = nil) {
        self.init(nibName: "AssesmentsPageViewController",
                  bundle: Bundle(for: AssesmentsPageViewController.self))
        self.screenType = screenType
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
        initialVC.screenType = screenType
        if advancementsArr.count > 0 {
            initialVC.chartDetails = advancementsArr[0]
        }
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true, completion: nil)
        
        self.pageController?.didMove(toParentViewController: self)
    }
    
    private func setupNavigationBar() {
        if screenType == .assesmentLevelByRegion {
            self.title = "Assesment Level By Region"
        } else if screenType == .newDVASCountries {
            self.title = "ILO Rec for Labor Inspectors Met"
        }

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
        if screenType == .assesmentLevelByRegion {
            parserModel.parseGoodsData()
        } else if screenType == .newDVASCountries {
            parserModel.parseNewDVAsCoutryData()
        }
    }
    
    private func formatAssesmentData(assesmentData : [String : Any]) {
        
        for (index, key) in assesmentData.keys.enumerated() {
            if let regionAssesmentsDict = assesmentData[key] as? [String : Any] {
                var chartSegments = [Segment]()
                for assesmentKey in regionAssesmentsDict.keys {
                    if !assesmentKey.contains("\n") {
                        let assesmentSegment = Segment.init(color: colorCodes[assesmentKey] ?? .gray, value: CGFloat(regionAssesmentsDict[assesmentKey] as! Int), title : assesmentKey, isFloatType: false)
                        chartSegments.append(assesmentSegment)
                    }
                   
                }
                if screenType == .assesmentLevelByRegion {
                    let chartDetails = AssesmentPageDetails(name: key, mainTitle: "Advancement Level for \(key)", index: index, chartData: chartSegments)
                     advancementsArr.append(chartDetails)
                } else if screenType == .newDVASCountries {
                    let chartDetails = AssesmentPageDetails(name: key, mainTitle: "ILO Rec for Labor Inspectors Met - \(key)", index: index, chartData: chartSegments)
                     advancementsArr.append(chartDetails)
                }
              
            }
        }
        
    }
    
    func setScreenType(type: ScreenType) {
        screenType = type
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
        vc.screenType = screenType
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
        vc.screenType = screenType
        return vc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.advancementsArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.currentIndex
    }
}

