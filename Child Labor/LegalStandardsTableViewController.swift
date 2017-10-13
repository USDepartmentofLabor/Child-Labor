//
//  AutoTableViewController.swift
//  Child Labor
//
//  Created by Trumaine Johnson on 6/20/16.
//  Copyright © 2016 U.S. Department of Labor. All rights reserved.
//

import UIKit

class LegalStandardsTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    var hasStandardsFooter = false
    var hasAgeFooter = false
    var hasCombatFooter = false
    
    
    @IBOutlet weak var minimumWorkLabel: UILabel!
    @IBOutlet weak var minimumHazardousWorkLabel: UILabel!
    @IBOutlet weak var minimumComplusoryMilitaryLabel: UILabel!
    @IBOutlet weak var minimumVoluntaryMilitaryLabel: UILabel!
    @IBOutlet weak var typesHazardousWorkLabel: UILabel!
    @IBOutlet weak var prohibitionHazardousOccupationsLabel: UILabel!
    @IBOutlet weak var prohibitionForcedLaborLabel: UILabel!
    @IBOutlet weak var prohibitionChildTraffickingLabel: UILabel!
    @IBOutlet weak var prohibitionCSECLabel: UILabel!
    @IBOutlet weak var prohibitionIllicitActivitiesLabel: UILabel!
    @IBOutlet weak var compulsoryEducationLabel: UILabel!
    @IBOutlet weak var freePublicEducationLabel: UILabel!
    @IBOutlet weak var nsCompulsoryMilitary: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        for country in countriesXML["Countries"]["Country"].all {
            if country["Name"].element?.text == self.countryName {
                let legalStandards = country["Legal_Standards"]
                setLegalStandard(self.minimumWorkLabel, standardXML: legalStandards["Minimum_Work"])
                setLegalStandard(self.minimumHazardousWorkLabel, standardXML: legalStandards["Minimum_Hazardous_Work"])
                setLegalStandard(self.minimumComplusoryMilitaryLabel, standardXML: legalStandards["Minimum_Compulsory_Military"])
                setLegalStandard(self.minimumVoluntaryMilitaryLabel, standardXML: legalStandards["Minumum_Voluntary_Military"])
                setLegalStandard(self.typesHazardousWorkLabel, standardXML: legalStandards["Types_Hazardous_Work"])
                setLegalStandard(self.prohibitionForcedLaborLabel, standardXML: legalStandards["Prohibition_Forced_Labor"])
                setLegalStandard(self.prohibitionChildTraffickingLabel, standardXML: legalStandards["Prohibition_Child_Trafficking"])
                setLegalStandard(self.prohibitionCSECLabel, standardXML: legalStandards["Prohibition_CSEC"])
                setLegalStandard(self.prohibitionIllicitActivitiesLabel, standardXML: legalStandards["Prohibition_Illicit_Activities"])
                setLegalStandard(self.nsCompulsoryMilitary, standardXML: legalStandards["Minumum_Non_State_Military"])
                setLegalStandard(self.compulsoryEducationLabel, standardXML: legalStandards["Compulsory_Education"])
                setLegalStandard(self.freePublicEducationLabel, standardXML: legalStandards["Free_Public_Education"])
            }
        }
    }
    
    
    func setCountryName(cn : String)
    {
        self.countryName = cn;
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
                // labelText += "*"
                // accessibleText += ", note See country chapter for detailed information about this country’s laws and regulations "
            }
            
            
            if (age == "N/A") {
                labelText += ""
                accessibleText += ""
                if (calculatedAge) {
                    self.hasAgeFooter = true
                    labelText += "‡"
                    accessibleText += ", age calculated based on available information "
                }
                
                
                // akshay made changes here
                
                
                if ([self.minimumComplusoryMilitaryLabel, self.minimumVoluntaryMilitaryLabel, self.nsCompulsoryMilitary].contains(label) && age!.contains("/") && age!.contains("n/a") == false && age?.contains("N/A") == false) {
                    self.hasCombatFooter = true
                    //   labelText += "Φ"
                    // accessibleText += ", ages denoted are combat/non-combat "
                }
            }
                
                
            else if ([self.minimumWorkLabel, self.minimumHazardousWorkLabel, self.minimumComplusoryMilitaryLabel, self.minimumVoluntaryMilitaryLabel, self.nsCompulsoryMilitary].contains(label) && age != nil) {
                labelText += " (" + age!
                accessibleText += ", " + age!
                if (calculatedAge) {
                    self.hasAgeFooter = true
                    labelText += "‡"
                    accessibleText += ", age calculated based on available information "
                }
                labelText += ")"
                
                // akshay made changes here
                
                
                if ([self.minimumComplusoryMilitaryLabel, self.minimumVoluntaryMilitaryLabel, self.nsCompulsoryMilitary].contains(label) && age!.contains("/") && age!.contains("n/a") == false && age?.contains("N/A") == false) {
                    self.hasCombatFooter = true
                    //   labelText += "Φ"
                    // accessibleText += ", ages denoted are combat/non-combat "
                }
            }
          
            
        }
        
        if (labelText != "") {
            label.text = labelText
            if (labelText.contains("Φ")) {
                let idx = labelText.characters.index(of: "Φ")
                let pos = labelText.characters.distance(from: labelText.startIndex, to: idx!);
                
                let attrText : NSMutableAttributedString = NSMutableAttributedString(string: labelText)
            //    attrText.addAttribute(NSAttributedStringKey.font as String, value:UIFont.systemFont(ofSize: UIFont.systemFontSize * 0.75), range:NSMakeRange(pos, 1))
                attrText.addAttribute(NSAttributedStringKey(rawValue: kCTSuperscriptAttributeName as String as String), value:1, range:NSMakeRange(pos, 1))
                label.attributedText = attrText;
                
            }
            
            if (labelText.hasPrefix("Yes") == true && conformsStandard) {
                label.textColor = UIColor(red: 0.0, green: 0.49, blue: 0.1, alpha: 1.0)
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
            
            label.accessibilityLabel = (accessibleText.hasPrefix("N/A")) ? "Not Available" : accessibleText.replacingOccurrences(of: "*", with: "")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 3 )
        {
            
            var footer = "* Please note that this year, a “yes” indicates that the legal framework meets the international standard.  Last year, a “yes” indicated that the country had laws relevant to the international standard, even if they did not fully meet the standard."
            
            footer += "\n\nPlease see the chapter text for more information regarding gaps in the legal framework and suggested actions.\n"
            
            
            
            if (self.hasAgeFooter) {
                footer += "\n‡ Age calculated based on available information"
            }
            
            
            return footer
        }
        
        return super.tableView(tableView, titleForFooterInSection: section)
    }
    
    
    
}

