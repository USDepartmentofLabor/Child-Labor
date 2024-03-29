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
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents! as String)
        
        for country in countriesXML["Countries"]["Country"].all {
            if country["Name"].element?.text == self.countryName {
                let legalStandards = country["Legal_Standards"]
                
                sectionTerritories.append([legalStandards["Minimum_Work"], legalStandards["Minimum_Hazardous_Work"],legalStandards["Minumum_Voluntary_Military"]])
                sectionTerritories.append([legalStandards["Types_Hazardous_Work"]])
                sectionTerritories.append([legalStandards["Prohibition_Forced_Labor"], legalStandards["Prohibition_Child_Trafficking"], legalStandards["Prohibition_CSEC"], legalStandards["Prohibition_Illicit_Activities"],
                                           legalStandards["Minimum_Compulsory_Military"],
                                           
                                           legalStandards["Minumum_Non_State_Military"]])
                sectionTerritories.append([legalStandards["Compulsory_Education"], legalStandards["Free_Public_Education"]])
            }
        }
        
        sectionTitles.append(["Work", "Hazardous Work", "State Voluntary Military Recruitment"])
        sectionTitles.append(["Types of Hazardous Work"])
        sectionTitles.append(["Forced Labor", "Child Trafficking", "Commercial Sexual Exploitation of Children", "Using Children in Illicit Activities", "State Compulsory Military Recruitment", "Non-State Military Recruitment"])
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
        if (section == 3) {
            var footer = "* Please note that a “Yes” indicates that the legal framework meets the international standard. \n\nPlease see the chapter text for more information regarding gaps in legal framework and suggested actions."
                       
            
            
            if (self.hasAgeFooter) {
                footer += "\n\n‡ Age calculated based on available information"
                
            }
            
            else{
                footer += "\n\n"
            }
            
            return footer
        }
        
        return super.tableView(tableView, titleForFooterInSection: section)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if (section == 3) {
            
            return 200
            
        }
        return UITableViewAutomaticDimension
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 6
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.combatRow = ["State Compulsory Military Recruitment", "State Voluntary Military Recruitment"].contains(sectionTitles[indexPath.section][indexPath.row])
        
        let territories = sectionTerritories[indexPath.section][indexPath.row]
        
        let territoryCount = territories["Territory"].all.count
        
        let cellName = (territoryCount != 0) ? "Cell-" + String(territoryCount) : "Cell-1"
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellName)!
        
        let standardLabel = cell.contentView.viewWithTag(1) as! UILabel
        standardLabel.text = sectionTitles[indexPath.section][indexPath.row]
        standardLabel.accessibilityLabel = sectionTitles[indexPath.section][indexPath.row].replacingOccurrences(of: "No.", with: "Number").replacingOccurrences(of: "btwn", with: "between")
        if #available(iOS 13.0, *) {
            standardLabel.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        if territoryCount == 0 {
            let nameLabel = cell.contentView.viewWithTag(10) as! UILabel
            nameLabel.text = "All Territories"
            if #available(iOS 13.0, *) {
                nameLabel.textColor = .label
            } else {
                // Fallback on earlier versions
            }
            
            let valueLabel = cell.contentView.viewWithTag(11) as! UILabel
            valueLabel.text = "Unavailable"
            valueLabel.textColor = UIColor(red: 0.43, green: 0.43, blue: 0.43, alpha: 1.0)
            if #available(iOS 13.0, *) {
                valueLabel.textColor = .label
            } else {
                // Fallback on earlier versions
            }
            return cell
        }
        
        var index = 1
        for territory in territories["Territory"].all {
            let tag = index * 10
            
            let nameLabel = cell.contentView.viewWithTag(tag) as! UILabel
            nameLabel.text = territory["Territory_Display_Name"].element?.text
            nameLabel.accessibilityLabel = territory["Territory_Name"].element?.text
            if #available(iOS 13.0, *) {
                nameLabel.textColor = .label
            } else {
                // Fallback on earlier versions
            }
            let valueLabel = cell.contentView.viewWithTag(tag + 1) as! UILabel
            if #available(iOS 13.0, *) {
                valueLabel.textColor = .label
            } else {
                // Fallback on earlier versions
            }
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
                accessibleText += ",note See country chapter for detailed information about this country’s laws and regulations "
            }
            
            
            if (age == "N/A") {
                labelText += ""
                accessibleText += ""
                if (calculatedAge) {
                    self.hasAgeFooter = true
                    labelText += "‡"
                    accessibleText += ", age calculated based on available information "
                }
                
            }
                
               
            else if (age != "") {
                labelText += " (" + age!
                accessibleText += ", " + age!
                if (calculatedAge) {
                    self.hasAgeFooter = true
                    labelText += "‡"
                    accessibleText += ", age calculated based on available information "
                }
                labelText += ")"
                
            }
        }
        
        if (labelText != "") {
            label.text = labelText
            if (labelText.contains("Φ")) {
                let idx = labelText.characters.index(of: "Φ")
                let pos = labelText.characters.distance(from: labelText.startIndex, to: idx!);
                
                let attrText : NSMutableAttributedString = NSMutableAttributedString(string: labelText)
               // attrText.addAttribute(NSAttributedStringKey.font as String, value:UIFont.systemFont(ofSize: UIFont.systemFontSize * 0.75), range:NSMakeRange(pos, 1))
                attrText.addAttribute(NSAttributedStringKey(rawValue: kCTSuperscriptAttributeName as String as String), value:1, range:NSMakeRange(pos, 1))
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
            
            label.accessibilityLabel = (accessibleText.hasPrefix("N/A")) ? "Not Apllicable" : accessibleText.replacingOccurrences(of: "*", with: "")
        }
    }
    
    
    
    
}
