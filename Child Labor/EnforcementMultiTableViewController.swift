//
//  EnforcementMultiTableViewController.swift
//  Child Labor
//
//  Created by Trumaine Johnson on 8/9/16.
//  Copyright © 2016 U.S. Department of Labor. All rights reserved.
//

import UIKit

class EnforcementMultiTableViewController: UITableViewController {
    
    
    var state = 0
    var countryName = "Brazil"
    var hasLaborFooter = false
    var hasCriminalFooter = false
    var showDedicatedInspectors = false
    
    var laborFundingRow = false
    
    var sectionTerritories = Array<Array<Array<XMLIndexer>>>()
    var sectionTitles = Array<Array<Array<String>>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Enforcement"
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Laws Screen")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_2015", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text == self.countryName {
                let enforcements = country["Enforcements"]
                
                for territory in enforcements["Dedicated_Labor_Inspectors"]["Territory"] {
                    let text = territory["Enforcement"].element?.text
                    if (text!.hasPrefix("N/A") == false && text!.hasPrefix("Unavailable") == false && text! != "0") {
                        showDedicatedInspectors = true
                    }
                }
                
                
                let sectionA1 = (showDedicatedInspectors) ? [enforcements["Labor_Funding"], enforcements["Labor_Inspectors"], enforcements["Dedicated_Labor_Inspectors"], enforcements["Authorized_Access_Penalties"]] : [enforcements["Labor_Funding"], enforcements["Labor_Inspectors"], enforcements["Authorized_Access_Penalties"]]
                let sectionA2 = [enforcements["Labor_New_Employee_Training"], enforcements["Labor_New_Law_Training"], enforcements["Labor_Refresher_Courses"]]
                let sectionA3 = [enforcements["Labor_Inspections"], enforcements["Labor_Worksite_Inspections"], enforcements["Labor_Desk_Review_Inspections"]]
                let sectionA4 = [enforcements["Labor_Violations"], enforcements["Labor_Penalties_Imposed"], enforcements["Labor_Penalties_Collected"]]
                let sectionA5 = [enforcements["Labor_Routine_Inspections_Conducted"], enforcements["Labor_Routine_Inspections_Targeted"]]
                let sectionA6 = [enforcements["Labor_Unannounced_Inspections_Premitted"], enforcements["Labor_Unannounced_Inspections_Conducted"]]
                let sectionA7 = [enforcements["Labor_Complaint_Mechanism"], enforcements["Labor_Referral_Mechanism"]]
                
                let sectionB1 = [enforcements["Criminal_New_Employee_Training"], enforcements["Criminal_New_Law_Training"], enforcements["Criminal_Refresher_Courses"]]
                let sectionB2 = [enforcements["Criminal_Investigations"], enforcements["Criminal_Violations"], enforcements["Criminal_Prosecutions"], enforcements["Criminal_Convictions"],enforcements["Criminal_Referral_Mechanism"]]
                
                sectionTerritories.append([sectionA1, sectionA2, sectionA3, sectionA4, sectionA5, sectionA6, sectionA7])
                sectionTerritories.append([sectionB1, sectionB2])
            }
        }
        
        
        let sectionA1 = (showDedicatedInspectors) ? ["Labor Inspectorate Funding", "No. of Labor Inspectors", "No. of Dedicated Labor Inspectors", "Inspectorate Authorized to Assess Penalties"] : ["Labor Inspectorate Funding", "No. of Labor Inspectors", "Inspectorate Authorized to Assess Penalties"]
        let sectionA2 = ["Initial Training for New Employees", "Training on New Laws Related to Child Labor", "Refresher Courses Provided"]
        let sectionA3 = ["No. Of Inspections", "No. Conducted at Worksite", "No. Conducted by Desk Reviews"]
        let sectionA4 = ["No. of Violations Found", "No. of Penalties Imposed", "No. of Collected Penalties"]
        let sectionA5 = ["Conducted", "Targeted"]
        let sectionA6 = ["Permitted", "Conducted"]
        let sectionA7 = ["Complaint Mechanism Exists", "Referral Mechanism Exists btwn Authorities and Social Services"]
        
        let sectionB1 = ["Initial Training for New Employees", "Training on New Laws Related to WFCL", "Refresher Courses Provided"]
        let sectionB2 = ["No. of Investigations", "No. of Violations Found", "No. of Prosecutions Initiated", "No. of Convictions", "Referral Mechanism Exists btwn Authorities and Social Services"]
        
        sectionTitles.append([sectionA1, sectionA2, sectionA3, sectionA4, sectionA5, sectionA6, sectionA7])
        sectionTitles.append([sectionB1, sectionB2])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        switch state {
        case 0:
            return 7
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if state == 0 {
            switch section {
            case 0:
                return nil
            case 1:
                return "Training For Labor Inspectors:"
            case 2:
                return "Labor Inspections:"
            case 3:
                return "Child Labor Violations:"
            case 4:
                return "Routine Inspections:"
            case 5:
                return "Unannounced Inspections:"
            case 6:
                return nil
            default:
                return nil
            }
        }
        else {
            switch section {
            case 0:
                return "Training For Investigators"
            case 1:
                return nil
            
            default:
                return nil
            }
        }
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (state == 0 && section == 6 && self.hasLaborFooter) {
            return "* The Government does not make this information publicly available";
        }
        
        if (state == 1 && section == 1 && self.hasCriminalFooter) {
            return "* The Government does not make this information publicly available";
        }
        
        return super.tableView(tableView, titleForFooterInSection: section)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (state == 0 && section == 6) {
            return 50
        }
        
        if (state == 1 && section == 1) {
            return 50
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if state == 0 {
            switch section {
            case 0:
                return  (showDedicatedInspectors) ? 4 : 3
            case 1:
                return 3
            case 2:
                return 3
            case 3:
                return 3
            case 4:
                return 2
            case 5:
                return 2
            case 6:
                return 2
            default:
                return 0
            }
        }
        else {
            switch section {
            case 0:
                return 3
            case 1:
                return 5
            default:
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.laborFundingRow = ["Labor Inspectorate Funding"].contains(sectionTitles[state][indexPath.section][indexPath.row])
        
        let territories = sectionTerritories[state][indexPath.section][indexPath.row]
        
        let territoryCount = territories["Territory"].all.count
        
        let cellName = (territoryCount != 0) ? "Cell-" + String(territoryCount) : "Cell-1"
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellName)!
        
        let standardLabel = cell.contentView.viewWithTag(1) as! UILabel
        standardLabel.text = sectionTitles[state][indexPath.section][indexPath.row]
        standardLabel.accessibilityLabel = sectionTitles[state][indexPath.section][indexPath.row].stringByReplacingOccurrencesOfString("No.", withString: "Number").stringByReplacingOccurrencesOfString("btwn", withString: "between")
        
        var accessibilityElements = [standardLabel]
        
        if territoryCount == 0 {
            let nameLabel = cell.contentView.viewWithTag(10) as! UILabel
            nameLabel.text = "All Territories"
            
            let valueLabel = cell.contentView.viewWithTag(11) as! UILabel
            valueLabel.text = "Unavailable"
            valueLabel.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
            
            accessibilityElements += [nameLabel, valueLabel]
            cell.contentView.accessibilityElements = accessibilityElements
            
            return cell
        }
        
        var index = 1
        for territory in territories["Territory"] {
            let tag = index * 10
            
            let nameLabel = cell.contentView.viewWithTag(tag) as! UILabel
            nameLabel.text = territory["Territory_Display_Name"].element?.text
            nameLabel.accessibilityLabel = territory["Territory_Name"].element?.text
            
            let valueLabel = cell.contentView.viewWithTag(tag + 1) as! UILabel
            setEnforcement(valueLabel, text: territory["Enforcement"].element?.text)
            
            accessibilityElements += [nameLabel, valueLabel]
            
            index += 1
        }
        
        cell.contentView.accessibilityElements = accessibilityElements
        return cell
    }
    
    func setEnforcement(label: UILabel, text: String?) {
        if (text != nil) {
            label.text = text
            if let number = Int(text!) {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
                label.text = numberFormatter.stringFromNumber(number)!
                if laborFundingRow {
                    label.text = "$" + numberFormatter.stringFromNumber(number)!
                }
            }
            
            if (text!.hasPrefix("N/A") == false && text!.hasPrefix("Unknown") == false && text!.hasPrefix("Unavailable") == false) {
                label.textColor = UIColor.blackColor()
            }
            else {
                label.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
            }
            
            label.accessibilityLabel = (text!.hasPrefix("N/A")) ? "Not Available" : label.text!.stringByReplacingOccurrencesOfString("*", withString: "")
            if (text!.containsString("*")) {
                if self.state == 0 {
                    self.hasLaborFooter = true
                }
                else {
                    self.hasCriminalFooter = true
                }
                label.accessibilityLabel = label.accessibilityLabel! + ", the Government does not make this information publicly available"
                
            }
        }
    }
    
    @IBAction func changeState(sender: AnyObject) {
        self.state = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
}
