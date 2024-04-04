//
//  SuggestedActionsTableViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/7/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class SuggestedActionsTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    
    var sectionItems = NSMutableArray()
    
    var laws = NSMutableArray()
    var enforcement = NSMutableArray()
    var coordination = NSMutableArray()
    var governmentPolicies = NSMutableArray()
    var socialPrograms = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        for countryObj in Model.shared().countries {
            if (countryObj.country == self.countryName) {
                
                // Duping these to accomodate inconsistent element name in the XML
                let legalActions = countryObj.suggestedActions.filter { $0.area.contains("Legal") }
                for action in legalActions {
                    laws.add(action.suggestedAction)
                }
// TODO: Where is “Laws” defined in suggestedActions?
//                for action in country["Suggested_Actions"]["Laws"]["Action"].all {
//                    laws.add((action["Name"].element?.text)!)
//                }
                if (laws.count != 0)
                {
                sectionItems.add("Legal Frameworks")
                }
                
                
                let enforcementActions = countryObj.suggestedActions.filter { $0.area.contains("Enforcement") }
                for action in enforcementActions {
                    enforcement.add(action.suggestedAction)
                }
                if (enforcement.count != 0)
                {
                    sectionItems.add("Enforcement")
                }
                
                let coordinationActions = countryObj.suggestedActions.filter { $0.area.contains("Coordination") }
                for action in coordinationActions {
                    coordination.add(action.suggestedAction)
                }
                if (coordination.count != 0)
                {
                    sectionItems.add("Coordination")
                }
                
                
                let govPolicyActions = countryObj.suggestedActions.filter { $0.area.contains("Government Policies") }
                for action in govPolicyActions {
                    governmentPolicies.add(action.suggestedAction)
                }

                if (governmentPolicies.count != 0)
                {
                    sectionItems.add("Government Policies")
                }
                
                let socialActions = countryObj.suggestedActions.filter { $0.area.contains("Social Programs") }
                for action in socialActions {
                    socialPrograms.add(action.suggestedAction)
                }
                if (socialPrograms.count != 0)
                {
                    sectionItems.add("Social Programs")
                }
                
                break
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.suggestedActions, metaData: self.countryName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }
    
    
    
    
  
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if sectionItems.contains("Legal Frameworks") {
                return "Legal Framework"
            }
            else{
            return nil
            }
            
            
        case 1:
            if sectionItems.contains("Enforcement") {
                return "Enforcement"
            }
            else{
                return nil
            }
            
            
        case 2:
            
            if sectionItems.contains("Coordination") {
                return "Coordination"
            }
            else{
                return nil
            }
           
        case 3:
            if sectionItems.contains("Government Policies") {
                return "Government Policies"
            }
            else{
                return nil
            }
        default:
            if sectionItems.contains("Social Programs") {
                return "Social Programs"
            }
            else{
                return nil
            }
        
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return laws.count
        case 1:
            return enforcement.count
        case 2:
            return coordination.count
        case 3:
            return governmentPolicies.count
        default:
            return socialPrograms.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Action", for: indexPath)

        let title : UILabel? = cell.viewWithTag(101) as? UILabel
        
        switch indexPath.section {
        case 0:
           title?.text = laws[indexPath.row] as? String
        case 1:
            title?.text = enforcement[indexPath.row] as? String
        case 2:
           title?.text = coordination[indexPath.row] as? String
            
        case 3:
            title?.text = governmentPolicies[indexPath.row] as? String
        default:
            title?.text = socialPrograms[indexPath.row] as? String
        }

        if #available(iOS 13.0, *) {
            title?.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    
    {
        switch section {
        case 0:
            if sectionItems.contains("Legal Frameworks") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
            
            
        case 1:
            if sectionItems.contains("Enforcement") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
            
        case 2:
            
            if sectionItems.contains("Coordination") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
        
        case 3:
            if sectionItems.contains("Government Policies") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
        
        
        default:
            if sectionItems.contains("Social Programs") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    
    {
        switch section {
        case 0:
            if sectionItems.contains("Legal Frameworks") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
            
            
        case 1:
            if sectionItems.contains("Enforcement") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
            
        case 2:
            
            if sectionItems.contains("Coordination") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
            
        case 3:
            if sectionItems.contains("Government Policies") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
            
            
        default:
            if sectionItems.contains("Social Programs") {
                return UITableViewAutomaticDimension
            }
            else{
                return CGFloat(0.000001)
            }
        }
    }
    
    
    
    }




