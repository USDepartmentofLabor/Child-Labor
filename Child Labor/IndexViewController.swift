//
//  IndexViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 5/26/15.
//  U.S. Government Work https://www.usa.gov/government-works
//

import UIKit

class IndexViewController: GAITrackedViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // View name for Google Analytics
        self.screenName = "Index Screen"
        
        // Navigation bar color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Background image
        let bgImageView = UIImageView(image: UIImage(named: "eo"))
        bgImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.tableView.backgroundView = bgImageView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clears selection on viewWillAppear
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(tableIndex, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Screen")!
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Countries"
        case 1:
            cell.textLabel?.text = "Goods"
        default:
            cell.textLabel?.text = "Exploitation Type"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegueWithIdentifier("countriesSelectedFromIndex", sender: self)
        case 1:
            self.performSegueWithIdentifier("goodsSelectedFromIndex", sender: self)
        default:
            self.performSegueWithIdentifier("exploitationSelectedFromIndex", sender: self)
        }
    }

    @IBAction func openIlabWebsite(sender: AnyObject) {
        // Open website
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.dol.gov/ilab/")!)
    }
    
    @IBAction func openDolWebsite(sender: AnyObject) {
        // Open website
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.dol.gov")!)
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
