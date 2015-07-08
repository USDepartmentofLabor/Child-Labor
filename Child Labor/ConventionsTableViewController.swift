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
                if let freeEdEstablished = country["C_138_Ratified"].element {
                    if freeEdEstablished.text != nil {
                        if freeEdEstablished.text! == "Yes" {
                            ilo138Label.text = "Yes"
                            ilo138Label.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                        } else if freeEdEstablished.text! == "No" {
                            ilo138Label.text = "No"
                            ilo138Label.textColor = UIColor.redColor()
                        }
                    }
                }
                
                //
                if let freeEdEstablished = country["C_182_Ratified"].element {
                    if freeEdEstablished.text != nil {
                        if freeEdEstablished.text! == "Yes" {
                            ilo182Label.text = "Yes"
                            ilo182Label.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                        } else if freeEdEstablished.text! == "No" {
                            ilo182Label.text = "No"
                            ilo182Label.textColor = UIColor.redColor()
                        }
                    }
                }
                
                //
                if let freeEdEstablished = country["Convention_on_the_Rights_of_the_Child_Ratified"].element {
                    if freeEdEstablished.text != nil {
                        if freeEdEstablished.text! == "Yes" {
                            unCRCLabel.text = "Yes"
                            unCRCLabel.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                        } else if freeEdEstablished.text! == "No" {
                            unCRCLabel.text = "No"
                            unCRCLabel.textColor = UIColor.redColor()
                        }
                    }
                }
                
                //
                if let freeEdEstablished = country["CRC_Armed_Conflict_Ratified"].element {
                    if freeEdEstablished.text != nil {
                        if freeEdEstablished.text! == "Yes" {
                            unCRCArmedLabel.text = "Yes"
                            unCRCArmedLabel.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                        } else if freeEdEstablished.text! == "No" {
                            unCRCArmedLabel.text = "No"
                            unCRCArmedLabel.textColor = UIColor.redColor()
                        }
                    }
                }
                
                //
                if let freeEdEstablished = country["CRC_Commercial_Sexual_Exploitation_of_Children_Ratified"].element {
                    if freeEdEstablished.text != nil {
                        if freeEdEstablished.text! == "Yes" {
                            unCRCSaleLabel.text = "Yes"
                            unCRCSaleLabel.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                        } else if freeEdEstablished.text! == "No" {
                            unCRCSaleLabel.text = "No"
                            unCRCSaleLabel.textColor = UIColor.redColor()
                        }
                    }
                }
                
                //
                if let freeEdEstablished = country["Palermo_Ratified"].element {
                    if freeEdEstablished.text != nil {
                        if freeEdEstablished.text! == "Yes" {
                            unCRCTraffickingLabel.text = "Yes"
                            unCRCTraffickingLabel.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
                        } else if freeEdEstablished.text! == "No" {
                            unCRCTraffickingLabel.text = "No"
                            unCRCTraffickingLabel.textColor = UIColor.redColor()
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
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ratifications"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Convention", forIndexPath: indexPath)


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
