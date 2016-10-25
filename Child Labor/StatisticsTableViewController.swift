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
    
    @IBOutlet weak var workingContentView: UIView!
    @IBOutlet weak var workingHeader: UILabel!
    @IBOutlet weak var agricultureHeader: UILabel!
    @IBOutlet weak var industryHeader: UILabel!
    @IBOutlet weak var servicesHeader: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.workingContentView.accessibilityElements = [
            self.workingHeader,
            self.workingLabel,
            self.agricultureHeader,
            self.agricultureLabel,
            self.industryHeader,
            self.industryLabel,
            self.servicesHeader,
            self.servicesLabel
        ]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Statistics Screen")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_2015", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text == self.countryName {
                
                let statistics = country["Country_Statistics"]
                
                // Working
                if let percentageWorking = statistics["Children_Work_Statistics"]["Total_Percentage_of_Working_Children"].element {
                    if let totalWorking = statistics["Children_Work_Statistics"]["Total_Working_Population"].element {
                        if let ageRange = statistics["Children_Work_Statistics"]["Age_Range"].element {
                            if percentageWorking.text != nil {
                                if ageRange.text != nil {
                                    if percentageWorking.text! != "" {
                                        if ageRange.text! != "" {
                                            var numberWithCommas = "0"
                                            if ((totalWorking.text != nil && totalWorking.text! != "")) {
                                                let largeNumber = Int(String(format: "%.f", (totalWorking.text! as NSString).floatValue))
                                                let numberFormatter = NSNumberFormatter()
                                                numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                                                numberWithCommas = numberFormatter.stringFromNumber(largeNumber!)!
                                            }

                                            if (numberWithCommas != "0") {
                                                workingLabel.text = String(format: "%.1f", (percentageWorking.text! as NSString).floatValue) + "% (" + numberWithCommas + "; ages " + ageRange.text! + ")"
                                            }
                                            else {
                                                workingLabel.text = String(format: "%.1f", (percentageWorking.text! as NSString).floatValue) + "% (ages " + ageRange.text! + ")"
                                            }
                                            workingLabel.textColor = UIColor.blackColor()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Agriculture
                if let agriculturePercentage = statistics["Children_Work_Statistics"]["Agriculture"].element {
                    if agriculturePercentage.text != nil {
                        if agriculturePercentage.text! != "" {
                            agricultureLabel.text = String(format: "%.1f", (agriculturePercentage.text! as NSString).floatValue) + "%"
                            agricultureLabel.textColor = UIColor.blackColor()
                        }
                    }
                }
                
                // Services
                if let servicesPercentage = statistics["Children_Work_Statistics"]["Services"].element {
                    if servicesPercentage.text != nil {
                        if servicesPercentage.text! != "" {
                            servicesLabel.text = String(format: "%.1f", (servicesPercentage.text! as NSString).floatValue) + "%"
                            servicesLabel.textColor = UIColor.blackColor()
                        }
                    }
                }
                
                // Industry
                if let industryPercentage = statistics["Children_Work_Statistics"]["Industry"].element {
                    if industryPercentage.text != nil {
                        if industryPercentage.text! != "" {
                            industryLabel.text = String(format: "%.1f", (industryPercentage.text! as NSString).floatValue) + "%"
                            industryLabel.textColor = UIColor.blackColor()
                        }
                    }
                }
                
                // Attending School
                if let attendingPercentage = statistics["Education_Statistics_Attendance_Statistics"]["Percentage"].element {
                    if let attendingAgeRange = statistics["Education_Statistics_Attendance_Statistics"]["Age_Range"].element {
                        if attendingPercentage.text != nil {
                            if attendingAgeRange.text != nil {
                                if attendingPercentage.text! != "" {
                                    if attendingAgeRange.text! != "" {
                                        attendingSchoolLabel.text = String(format: "%.1f", (attendingPercentage.text! as NSString).floatValue) + "% (ages " + attendingAgeRange.text! + ")"
                                        attendingSchoolLabel.textColor = UIColor.blackColor()
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Combining Work and School
                if let combiningPercentage = statistics["Children_Working_and_Studying_7-14_yrs_old"]["Total"].element {
                    if let combiningAgeRange = statistics["Children_Working_and_Studying_7-14_yrs_old"]["Age_Range"].element {
                        if combiningPercentage.text != nil {
                            if combiningAgeRange.text != nil {
                                if combiningPercentage.text! != "" {
                                    if combiningAgeRange.text! != "" {
                                        combiningWorkAndSchoolLabel.text = String(format: "%.1f", (combiningPercentage.text! as NSString).floatValue) + "% (ages " + combiningAgeRange.text! + ")"
                                        combiningWorkAndSchoolLabel.textColor = UIColor.blackColor()
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Primary Completion Rate
                if let primaryRate = statistics["UNESCO_Primary_Completion_Rate"]["Rate"].element {
                    if primaryRate.text != nil {
                        if primaryRate.text! != "" {
                            primaryCompletionRateLabel.text = String(format: "%.1f", (primaryRate.text! as NSString).floatValue) + "%"
                            primaryCompletionRateLabel.textColor = UIColor.blackColor()
                       }
                    }
                }
                
                break;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
