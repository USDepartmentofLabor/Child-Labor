//
//  AutoTableViewController.swift
//  Child Labor
//
//  Created by Trumaine Johnson on 6/20/16.
//  Copyright © 2016 U.S. Department of Labor. All rights reserved.
//

import UIKit

class SimilarAppTableViewController: UITableViewController {
    

   
 
    @IBOutlet weak var image: UIImageView!
    
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
        tracker?.set(kGAIScreenName, value: "Similar App Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        }
    
    
    
    
       
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    @IBAction func openApp1(_ sender: AnyObject) {
        
        UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id" + "469229784")!)
    }
    
    @IBAction func openApp2(_ sender: AnyObject) {
        
       UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id" + "469229784")!)
    }
    
    
}
