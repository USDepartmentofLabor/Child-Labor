//
//  LegalStandardsWrapperViewController.swift
//  Child Labor
//
//  Created by Sanganal, Akshay on 8/8/17.
//  Copyright © 2017 U.S. Department of Labor. All rights reserved.
//

import UIKit

class LegalStandardsWrapperViewController: UIViewController {
    
    
    var countryName = "Brazil"
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.legalStandardsWrapper, metaData: self.countryName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   func setCountryName(cn : String)
    {
         self.countryName = cn;
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
   if segue.identifier == "embedLegalStandards"
    {
       Analytics.trackAction(.legalStandardsWrapper, category: .embedLegalStandardsWrapper, metaData: self.countryName)
        let svc = segue.destination as! LegalStandardsTableViewController
        svc.countryName = self.countryName;
        

    }
    }
    
    
 
 
}
