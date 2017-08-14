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
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Suggested Actions Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let dataXML = SWXMLHash.parse(contents as! String)
        
        // For each country
        for country in dataXML["Countries"]["Country"] {
            if country["Name"].element?.text == countryName {
                
                // Duping these to accomodate inconsistent element name in the XML
                for action in country["Suggested_Actions"]["Legal_Framework"]["Action"] {
                    laws.add((action["Name"].element?.text!)!)
                }
                for action in country["Suggested_Actions"]["Laws"]["Action"] {
                    laws.add((action["Name"].element?.text!)!)
                }
                
                for action in country["Suggested_Actions"]["Enforcement"]["Action"] {
                    enforcement.add((action["Name"].element?.text!)!)
                }
                
                for action in country["Suggested_Actions"]["Coordination"]["Action"] {
                    coordination.add((action["Name"].element?.text!)!)
                }
                
                // Duping these to accomodate inconsistent element name in the XML
                for action in country["Suggested_Actions"]["Government_Policies"]["Action"] {
                    governmentPolicies.add((action["Name"].element?.text!)!)
                }
                for action in country["Suggested_Actions"]["Policies"]["Action"] {
                    governmentPolicies.add((action["Name"].element?.text!)!)
                }
                
                for action in country["Suggested_Actions"]["Social_Programs"]["Action"] {
                    socialPrograms.add((action["Name"].element?.text!)!)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Legal Standards"
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
    
//    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            if laws.count == 0 {
//                return "No Actions"
//            }
//        case 1:
//            if enforcement.count == 0 {
//                return "No Actions"
//            }
//        case 2:
//            if coordination.count == 0 {
//                return "No Actions"
//            }
//        case 3:
//            if governmentPolicies.count == 0 {
//                return "No Actions"
//            }
//        default:
//            if socialPrograms.count == 0 {
//                return "No Actions"
//            }
//        }
//        
//        return ""
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Action", for: indexPath)

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
