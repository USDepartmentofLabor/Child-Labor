//
//  FactSheetViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 9/6/15.
//  Copyright © 2015 U.S. Department of Labor. All rights reserved.
//

import UIKit

class FactSheetViewController: GAITrackedViewController {
    
    var factSheet = "Fact Sheet-Reports 3.34pm"

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Get the contents of the file to load
        let localFilePath = Bundle.main.path(forResource: factSheet, ofType: "pdf")
        let targetURL = URL(fileURLWithPath: localFilePath!)
        
        let pdfData = try? Data(contentsOf: targetURL)
        
        webView.load(pdfData!, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL() as URL )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.factSheet)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
