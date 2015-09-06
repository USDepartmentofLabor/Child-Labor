//
//  InfoViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/31/15.
//  Copyright © 2015 U.S. Department of Labor. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var infoContent = "aboutthisapp"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.delegate = self
        
        // Set navigation bar title
        if infoContent == "aboutthisapp" {
            self.title = "About This App"
        } else if infoContent == "methodology" {
            self.title = "Methodology"
        }
        
        // Get the contents of the file to load
        let localFilePath = NSBundle.mainBundle().pathForResource(infoContent, ofType: "html")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: localFilePath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        
        // Get the base URL of the file so we can access its resources
        let baseUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
        
        // Load contents into the webview
        webView.loadHTMLString(contents as! String, baseURL: baseUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // If it's a web link
        if request.URL!.scheme == "http" || request.URL!.scheme == "https" || request.URL!.scheme == "mailto" {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        
        // If it's the initial load
        return true
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
