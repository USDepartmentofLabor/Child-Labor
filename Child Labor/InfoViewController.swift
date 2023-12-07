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
        let localFilePath = Bundle.main.path(forResource: infoContent, ofType: "html")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: localFilePath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        
        // Get the base URL of the file so we can access its resources
        let baseUrl = URL(fileURLWithPath: Bundle.main.bundlePath)
        
        // Load contents into the webview
        webView.loadHTMLString(contents as! String, baseURL: baseUrl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.info)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // If it's a web link
        if request.url!.scheme == "http" || request.url!.scheme == "https" || request.url!.scheme == "mailto" {
            UIApplication.shared.openURL(request.url!)
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
