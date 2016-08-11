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
                setLegalStandard(self.compulsoryEducationLabel, standardXML: legalStandards["Compulsory_Education"])
                setLegalStandard(self.freePublicEducationLabel, standardXML: legalStandards["Free_Public_Education"])
            }
        }

        
    }
    
    func setLegalStandard(label: UILabel, standardXML: XMLIndexer!) {
        let standard = standardXML["Standard"].element?.text
        let age = standardXML["Age"].element?.text
        let calculatedAge = standardXML["Calculated_Age"].element?.text == "Yes"
        let conformsStandard = standardXML["Conforms_To_Intl_Standard"].element?.text != "No"
        
        var labelText = ""
        if (standard != nil) {
            labelText = standard!
            if (labelText.hasPrefix("Yes") == true && !conformsStandard) {
                self.hasStandardsFooter = true
                labelText += "*"
            }
            
            if (age != nil) {
                labelText += " (" + age!
                if (calculatedAge) {
                    self.hasAgeFooter = true
                    labelText += "‡"
                }
                if ([self.minimumComplusoryMilitaryLabel, self.minimumVoluntaryMilitaryLabel].contains(label) && age!.containsString("/")) {
                    self.hasCombatFooter = true
                    labelText += "Φ"
                }
                labelText += ")"
            }
        }
        
        if (labelText != "") {
            label.text = labelText
            if (labelText.containsString("Φ")) {
                let idx = labelText.characters.indexOf("Φ")
                let pos = labelText.startIndex.distanceTo(idx!);
                
                let attrText : NSMutableAttributedString = NSMutableAttributedString(string: labelText)
                attrText.addAttribute(NSFontAttributeName as String, value:UIFont.systemFontOfSize(UIFont.systemFontSize() * 0.75), range:NSMakeRange(pos, 1))
                attrText.addAttribute(kCTSuperscriptAttributeName as String, value:1, range:NSMakeRange(pos, 1))
                label.attributedText = attrText;
                
            }
            
            if (labelText.hasPrefix("Yes") == true && conformsStandard) {
                label.textColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
            }
            else if (labelText.hasPrefix("Yes") == true && !conformsStandard) {
                label.textColor = UIColor.redColor()
            }
            else if (labelText.hasPrefix("No") == true || labelText.hasPrefix("Unknown") == true) {
                label.textColor = UIColor.redColor()
            }
            else if (labelText.hasPrefix("N/A") == false && labelText.hasPrefix("Unavailable") == false) {
                label.textColor = UIColor.blackColor()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (section == 3 && (self.hasStandardsFooter || self.hasAgeFooter || self.hasCombatFooter)) {
            var footer = ""
            if (self.hasStandardsFooter) {
                footer += "* Does not meet International Standards";
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

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
