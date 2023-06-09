//
//  EnforcementTableViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/7/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class EnforcementTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    
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
        /*
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Enforcement Screen")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_for_app", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        let dataXML = SWXMLHash.parse(contents as! String)
        */
        enforcement.add("FBiH Ministry of Labor and Social Policy’s Federal Inspection Agency and Cantonal-Level Labor Inspectorates")
        enforcement.add("RS Ministry of Labor and Veterans’ Labor Inspectorate")
        enforcement.add("BD Administrative Support Department")
        enforcement.add("Entity and Cantonal-Level Police")
        enforcement.add("Ministry of Security (MoS)")
        enforcement.add("State Investigative and Protection Agency (SIPA) and State Border Police (SBP)")
        enforcement.add("State, Entity, and FBiH Cantonal-Level Prosecutors’ Offices")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        default:
            return "Enforcement"
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        default:
            if enforcement.count == 0 {
                return "No Actions"
            }
        }
        return ""
    }
    
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        default:
            return enforcement.count
        }
    }
    
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Action", for: indexPath)

        let title : UILabel? = cell.viewWithTag(110) as? UILabel
        
        switch indexPath.section {
        default:
            title?.text = enforcement[indexPath.row] as? String
        }

        if #available(iOS 13.0, *) {
            title?.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        return cell
    }



}
