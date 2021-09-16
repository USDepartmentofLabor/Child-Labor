//
//  SomaliaTableViewController.swift
//  Child Labor
//
//  Created by Sanganal, Akshay on 8/28/17.
//  Copyright © 2017 U.S. Department of Labor. All rights reserved.
//

import UIKit

class SomaliaTableViewController: UITableViewController {
    
    var countryName = "Brazil"


    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Somalia Statistics Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

}
