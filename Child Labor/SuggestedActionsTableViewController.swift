//
//  SuggestedActionsTableViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/7/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class SuggestedActionsTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    
    var laws = NSMutableArray()
    var enforcement = NSMutableArray()
    var coordination = NSMutableArray()
    var governmentPolicies = NSMutableArray()
    var socialPrograms = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Suggested Actions Screen")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_for_app_2013", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        var dataXML = SWXMLHash.parse(contents as! String)
        
        // For each country
        for country in dataXML["Countries"]["Country"] {
            if country["Name"].element?.text == countryName {
                
                for action in country["Suggested_Actions"]["Laws"]["Action"] {
                    laws.addObject((action["Name"].element?.text!)!)
                }
                for action in country["Suggested_Actions"]["Enforcement"]["Action"] {
                    enforcement.addObject((action["Name"].element?.text!)!)
                }
                for action in country["Suggested_Actions"]["Coordination"]["Action"] {
                    coordination.addObject((action["Name"].element?.text!)!)
                }
                for action in country["Suggested_Actions"]["Government_Policies"]["Action"] {
                    governmentPolicies.addObject((action["Name"].element?.text!)!)
                }
                for action in country["Suggested_Actions"]["Social_Programs"]["Action"] {
                    socialPrograms.addObject((action["Name"].element?.text!)!)
                }
                
                break
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
        return 5
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Laws"
        case 1:
            return "Enforcement"
        case 2:
            return "Coordination"
        case 3:
            return "Government Policies"
        default:
            return "Social Programs"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return laws.count
        case 1:
            return enforcement.count
        case 2:
            return coordination.count
        case 3:
            return governmentPolicies.count
        default:
            return socialPrograms.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Action", forIndexPath: indexPath)

        let title : UILabel? = cell.viewWithTag(101) as? UILabel
        
        switch indexPath.section {
        case 0:
            title?.text = laws[indexPath.row] as? String
        case 1:
            title?.text = enforcement[indexPath.row] as? String
        case 2:
            title?.text = coordination[indexPath.row] as? String
        case 3:
            title?.text = governmentPolicies[indexPath.row] as? String
        default:
            title?.text = socialPrograms[indexPath.row] as? String
        }


        return cell
    }

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
