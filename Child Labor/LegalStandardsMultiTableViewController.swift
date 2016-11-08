//
//  LegalStandardsMultiTableViewController.swift
//  Child Labor
//
//  Created by Trumaine Johnson on 8/9/16.
//  Copyright © 2016 U.S. Department of Labor. All rights reserved.
//

import UIKit

class LegalStandardsMultiTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    var hasStandardsFooter = false
    var hasAgeFooter = false
    var hasCombatFooter = false
    var combatRow = false
    
    var sectionTerritories = Array<Array<XMLIndexer>>()
    var sectionTitles = Array<Array<String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Legal Standards"
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Laws Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as NSDictionary? as? [AnyHashable: Any])
        
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2015", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text == self.countryName {
                let legalStandards = country["Legal_Standards"]
                
                sectionTerritories.append([legalStandards["Minimum_Work"], legalStandards["Minimum_Hazardous_Work"], legalStandards["Minimum_Compulsory_Military"], legalStandards["Minumum_Voluntary_Military"]])
                sectionTerritories.append([legalStandards["Types_Hazardous_Work"]])
                sectionTerritories.append([legalStandards["Prohibition_Forced_Labor"], legalStandards["Prohibition_Child_Trafficking"], legalStandards["Prohibition_CSEC"], legalStandards["Prohibition_Illicit_Activities"]])
                sectionTerritories.append([legalStandards["Compulsory_Education"], legalStandards["Free_Public_Education"]])
            }
        }
        
        sectionTitles.append(["Work", "Hazardous Work", "Compulsory Military Recruitment", "Voluntary Military Service"])
        sectionTitles.append(["Types of Hazardous Work"])
        sectionTitles.append(["Forced Labor", "Child Trafficking", "CSEC", "Using Children in Illicit Activities"])
        sectionTitles.append(["Compulsory Education Age", "Free Public Education"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            case 0:
                return "Minimum Age For:"
            case 1:
                return "Identified:"
            case 2:
                return "Prohibition Of:"
            case 3:
                return "Education:"
            default:
                return "No Data"
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 3 && (self.hasStandardsFooter || self.hasAgeFooter || self.hasCombatFooter)) {
            var footer = ""
            if (self.hasStandardsFooter) {
                footer += "* Note: There are gaps in the legal framework, as articulated in the chapter report";
            }
            if (self.hasAgeFooter) {
                footer += "\n‡ Age calculated based on available information"
            }
            if (self.hasCombatFooter) {
                footer += "\nΦ Ages denoted are combat/non-combat"
            }
            return footer
        }
        
        return super.tableView(tableView, titleForFooterInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 80
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
            case 0:
                return 4
            case 1:
                return 1
            case 2:
                return 4
            case 3:
                return 2
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.combatRow = ["Compulsory Military Recruitment", "Voluntary Military Service"].contains(sectionTitles[indexPath.section][indexPath.row])
        
        let territories = sectionTerritories[indexPath.section][indexPath.row]
        
        let territoryCount = territories["Territory"].all.count
        
        let cellName = (territoryCount != 0) ? "Cell-" + String(territoryCount) : "Cell-1"
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellName)!
        
        let standardLabel = cell.contentView.viewWithTag(1) as! UILabel
        standardLabel.text = sectionTitles[indexPath.section][indexPath.row]
        standardLabel.accessibilityLabel = sectionTitles[indexPath.section][indexPath.row].replacingOccurrences(of: "No.", with: "Number").replacingOccurrences(of: "btwn", with: "between")
        
        if territoryCount == 0 {
            let nameLabel = cell.contentView.viewWithTag(10) as! UILabel
            nameLabel.text = "All Territories"
            
            let valueLabel = cell.contentView.viewWithTag(11) as! UILabel
            valueLabel.text = "Unavailable"
            valueLabel.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
            
            return cell
        }
        
        var index = 1
        for territory in territories["Territory"] {
            let tag = index * 10
            
            let nameLabel = cell.contentView.viewWithTag(tag) as! UILabel
            nameLabel.text = territory["Territory_Display_Name"].element?.text
            nameLabel.accessibilityLabel = territory["Territory_Name"].element?.text
            
            let valueLabel = cell.contentView.viewWithTag(tag + 1) as! UILabel
            setLegalStandard(valueLabel, standardXML: territory)
            
            index += 1
        }
        
        return cell
    }
    
    func setLegalStandard(_ label: UILabel, standardXML: XMLIndexer!) {
        let standard = standardXML["Standard"].element?.text
        let age = standardXML["Age"].element?.text
        let calculatedAge = standardXML["Calculated_Age"].element?.text == "Yes"
        let conformsStandard = standardXML["Conforms_To_Intl_Standard"].element?.text != "No"
        
        var labelText = ""
        var accessibleText = ""
        if (standard != nil) {
            labelText = standard!
            accessibleText = standard!
            if (labelText.hasPrefix("Yes") == true && !conformsStandard) {
                self.hasStandardsFooter = true
                labelText += "*"
                accessibleText += ", note there are gaps in the legal framework as articulated in the chapter report "
            }
            
            if (age != nil) {
                labelText += " (" + age!
                accessibleText += ", " + age!
                if (calculatedAge) {
                    self.hasAgeFooter = true
                    labelText += "‡"
                    accessibleText += ", age calculated based on available information "
                }
                labelText += ")"
                if (self.combatRow && age!.contains("/")) {
                    self.hasCombatFooter = true
                    labelText += "Φ"
                    accessibleText += ", ages denoted are combat/non-combat "
                }
            }
        }
        
        if (labelText != "") {
            label.text = labelText
            if (labelText.contains("Φ")) {
                let idx = labelText.characters.index(of: "Φ")
                let pos = labelText.characters.distance(from: labelText.startIndex, to: idx!);
                
                let attrText : NSMutableAttributedString = NSMutableAttributedString(string: labelText)
                attrText.addAttribute(NSFontAttributeName as String, value:UIFont.systemFont(ofSize: UIFont.systemFontSize * 0.75), range:NSMakeRange(pos, 1))
                attrText.addAttribute(kCTSuperscriptAttributeName as String, value:1, range:NSMakeRange(pos, 1))
                label.attributedText = attrText;
                
            }
            
            if (labelText.hasPrefix("Yes") == true && conformsStandard) {
                label.textColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
            }
            else if (labelText.hasPrefix("Yes") == true && !conformsStandard) {
                label.textColor = UIColor.red
            }
            else if (labelText.hasPrefix("No") == true || labelText.hasPrefix("Unknown") == true) {
                label.textColor = UIColor.red
            }
            else if (labelText.hasPrefix("N/A") == false && labelText.hasPrefix("Unavailable") == false) {
                label.textColor = UIColor.black
            }
            else {
                label.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
            }
            
            label.accessibilityLabel = (accessibleText.hasPrefix("N/A")) ? "Not Available" : accessibleText.replacingOccurrences(of: "*", with: "")
        }
    }

}
