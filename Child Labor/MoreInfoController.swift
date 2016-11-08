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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure the ugly table cell selection is cleared when returning to this view
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: tableIndex, animated: false)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 4
        case 3:
            return 4
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            switch indexPath.row {
            case 0:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/2015TDAMagazine.pdf")!)
                break
            case 1:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/TVPRA_Report2016.pdf")!)
                break
            case 2:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/EO_Report_2014.pdf")!)
            default:
                break
            }
        }
        else if (indexPath.section == 3) {
            switch indexPath.row {
            case 0:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/TDA2015_FAQs.pdf")!)
                break
            case 1:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/TVPRA_FAQs2016.pdf")!)
                break
            case 2:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/EOFAQS_2016.pdf")!)
                break
            default:
                break
                
            }
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
    @IBAction func dismissMoreInfo(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Load content for the selected web view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentAboutThisApp" {
            let destinationViewController = segue.destination as! InfoViewController
            destinationViewController.infoContent = "aboutthisapp"
        } else if segue.identifier == "presentMethodology" {
            let destinationViewController = segue.destination as! InfoViewController
            destinationViewController.infoContent = "methodology"
        } else if segue.identifier == "presentReportIntroduction" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "2014 Findings on the Worst Forms of Child Labor_app"
        } else if segue.identifier == "presentReportsFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "Fact Sheet-Reports-lo"
        } else if segue.identifier == "presentOCFTFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "Fact Sheet-OFCT-2016-lo"
        } else if segue.identifier == "presentProgramsFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "Fact Sheet-Programming-2016-lo"
        } else if segue.identifier == "presentRegionsFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "Fact Sheet-Regional-2016-lo"
        } else if segue.identifier == "presentTDAFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "FAQs-TDA"
        } else if segue.identifier == "presentTVPRAFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "FAQs-TVPRA"
        } else if segue.identifier == "presentEOFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "FAQs-EO"
        } else if segue.identifier == "presentComboFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "FAQs- Combo"
        } else if segue.identifier == "presentToolkit" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "ToolkitForResponsibleBusinesses-lo"
        }
        
    }

}
