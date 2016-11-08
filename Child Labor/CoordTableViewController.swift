//
//  CoordTableViewController.swift
//  Child Labor
//
//  Created by Trumaine Johnson on 5/20/16.
//  Copyright © 2016 U.S. Department of Labor. All rights reserved.
//

import UIKit

class CoordTableViewController: UITableViewController {
    
    var state = 0
    var countryName = "Brazil"
    
    
    @IBOutlet weak var coordLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Coordination Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as NSDictionary? as? [AnyHashable: Any])
        
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2015", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text == self.countryName {
                setMechanism(self.coordLabel, text: country["Mechanisms"]["Coordination"].element?.text)
                setMechanism(self.policyLabel, text: country["Mechanisms"]["Policy"].element?.text)
                setMechanism(self.programLabel, text: country["Mechanisms"]["Program"].element?.text)
            }
        }
    }
    
    func setMechanism(_ label: UILabel, text: String?) {
        if (text != nil) {
            label.text = text
            if (text!.hasPrefix("Yes") == true) {
                label.textColor = UIColor(red: 0.0, green: 0.75, blue: 0.0, alpha: 1.0)
            }
            else if (text!.hasPrefix("No") == true) {
                label.textColor = UIColor.red
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if state == section {
            return 1
        }
        
        return 1
    }
    
    @IBAction func changeSection(_ sender: AnyObject) {
        state = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if (state == section) {
//            // return UITableViewAutomaticDimension;
//        }
//        return CGFloat.min
//    }
//    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if (state == section) {
//            return UITableViewAutomaticDimension;
//        }
//        return CGFloat.min
//    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
