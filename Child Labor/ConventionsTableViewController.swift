//
//  ConventionsTableViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/7/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class ConventionsTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    
    @IBOutlet weak var ilo138Label: UILabel!
    @IBOutlet weak var ilo182Label: UILabel!
    @IBOutlet weak var unCRCLabel: UILabel!
    @IBOutlet weak var unCRCArmedLabel: UILabel!
    @IBOutlet weak var unCRCSaleLabel: UILabel!
    @IBOutlet weak var unCRCTraffickingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        for countryObj in Model.shared().countries {
            if (countryObj.country == self.countryName) {
                
                // Minimum Age
                if countryObj.iloC138 == "Yes" {
                    ilo138Label.text = "Yes"
                    ilo138Label.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.1, alpha: 1.0)
                } else if countryObj.iloC138 == "No" {
                    ilo138Label.text = "No"
                    ilo138Label.textColor = UIColor.red
                } else if countryObj.iloC138 == "N/A" {
                    ilo138Label.text = "N/A"
                } else {
                    ilo138Label.text = "N/A"
                }
                if #available(iOS 13.0, *) {
                    ilo138Label.textColor = .label
                } else {
                    // Fallback on earlier versions
                }
                
                // Worst Forms of Child Labor
                if countryObj.iloC182 == "Yes" {
                    ilo182Label.text = "Yes"
                    ilo182Label.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.1, alpha: 1.0)
                } else if countryObj.iloC182 == "No" {
                    ilo182Label.text = "No"
                    ilo182Label.textColor = UIColor.red
                } else if countryObj.iloC182 == "N/A" {
                    ilo182Label.text = "N/A"
                }
                if #available(iOS 13.0, *) {
                    ilo182Label.textColor = .label
                } else {
                    // Fallback on earlier versions
                }
                
                // UN CRC
                if countryObj.unCrc == "Yes" {
                    unCRCLabel.text = "Yes"
                    unCRCLabel.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.1, alpha: 1.0)
                } else if countryObj.unCrc == "No" {
                    unCRCLabel.text = "No"
                    unCRCLabel.textColor = UIColor.red
                } else if countryObj.unCrc == "N/A" {
                    unCRCLabel.text = "N/A"
                }
                if #available(iOS 13.0, *) {
                    unCRCLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }
                
                // Armed Conflict
                if countryObj.unCrcAc == "Yes" {
                    unCRCArmedLabel.text = "Yes"
                    unCRCArmedLabel.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.1, alpha: 1.0)
                } else if countryObj.unCrcAc == "No" {
                    unCRCArmedLabel.text = "No"
                    unCRCArmedLabel.textColor = UIColor.red
                } else if countryObj.unCrcAc == "N/A" {
                    unCRCArmedLabel.text = "N/A"
                }
                if #available(iOS 13.0, *) {
                    unCRCArmedLabel.textColor = .label
                    
                } else {
                    // Fallback on earlier versions
                }
                
                // Sexual Exploitation
                if countryObj.unCrcCsec == "Yes" {
                    unCRCSaleLabel.text = "Yes"
                    unCRCSaleLabel.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.1, alpha: 1.0)
                } else if countryObj.unCrcCsec == "No" {
                    unCRCSaleLabel.text = "No"
                    unCRCSaleLabel.textColor = UIColor.red
                } else if countryObj.unCrcCsec == "N/A" {
                    unCRCSaleLabel.text = "N/A"
                }
                if #available(iOS 13.0, *) {
                    unCRCSaleLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }
                
                // Trafficking
                if countryObj.palermoProtocol == "Yes" {
                    unCRCTraffickingLabel.text = "Yes"
                    unCRCTraffickingLabel.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.1, alpha: 1.0)
                } else if countryObj.palermoProtocol == "No" {
                    unCRCTraffickingLabel.text = "No"
                    unCRCTraffickingLabel.textColor = UIColor.red
                } else if countryObj.palermoProtocol == "N/A" {
                    unCRCTraffickingLabel.text = "N/A"
                }
                if #available(iOS 13.0, *) {
                    unCRCTraffickingLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }
                
                break;
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.conventions, metaData: self.countryName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ratifications"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
}
