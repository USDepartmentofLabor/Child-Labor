//
//  FullReportViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 5/21/15.
//  U.S. Government Work https://www.usa.gov/government-works
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
        
        // Territories without their own PDF identified by ILAB should link to the "miscellaneous" PDF
        switch countryName {
        case "British Virgin Islands", "Christmas Island", "Cocos (Keeling) Islands", "Cook Islands", "Falkland Islands (Islas Malvinas)", "Montserrat", "Niue", "Norfolk Island", "Saint Helena, Ascension, and Tristan de Cunha", "Tokelau", "Wallis and Futuna", "West Bank and the Gaza Strip", "Western Sahara":
            countryName = "All_Non-IndependentCountriesTerritories"
        default:
            break
        }
        
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
