//
//  DataVisualizationTableViewController.swift
//  Child Labor
//
//  Created by Gnanendra Kumar on 12/05/22.
//  Copyright © 2022 U.S. Department of Labor. All rights reserved.
//

import UIKit

enum ChartTypes: String, CaseIterable {
    
    case proportionalChart = "Proportional Area Chart"
    case pieChart = "Goods By Sector And Region"
}
class DataVisualizationTableViewController: UITableViewController {
   
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.sendGAIEvent()
        self.setupNavigationBar()
        self.setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "DataVisualization Types"
    }
    
    func sendGAIEvent() {
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "DataVisualization List Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as? [AnyHashable: Any])
    }
    
    func setupNavigationBar() {
        
        // Navigation bar color
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
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

extension DataVisualizationTableViewController {
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ChartTypes.allCases.count
     }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell()
        
        let chartType = ChartTypes.allCases[indexPath.row]
        cell.textLabel?.text = chartType.rawValue
       
         let chevron = UIImage(named: "arrow.png")
         cell.accessoryType = .disclosureIndicator
         cell.accessoryView = UIImageView(image: chevron)
         if #available(iOS 13.0, *) {
             cell.textLabel?.textColor = .label
         } else {
             // Fallback on earlier versions
         }
         return cell
     }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc: UIViewController?
        let chartType = ChartTypes.allCases[indexPath.row]

        switch chartType {
        case .proportionalChart:
            vc = ProportionalChartViewController.loadFromNib()
            break
        case .pieChart:
            vc = PieChartViewController.loadFromNib()
            break
        default:
            vc = ProportionalChartViewController.loadFromNib()
            break
        }
 
        guard let viewController = vc else { return }
        navigationController?.pushViewController(viewController, animated: true)

    }
}



@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue
              layer.masksToBounds = (newValue > 0)
        }
    }
}
