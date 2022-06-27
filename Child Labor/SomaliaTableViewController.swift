//
//  SomaliaTableViewController.swift
//  Child Labor
//
//  Created by Sanganal, Akshay on 8/28/17.
//  Copyright © 2017 U.S. Department of Labor. All rights reserved.
//

import UIKit

class SomaliaTableViewController: UITableViewController {
    
    var countryName = "Somalia"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Somalia Statistics Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        self.addTableViewFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTableViewFooter() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        customView.backgroundColor = UIColor.clear
        let button = UIButton(frame: CGRect(x: 20, y: 0, width: self.tableView.frame.width - 40, height: 50))
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize:20)
        button.backgroundColor = .lightGray.withAlphaComponent(0.8)
        button.layer.cornerRadius = 20
        button.setTitle("Open Analysis", for: .normal)
        button.addTarget(self, action: #selector(openWorkingStatics), for: .touchUpInside)
        customView.addSubview(button)
        self.tableView.tableFooterView = customView
        
    }
    
    @objc func openWorkingStatics(_ sender: UIButton!) {
        
        let viewController = PieChartViewController()
        viewController.isFromWorkingStatistics = true
        viewController.workingStatistics = [Segment]()
        viewController.countryName = self.countryName
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1 || section == 5 || section == 6) {
            return 2
        }
        return (section == 0) ? 0 : 1
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.gray
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.gray
    }

}
