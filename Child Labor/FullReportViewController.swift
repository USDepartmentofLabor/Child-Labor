//
//  FullReportViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 5/21/15.
//  Copyright (c) 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class FullReportViewController: GAITrackedViewController {
    
    var countryName = "Brazil"

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // View name for Google Analytics
        self.screenName = "Report PDF Screen"

        // Get the contents of the file to load
        let localFilePath = NSBundle.mainBundle().pathForResource(countryName, ofType: "pdf")
        let targetURL = NSURL.fileURLWithPath(localFilePath!)

        let pdfData = NSData(contentsOfURL: targetURL)
        
        webView.loadData(pdfData!, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL())
    }

    @IBAction func closeFullReport(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
