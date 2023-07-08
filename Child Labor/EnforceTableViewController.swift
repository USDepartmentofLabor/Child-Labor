//
//  EnforceTableViewController.swift
//  Child Labor
//
//  Created by Trumaine Johnson on 5/20/16.
//  Copyright © 2016 U.S. Department of Labor. All rights reserved.
//

import UIKit

class EnforceTableViewController: UITableViewController {
    
    var state = 0
    var tempState = 0
    var countryName = "Brazil"
    var hasLaborFooter = false
    var hasCriminalFooter = false
    
    @IBOutlet weak var laborFundingLabel: UILabel!
    @IBOutlet weak var laborInspectorsLabel: UILabel!
    @IBOutlet weak var laborDedicatedInspectorsLabel: UILabel!
    @IBOutlet weak var laborAccessPenaltiesLabel: UILabel!
    @IBOutlet weak var laborInspectionsLabel: UILabel!
    @IBOutlet weak var laborWorksiteInspectionsLabel: UILabel!
    @IBOutlet weak var laborDeskReviewInspectionsLabel: UILabel!
    @IBOutlet weak var laborViolationsLabel: UILabel!
    @IBOutlet weak var laborPenaltiesImposedLabel: UILabel!
    @IBOutlet weak var laborPenaltiesCollectedLabel: UILabel!
    @IBOutlet weak var laborRoutineConductedLabel: UILabel!
    @IBOutlet weak var laborRoutineTargetedLabel: UILabel!
    @IBOutlet weak var laborUnannouncedPremittedLabel: UILabel!
    @IBOutlet weak var laborUnannouncedConductedLabel: UILabel!
    @IBOutlet weak var laborEmployeeTrainingLabel: UILabel!
    @IBOutlet weak var laborLawTrainingLabel: UILabel!
    @IBOutlet weak var laborRefresherCoursesLabel: UILabel!
    @IBOutlet weak var laborComplaintMechanismLabel: UILabel!
    @IBOutlet weak var laborReferralMechanismLabel: UILabel!
    @IBOutlet weak var criminalInvestigationsLabel: UILabel!
    @IBOutlet weak var criminalViolationsLabel: UILabel!
    @IBOutlet weak var criminalProsecutionsLabel: UILabel!
    @IBOutlet weak var criminalConvictionsLabel: UILabel!
    @IBOutlet weak var criminalReferralMechanismLabel: UILabel!
    @IBOutlet weak var imposedPenaltiesForViolationsRelatedToTheWFCLLabel: UILabel!
    @IBOutlet weak var criminalEmployeeTrainingLabel: UILabel!
    @IBOutlet weak var criminalNewLawsTrainingLabel: UILabel!
    @IBOutlet weak var criminalRefresherCoursesLabel: UILabel!
    
    @IBOutlet weak var laborInspectorsMeetILORec: UILabel!
    @IBOutlet weak var laborDedicatedInspectorsCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 50.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Enforcement Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
                let enforcements = country["Enforcements"]
                
                tempState = 0
                setEnforcement(self.laborFundingLabel, text: enforcements["Labor_Funding"].element?.text)
                setEnforcement(self.laborInspectorsLabel, text: enforcements["Labor_Inspectors"].element?.text)
                
                setEnforcement(self.laborAccessPenaltiesLabel, text: enforcements["Authorized_Access_Penalties"].element?.text)
                //setEnforcement(self.laborInspectionsLabel, text: enforcements["Labor_Inspections"].element?.text)
                setEnforcement(self.laborWorksiteInspectionsLabel, text: enforcements["Labor_Inspections"].element?.text)
                
                //setEnforcement(self.laborViolationsLabel, text: enforcements["Labor_Violations"].element?.text)
                setEnforcement(self.laborPenaltiesImposedLabel, text: enforcements["Labor_Penalties_Imposed"].element?.text)
                setEnforcement(self.laborPenaltiesCollectedLabel, text: enforcements["Labor_Penalties_Collected"].element?.text)
                setEnforcement(self.laborRoutineConductedLabel, text: enforcements["Labor_Routine_Inspections_Conducted"].element?.text)
                setEnforcement(self.laborRoutineTargetedLabel, text: enforcements["Labor_Routine_Inspections_Targeted"].element?.text)
                setEnforcement(self.laborUnannouncedPremittedLabel, text: enforcements["Labor_Unannounced_Inspections_Premitted"].element?.text)
                setEnforcement(self.laborUnannouncedConductedLabel, text: enforcements["Labor_Unannounced_Inspections_Conducted"].element?.text)
                setEnforcement(self.laborEmployeeTrainingLabel, text: enforcements["Labor_New_Employee_Training"].element?.text)
                setEnforcement(self.laborLawTrainingLabel, text: enforcements["Labor_New_Law_Training"].element?.text)
//                setEnforcement(self.laborRefresherCoursesLabel, text: enforcements["Labor_Refresher_Courses"].element?.text)
                setEnforcement(self.laborComplaintMechanismLabel, text: enforcements["Labor_Complaint_Mechanism"].element?.text)
                setEnforcement(self.laborReferralMechanismLabel, text: enforcements["Labor_Referral_Mechanism"].element?.text)
                setEnforcement(self.laborInspectorsMeetILORec, text: enforcements["Labor_Inspectors_Intl_Standards"].element?.text)
                
