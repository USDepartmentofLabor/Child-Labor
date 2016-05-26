//
//  SuggestedActionsTableViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/7/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class CoordinationTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    
    var coordination = NSMutableArray()
    var policies = NSMutableArray()
    var programs = NSMutableArray()

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
        tracker.set(kGAIScreenName, value: "Suggested Actions Screen")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_for_app", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        let dataXML = SWXMLHash.parse(contents as! String)
        
        coordination.addObject("Department of the State Coordinator for Combatting Trafficking in Persons within the Ministry of Security (MOS)")
        
        coordination.addObject("Strike Force for Combatting Trafficking in Persons and Organized Illegal Migration (Anti-Trafficking Strike Force)")
        
        coordination.addObject("Inter-Ministerial Working Group (Monitoring Team)")
        
        policies.addObject("Decade of Roma Inclusion (2005–2015) and Action Plan (2013–2016)*")
        
        policies.addObject("Action Plan for Children of Bosnia and Herzegovina (2011–2014)*")
        
        policies.addObject("Strategy to Counter Trafficking in Human Beings and Action Plan (2013–2015)")
        
        policies.addObject("Action Plan for Child Protection and Prevention of Violence against Children through Information-Communications Technologies (2014–2015)†")
        
        policies.addObject("Policy for the Protection of Children Deprived of Parental Care and Families at Risk of Separation in FBiH (2006–2016) and Action Plan (2013–2016)*")
        
        programs.addObject("Ministry of Human Rights and Refugees (MHRR) Funding*‡")
        
        programs.addObject("Registration Project*")
        
        programs.addObject("Daily Centers and Crisis Centers‡")
        
        programs.addObject("Enhancing the Social Protection and Inclusion System for Children in BiH (2008–2015)‡")
        
        programs.addObject("Assistance for Trafficking Victims‡")
        
        programs.addObject("Implementation of the Strategy to Counter Trafficking in Human Beings (2013–2015)‡")
        
        programs.addObject("Fight Against Trafficking in Human Beings and Organized Crime—Phase 2 (2014–2017)†")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Coordination"
        case 1:
            return "Policies"
        default:
            return "Programs"
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            if coordination.count == 0 {
                return "No Actions"
            }
        case 1:
            if policies.count == 0 {
                return "No Actions"
            }
        default:
            if programs.count == 0 {
                return "No Actions"
            }
        }
        
        return ""
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return coordination.count
        case 1:
            return policies.count
        default:
            return programs.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Action", forIndexPath: indexPath)

        let title : UILabel? = cell.viewWithTag(111) as? UILabel
        
        switch indexPath.section {
        case 0:
            title?.text = coordination[indexPath.row] as? String
        case 1:
            title?.text = policies[indexPath.row] as? String
        default:
            title?.text = programs[indexPath.row] as? String
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
