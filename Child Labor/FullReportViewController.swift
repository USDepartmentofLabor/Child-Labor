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
        
        // Get the contents of the file to load
        let localFilePath = Bundle.main.path(forResource: countryName, ofType: "pdf")
        let targetURL = URL(fileURLWithPath: localFilePath!)

        let pdfData = try? Data(contentsOf: targetURL)
        
        webView.load(pdfData!, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL() as URL)
    }

    @IBAction func closeFullReport(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