                tempState = 1
                setEnforcement(self.criminalInvestigationsLabel, text: enforcements["Criminal_Investigations"].element?.text)
                //setEnforcement(self.criminalViolationsLabel, text: enforcements["Criminal_Violations"].element?.text)
                setEnforcement(self.criminalProsecutionsLabel, text: enforcements["Criminal_Prosecutions"].element?.text)
                setEnforcement(self.criminalConvictionsLabel, text: enforcements["Criminal_Convictions"].element?.text)
                setEnforcement(self.imposedPenaltiesForViolationsRelatedToTheWFCLLabel, text: enforcements["Criminal_Penalties_for_WFCL"].element?.text)
                setEnforcement(self.criminalReferralMechanismLabel, text: enforcements["Criminal_Referral_Mechanism"].element?.text)
                
                setEnforcement(self.criminalEmployeeTrainingLabel, text: enforcements["Criminal_New_Employee_Training"].element?.text)
//                setEnforcement(self.criminalNewLawsTrainingLabel, text: enforcements["Criminal_New_Law_Training"].element?.text)
//                setEnforcement(self.criminalRefresherCoursesLabel, text: enforcements["Criminal_Refresher_Courses"].element?.text)
            }
        }
        
        
        
    }
    
    func setEnforcement(_ label: UILabel, text: String?) {
        if (text != nil) {
            label.text = text
            if let number = Float(text!) {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                label.text = numberFormatter.string(from: NSNumber(value: number))!
                if self.laborFundingLabel == label {
                    label.text = "$" + numberFormatter.string(from: NSNumber(value: number))!
                }
            }
            
            if (text!.hasPrefix("N/A") == false && text!.hasPrefix("Unknown") == false && text!.hasPrefix("Unavailable") == false) {
                label.textColor = UIColor.black
            }
            
            label.accessibilityLabel = (text!.hasPrefix("N/A")) ? "Not Applicable" : label.text!.replacingOccurrences(of: "*", with: "")
            
            if (text!.contains("*")) {
                if tempState == 0 {
                    self.hasLaborFooter = true
                }
                else {
                    self.hasCriminalFooter = true
                }
                label.accessibilityLabel = label.accessibilityLabel! + ", the Government does not make this information publicly available"
            }
            if #available(iOS 13.0, *) {
                label.textColor = .label
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 9
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if state == 0 {
            switch section {
            case 0:
                return 4
            case 1:
                return 1
            case 2:
                return 1
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
            case 7:
                return 1
            case 8:
                return 5
            default:
                return 0
            }
        }
    }
    
    @IBAction func changeSection(_ sender: AnyObject) {
        state = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (state == 0 && section <= 6) {
            return UITableViewAutomaticDimension;
        }
        
        if (state == 1 && section >= 7) {
            return UITableViewAutomaticDimension;
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (state == 0 && section <= 6) {
           return UITableViewAutomaticDimension;
            
        }
        
        
        
        if (state == 1 && section > 6) {
            return UITableViewAutomaticDimension;
        }
        
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (state == 0 && section <= 6) {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
        
        if (state == 1 && section > 6) {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if (state == 0 && section <= 6) {
            if (section == 6 && self.hasLaborFooter) {
                // return "*The government does not publish this information";
                return " ";
            }
            return super.tableView(tableView, titleForFooterInSection: section)
        }
        
        if (state == 1 && section > 6) {
            if (section == 8 && self.hasCriminalFooter) {
                // return "*The government does not publish this information";
                return " ";
            }
            return super.tableView(tableView, titleForFooterInSection: section)
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell: UITableViewCell = super.tableView(tableView, cellForRowAt:indexPath)
        
        return cell.isHidden ? 0 : UITableViewAutomaticDimension
    }
    
  
    
}
