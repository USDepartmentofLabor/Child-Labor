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
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let svc = segue.destination as! LegalStandardsTableViewController
        svc.countryName = self.countryName;
        

    }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
 
}
