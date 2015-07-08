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
                
                //
                if let minAgeEstablished = country["Minimum_Age_for_Work_Established"].element {
                    if minAgeEstablished.text != nil {
                        if minAgeEstablished.text! == "Yes" {
                            if let minAge = country["Minimum_Age_for_Work"].element {
                                if minAge.text != nil {
                                    if minAge.text! != "" {
                                        minimumAgeForWorkLabel.text = "Yes (" + minAge.text! + ")"
                                        minimumAgeForWorkLabel.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                                    }
                                }
                            }
                        }
                    }
                }
                
                //
                if let minHazAgeEstablished = country["Minimum_Age_for_Hazardous_Work_Established"].element {
                    if minHazAgeEstablished.text != nil {
                        if minHazAgeEstablished.text! == "Yes" {
                            if let minHazAge = country["Minimum_Age_for_Hazardous_Work"].element {
                                if minHazAge.text != nil {
                                    if minHazAge.text! != "" {
                                        minimumAgeForHazardousWorkLabel.text = "Yes (" + minHazAge.text! + ")"
                                        minimumAgeForHazardousWorkLabel.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                                    }
                                }
                            }
                        }
                    }
                }
                
                //
                if let minComAgeEstablished = country["Compulsory_Education_Age_Established"].element {
                    if minComAgeEstablished.text != nil {
                        if minComAgeEstablished.text! == "Yes" {
                            if let minComAge = country["Minimum_Age_for_Compulsory_Education"].element {
                                if minComAge.text != nil {
                                    if minComAge.text! != "" {
                                        compulsoryEducationLabel.text = "Yes (" + minComAge.text! + ")"
                                        compulsoryEducationLabel.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                                    }
                                }
                            }
                        }
                    }
                }
                
                //
                if let freeEdEstablished = country["Free_Public_Education_Established"].element {
                    if freeEdEstablished.text != nil {
                        if freeEdEstablished.text! == "Yes" {
                            freeEducationLabel.text = "Yes"
                            freeEducationLabel.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
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
