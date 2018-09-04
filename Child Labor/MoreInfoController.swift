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
        return 4
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return 1
        
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1) {
            switch indexPath.row {
             
            case 1:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/TDAMagazine.pdf")!)
                break
            case 2:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/TVPRA_Report2016.pdf")!)
                break
            case 3:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/EO_Report_2014.pdf")!)
            default:
                break
            }
        }
        
        if (indexPath.section == 2) {
            switch indexPath.row {
                case 0:
                UIApplication.shared.openURL(URL(string: "https://www.dol.gov/sites/default/files/documents/ilab/reports/child-labor/findings/OCFTBooklet.pdf")!)
            default:
                break
            }
        }
        
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: tableIndex, animated: false)
        }
    }
    

    
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
        } else if segue.identifier == "presentSecretaryForward" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "TDA-foreword-2017"
        } else if segue.identifier == "presentTDAFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "TDA"
        } else if segue.identifier == "presentTVPRAFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "TVPRA"
        } else if segue.identifier == "presentEOFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "EO"
        } else if segue.identifier == "presentComboFactSheet" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "FAQs- Combo"
        } else if segue.identifier == "presentToolkit" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "ToolkitForResponsibleBusinesses-lo"
        }
        
    }
    
}
