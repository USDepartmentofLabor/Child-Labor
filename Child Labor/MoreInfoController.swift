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
        return 3
           // return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
//        case 2:
//            return 1
        
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "About this App"
            case 1:
                cell?.textLabel?.text = "Methodology"
                
            default:
                cell?.textLabel?.text = ""
                
            
            }
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell?.textLabel?.text = "Comply Chain App"
            }
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell?.textLabel?.text = "New: Better Trade Tool"
            }
        }
        /*Old code below not using now after adding the new better trade tool link
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell?.textLabel?.text = "Foreword"
            }
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell?.textLabel?.text = "Sweat & Toil Magazine"
            }
        }
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                cell?.textLabel?.text = "Comply Chain App"
            }
        }*/
        let chevron = UIImage(named: "arrow.png")
        cell?.accessoryType = .disclosureIndicator
        cell?.accessoryView = UIImageView(image: chevron)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0){
        if (indexPath.row == 0) {
         performSegue(withIdentifier: "presentAboutThisApp", sender: self)
         }
        if (indexPath.row == 1) {
        performSegue(withIdentifier: "presentMethodology", sender: self)
        }
        }
        if (indexPath.section == 1){
            if (indexPath.row == 0) {
                performSegue(withIdentifier: "presentSimilarApps", sender: self)
            }
        }
        if (indexPath.section == 2){
            if (indexPath.row == 0) {
                guard let url = URL(string: "https://www.dol.gov/BetterTradeTool") else { return }
                UIApplication.shared.openURL(url)
                
            }
        }
        /*Old code below not using now after adding the new better trade tool link
        if (indexPath.section == 1){
            if (indexPath.row == 0) {
                performSegue(withIdentifier: "presentSecretaryForward", sender: self)
            }
        }
        if (indexPath.section == 2){
            if (indexPath.row == 0) {
                performSegue(withIdentifier: "presentMagazine", sender: self)
            }
        }
        if (indexPath.section == 3){
            if (indexPath.row == 0) {
                performSegue(withIdentifier: "presentSimilarApps", sender: self)
            }
        }*/
        
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
            destinationViewController.factSheet = "TDA-foreword-2019"
        } else if segue.identifier == "presentMagazine" {
            let destinationViewController = segue.destination as! FactSheetViewController
            destinationViewController.factSheet = "2019_Sweat_And_Toil_Magazine"
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
