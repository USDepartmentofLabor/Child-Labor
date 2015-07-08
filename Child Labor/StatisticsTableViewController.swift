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
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var attendingSchoolLabel: UILabel!
    @IBOutlet weak var combiningWorkAndSchoolLabel: UILabel!
    @IBOutlet weak var primaryCompletionRateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_xls_2013", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text == self.countryName {
                
                // Working
                if let percentageWorking = country["Children_Work_Statistics"]["Children_Work_Statistic"][0]["Total_Percentage_of_Working_Children"].element {
                    if let totalWorking = country["Children_Work_Statistics"]["Children_Work_Statistic"][0]["Total_Working_Population"].element {
                        if percentageWorking.text != nil {
                            if totalWorking.text != nil {
                                if percentageWorking.text! != "" {
                                    if totalWorking.text! != "" {
                                        workingLabel.text = String(format: "%.2f", (percentageWorking.text! as NSString).floatValue) + "% (" + String(format: "%.2f", (totalWorking.text! as NSString).floatValue) + ")"
                                        workingLabel.textColor = UIColor.darkGrayColor()
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Agriculture
                if let agriculturePercentage = country["Children_Work_Statistics"]["Children_Work_Statistic"][0]["Agriculture"].element {
                    if agriculturePercentage.text != nil {
                        if agriculturePercentage.text! != "" {
                            agricultureLabel.text = String(format: "%.2f", (agriculturePercentage.text! as NSString).floatValue) + "%"
                            agricultureLabel.textColor = UIColor.darkGrayColor()
                        }
                    }
                }
                
                // Services
                if let servicesPercentage = country["Children_Work_Statistics"]["Children_Work_Statistic"][0]["Service"].element {
                    if servicesPercentage.text != nil {
                        if servicesPercentage.text! != "" {
                            servicesLabel.text = String(format: "%.2f", (servicesPercentage.text! as NSString).floatValue) + "%"
                            servicesLabel.textColor = UIColor.darkGrayColor()
                        }
                    }
                }
                
                // Industry
                if let industryPercentage = country["Children_Work_Statistics"]["Children_Work_Statistic"][0]["Industry"].element {
                    if industryPercentage.text != nil {
                        if industryPercentage.text! != "" {
                            industryLabel.text = String(format: "%.2f", (industryPercentage.text! as NSString).floatValue) + "%"
                            industryLabel.textColor = UIColor.darkGrayColor()
                        }
                    }
                }
                
                // Attending School
                if let attendingPercentage = country["Education_Statistics_Attendance_Statistics"]["Education_Statistics_Attendance_Statistic"][0]["Percentage"].element {
                    if attendingPercentage.text != nil {
                        if attendingPercentage.text! != "" {
                            attendingSchoolLabel.text = String(format: "%.2f", (attendingPercentage.text! as NSString).floatValue) + "%"
                            attendingSchoolLabel.textColor = UIColor.darkGrayColor()
                        }
                    }
                }
                
                // Combining Work and School
                if let combiningPercentage = country["Children_Working_and_Studying_7-14_yrs_old"]["Children_Working_and_Studying_7-14_yrs_ol"][0]["Total"].element {
                    if combiningPercentage.text != nil {
                        if combiningPercentage.text! != "" {
                            combiningWorkAndSchoolLabel.text = String(format: "%.2f", (combiningPercentage.text! as NSString).floatValue) + "%"
                            combiningWorkAndSchoolLabel.textColor = UIColor.darkGrayColor()
                        }
                    }
                }
                
                // Primary Completion Rate
                if let primaryRate = country["UNESCO_Primary_Completion_Rate"]["UNESCO_Primary_Completion_Rat"][0]["Rate"].element {
                    if primaryRate.text != nil {
                        if primaryRate.text! != "" {
                            primaryCompletionRateLabel.text = String(format: "%.2f", (primaryRate.text! as NSString).floatValue) + "%"
                            primaryCompletionRateLabel.textColor = UIColor.darkGrayColor()
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
