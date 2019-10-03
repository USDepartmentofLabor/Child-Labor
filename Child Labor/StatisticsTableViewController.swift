//
//  StatisticsTableViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/7/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class StatisticsTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    
    
    @IBOutlet weak var workingLabel: UILabel!
    @IBOutlet weak var agricultureLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var attendingSchoolLabel: UILabel!
    @IBOutlet weak var combiningWorkAndSchoolLabel: UILabel!
    @IBOutlet weak var primaryCompletionRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Statistics Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents! as String)
        
        for country in countriesXML["Countries"]["Country"].all {
            if country["Name"].element?.text == self.countryName {
                
                let statistics = country["Country_Statistics"]
                
                // Working
                if let percentageWorking = statistics["Children_Work_Statistics"]["Total_Percentage_of_Working_Children"].element {
                    if let totalWorking = statistics["Children_Work_Statistics"]["Total_Working_Population"].element {
                        if let ageRange = statistics["Children_Work_Statistics"]["Age_Range"].element {
                            if percentageWorking.text != nil {
                                if ageRange.text != nil {
                                    if percentageWorking.text != "" {
                                        if ageRange.text != "" {
                                            var numberWithCommas = "0"
                                            
                                            
                                            
                                            
                                            if ((totalWorking.text != nil && totalWorking.text != "")) {
                                                let largeNumber = Int(String(format: "%.f", (totalWorking.text as NSString).floatValue))
                                                let numberFormatter = NumberFormatter()
                                                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                                                numberWithCommas = numberFormatter.string(from: NSNumber(value: largeNumber!))!
                                            }
                                            
                                            if (numberWithCommas != "0") {
                                                workingLabel.text = String(format: "%.1f", (percentageWorking.text as NSString).floatValue * 100.0) + "% (" + numberWithCommas + "; ages " + ageRange.text + ")"
                                            }
                                            else {
                                                workingLabel.text = String(format: "%.1f", (percentageWorking.text as NSString).floatValue * 100.0) + "% (ages " + ageRange.text + ")"
                                            }
                                            workingLabel.textColor = UIColor.black
                                        }
                                    }
                                    
                                    if (percentageWorking.text == "Unavailable" || percentageWorking.text == "unavailable") {
                                        workingLabel.text = "Unavailable"
                                        workingLabel.textColor = UIColor.black
                                    }
                                    
                                    if percentageWorking.text == "N/A" {
                                        workingLabel.text = "N/A"
                                        workingLabel.textColor = UIColor.black
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                if #available(iOS 13.0, *) {
                    workingLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }

                
                // Agriculture
                if let agriculturePercentage = statistics["Children_Work_Statistics"]["Agriculture"].element {
                    if agriculturePercentage.text != nil {
                        if agriculturePercentage.text != "" {
                            agricultureLabel.text = String(format: "%.1f", (agriculturePercentage.text as NSString).floatValue * 100.0) + "%"
                            agricultureLabel.textColor = UIColor.black
                        }
                    }
                    if (agriculturePercentage.text == "Unavailable" || agriculturePercentage.text == "unavailable")
                    {
                        agricultureLabel.text = "Unavailable"
                        agricultureLabel.textColor = UIColor.black
                    }
                    if agriculturePercentage.text == "N/A"
                    {
                        agricultureLabel.text = "N/A"
                        agricultureLabel.textColor = UIColor.black
                    }
                   
                }
                if #available(iOS 13.0, *) {
                    agricultureLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }
                
                
                // Services
                if let servicesPercentage = statistics["Children_Work_Statistics"]["Services"].element {
                    if servicesPercentage.text != nil {
                        if servicesPercentage.text != "" {
                            servicesLabel.text = String(format: "%.1f", (servicesPercentage.text as NSString).floatValue * 100.0) + "%"
                            servicesLabel.textColor = UIColor.black
                        }
                    }
                    if (servicesPercentage.text == "Unavailable" || servicesPercentage.text == "unavailable")
                    {
                        servicesLabel.text = "Unavailable"
                        servicesLabel.textColor = UIColor.black
                    }
                    if servicesPercentage.text == "N/A"
                    {
                        servicesLabel.text = "N/A"
                        servicesLabel.textColor = UIColor.black
                    }
                   
                }
                if #available(iOS 13.0, *) {
                    servicesLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }

                
                // Industry
                if let industryPercentage = statistics["Children_Work_Statistics"]["Industry"].element {
                    if industryPercentage.text != nil {
                        if industryPercentage.text != "" {
                            industryLabel.text = String(format: "%.1f", (industryPercentage.text as NSString).floatValue * 100.0) + "%"
                            industryLabel.textColor = UIColor.black
                        }
                    }
                    if (industryPercentage.text == "Unavailable" || industryPercentage.text == "unavailable")
                    {
                        industryLabel.text = "Unavailable"
                        industryLabel.textColor = UIColor.black
                    }
                    if industryPercentage.text == "N/A"
                    {
                        industryLabel.text = "N/A"
                        industryLabel.textColor = UIColor.black
                    }
                }
                if #available(iOS 13.0, *) {
                    industryLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }

                
                // Attending School
                if let attendingPercentage = statistics["Education_Statistics_Attendance_Statistics"]["Percentage"].element {
                    if let attendingAgeRange = statistics["Education_Statistics_Attendance_Statistics"]["Age_Range"].element {
                        if attendingPercentage.text != nil {
                            if attendingPercentage.text == "Unavailable"
                            {
                                attendingSchoolLabel.text = "Unavailable"
                                attendingSchoolLabel.textColor = UIColor.black
                            }
                            else if attendingPercentage.text == "N/A"
                            {
                                attendingSchoolLabel.text = "N/A"
                                attendingSchoolLabel.textColor = UIColor.black
                            }
                            else {
                            if attendingAgeRange.text != nil {
                                if attendingPercentage.text != "" {
                                    if attendingAgeRange.text != "" {
                                        attendingSchoolLabel.text = String(format: "%.1f", (attendingPercentage.text as NSString).floatValue * 100.0) + "% (ages " + attendingAgeRange.text + ")"
                                        attendingSchoolLabel.textColor = UIColor.black
                                    }
                                }
                                
                            }
                            }
                        }
                    }
                }
                if #available(iOS 13.0, *) {
                    attendingSchoolLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }

                
                
                
                // Combining Work and School
                if let combiningPercentage = statistics["Children_Working_and_Studying_7-14_yrs_old"]["Total"].element {
                    if let combiningAgeRange = statistics["Children_Working_and_Studying_7-14_yrs_old"]["Age_Range"].element {
                        if combiningPercentage.text != nil {
                            
                                if combiningAgeRange.text != nil {
                                    if combiningPercentage.text != "" {
                                        if combiningAgeRange.text != "" {
                                            combiningWorkAndSchoolLabel.text = String(format: "%.1f", (combiningPercentage.text as NSString).floatValue * 100.0) + "% (ages " + combiningAgeRange.text + ")"
                                            combiningWorkAndSchoolLabel.textColor = UIColor.black
                                        }
                                    }
                                }
                            if combiningPercentage.text == "Unavailable"
                            {
                                combiningWorkAndSchoolLabel.text = "Unavailable"
                                combiningWorkAndSchoolLabel.textColor = UIColor.black
                            }
                            
                            
                            if combiningPercentage.text == "N/A"
                            {
                                combiningWorkAndSchoolLabel.text = "N/A"
                                combiningWorkAndSchoolLabel.textColor = UIColor.black
                            }
                        
                        }
                        
                        
                    }
                }
                if #available(iOS 13.0, *) {
                    combiningWorkAndSchoolLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }

                
                // Primary Completion Rate
                if let primaryRate = statistics["UNESCO_Primary_Completion_Rate"]["Rate"].element {
                    if primaryRate.text != nil {
                        if primaryRate.text != "" {
                            primaryCompletionRateLabel.text = String(format: "%.1f", (primaryRate.text as NSString).floatValue * 100.0) + "%"
                            primaryCompletionRateLabel.textColor = UIColor.black
                        }
                    }
                    
                    if primaryRate.text == "Unavailable"
                    {
                        primaryCompletionRateLabel.text = "Unavailable"
                        primaryCompletionRateLabel.textColor = UIColor.black
                    }
                    
                    if primaryRate.text == "N/A"
                    {
                        primaryCompletionRateLabel.text = "N/A"
                        primaryCompletionRateLabel.textColor = UIColor.black
                    }
                }
                if #available(iOS 13.0, *) {
                    primaryCompletionRateLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }

                
                break;
            }
        }
  
    }



    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 100000, bottom: 0, right: 0)
    }
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    


}
