//
//  LegalStandardsMultiWrapperViewController.swift
//  Child Labor
//
//  Created by Sanganal, Akshay on 8/9/17.
//  Copyright © 2017 U.S. Department of Labor. All rights reserved.
//

import UIKit

class LegalStandardsMultiWrapperViewController: UIViewController {

    var countryName = "Brazil";
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.legalStandardsMultiWrapper, metaData: self.countryName)
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
        
        if segue.identifier == "embedLegalStandardsWrapper"
        {
            Analytics.trackAction(.legalStandardsMultiWrapper, category: .embedLegalStandardsWrapper, metaData: self.countryName)
            let svc = segue.destination as! LegalStandardsMultiTableViewController
            svc.countryName = self.countryName;
            
            
        }
    }

   
    
    
}
