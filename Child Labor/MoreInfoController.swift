//
//  MoreInfoController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/31/15.
//  Copyright © 2015 U.S. Department of Labor. All rights reserved.
//

import UIKit

class MoreInfoController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure the ugly table cell selection is cleared when returning to this view
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(tableIndex, animated: false)
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 1
        }
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // Allow more info view to be closed
    @IBAction func dismissMoreInfo(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Load content for the selected web view
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentAboutThisApp" {
            let destinationViewController = segue.destinationViewController as! InfoViewController
            destinationViewController.infoContent = "aboutthisapp"
        } else if segue.identifier == "presentMethodology" {
            let destinationViewController = segue.destinationViewController as! InfoViewController
            destinationViewController.infoContent = "methodology"
        } else if segue.identifier == "presentReportIntroduction" {
            let destinationViewController = segue.destinationViewController as! FactSheetViewController
            destinationViewController.factSheet = "2014 Findings on the Worst Forms of Child Labor_app"
        } else if segue.identifier == "presentReportsFactSheet" {
            let destinationViewController = segue.destinationViewController as! FactSheetViewController
            destinationViewController.factSheet = "Fact Sheets-Reports"
        } else if segue.identifier == "presentOCFTFactSheet" {
            let destinationViewController = segue.destinationViewController as! FactSheetViewController
            destinationViewController.factSheet = "Fact Sheets-OCFT"
        } else if segue.identifier == "presentProgramsFactSheet" {
            let destinationViewController = segue.destinationViewController as! FactSheetViewController
            destinationViewController.factSheet = "Fact Sheets-Programming"
        } else if segue.identifier == "presentToolkit" {
            let destinationViewController = segue.destinationViewController as! FactSheetViewController
            destinationViewController.factSheet = "ILAB Toolkit Handout"
        }
    }

}
