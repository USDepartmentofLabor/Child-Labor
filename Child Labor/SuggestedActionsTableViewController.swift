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
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Suggested Actions Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let dataXML = SWXMLHash.parse(contents as! String)
        
        // For each country
        for country in dataXML["Countries"]["Country"].all {
            if country["Name"].element?.text == countryName {
                
                // Duping these to accomodate inconsistent element name in the XML
                for action in country["Suggested_Actions"]["Legal_Framework"]["Action"].all {
                    laws.add((action["Name"].element?.text)!)
                }
                
                
                for action in country["Suggested_Actions"]["Laws"]["Action"].all {
                    laws.add((action["Name"].element?.text)!)
                }
                
                
                if (laws.count != 0)
                {
                sectionItems.add("Legal Frameworks")
                }
                
                
                for action in country["Suggested_Actions"]["Enforcement"]["Action"].all {
                    enforcement.add((action["Name"].element?.text)!)
                }
                
                if (enforcement.count != 0)
                {
                    sectionItems.add("Enforcement")
                }
                
                for action in country["Suggested_Actions"]["Coordination"]["Action"].all {
                    coordination.add((action["Name"].element?.text)!)
                }
                
                if (coordination.count != 0)
                {
                    sectionItems.add("Coordination")
                }
                
                
                // Duping these to accomodate inconsistent element name in the XML
                for action in country["Suggested_Actions"]["Government_Policies"]["Action"].all {
                    governmentPolicies.add((action["Name"].element?.text)!)
                }
                for action in country["Suggested_Actions"]["Policies"]["Action"].all {
                    governmentPolicies.add((action["Name"].element?.text)!)
                }
                
                if (governmentPolicies.count != 0)
                {
                    sectionItems.add("Government Policies")
                }
                
                for action in country["Suggested_Actions"]["Social_Programs"]["Action"].all {
                    socialPrograms.add((action["Name"].element?.text)!)
                }
                
                if (socialPrograms.count != 0)
                {
                    sectionItems.add("Social Programs")
                }
                
                break
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




