//
//  LawsTableViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/7/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class LawsTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    
    @IBOutlet weak var minimumAgeForWorkLabel: UILabel!
    @IBOutlet weak var minimumAgeForHazardousWorkLabel: UILabel!
    @IBOutlet weak var compulsoryEducationLabel: UILabel!
    @IBOutlet weak var freeEducationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        for countryObj in Model.shared().countries {
            if (countryObj.country == self.countryName) {
                
                // Minimum Age for Work
                if countryObj.minimumAgeWork == "Yes" {
                    if !countryObj.minimumAgeWorkAge.isEmpty {
                        
                        // If the age field contains a slash, use it as a string and not a float
                        if countryObj.minimumAgeWorkAge.contains("/") {
                            minimumAgeForWorkLabel.text = "Yes* (" + countryObj.minimumAgeWorkAge + ")"
                        } else {
                            minimumAgeForWorkLabel.text = "Yes* (" + String(format: "%.f", (countryObj.minimumAgeWorkAge as NSString).floatValue) + ")"
                        }
                        minimumAgeForWorkLabel.textColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
                        
                    } else if countryObj.minimumAgeWork == "No" {
                        minimumAgeForWorkLabel.text = "No"
                        minimumAgeForWorkLabel.textColor = UIColor.red
                    }
                }
                // Minimum Age for Hazardous Work
              
                if countryObj.minimumAgeHazardouswork == "Yes" {
                    if !countryObj.minimumAgeHazardousworkAge.isEmpty {
                        
                        // If the age field contains a slash, use it as a string and not a float
                        if countryObj.minimumAgeHazardousworkAge.contains("/") {
                            minimumAgeForHazardousWorkLabel.text = "Yes (" + countryObj.minimumAgeHazardousworkAge + "‡)"
                        } else {
                            minimumAgeForHazardousWorkLabel.text = "Yes (" + String(format: "%.f", (countryObj.minimumAgeHazardousworkAge as NSString).floatValue) + "‡)"
                        }
                        
                        minimumAgeForHazardousWorkLabel.textColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
                        
                    } else if countryObj.minimumAgeHazardouswork == "No" {
                        minimumAgeForHazardousWorkLabel.text = "No"
                        minimumAgeForHazardousWorkLabel.textColor = UIColor.red
                    }
                }
   
                
                // Compulsory Education Age
                if countryObj.compulsoryEducationAge == "Yes" {
                    if !countryObj.compulsoryEducationAgeAge.isEmpty {
                                        
                        // If the age field contains a slash, use it as a string and not a float
                        if countryObj.compulsoryEducationAgeAge.contains("/") {
                            compulsoryEducationLabel.text = "Yes* (" + countryObj.compulsoryEducationAgeAge + "‡)"
                        } else {
                            compulsoryEducationLabel.text = "Yes* (" + String(format: "%.f", (countryObj.compulsoryEducationAgeAge as NSString).floatValue) + "‡)"
                        }

                        compulsoryEducationLabel.textColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
                        
                    } else if countryObj.compulsoryEducationAge == "No" {
                        compulsoryEducationLabel.text = "No"
                        compulsoryEducationLabel.textColor = UIColor.red
                    }
                }
                
                // Free Public Education
                if countryObj.freePublicEducation == "Yes" {
                    freeEducationLabel.text = "Yes"
                    freeEducationLabel.textColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
                } else if countryObj.freePublicEducation == "No" {
                    freeEducationLabel.text = "No"
                    freeEducationLabel.textColor = UIColor.red
                }
                
                break;
            }
        }
        
        // Footer
        // * - Does Not Meet International Standards. † - Age calculated based on available information.

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.lawsList)
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
        return 4
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Law", forIndexPath: indexPath)

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
