//
//  ProductsController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 3/8/15.
//  Copyright (c) 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class GoodsTableViewController: UITableViewController {
    
    var state = 0
    
    var goodsXML = SWXMLHash.parse("<xml></xml>")
    
    var allGoods = NSMutableArray()
    var numCountriesByGood: [String: Int] = [:]
    
    // Lists for countries in each advancement level section
    var manGoods = NSMutableArray()
    var agGoods = NSMutableArray()
    var minGoods = NSMutableArray()
    var othGoods = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Goods List Screen")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        // Populate the list
        let urlPath = NSBundle.mainBundle().pathForResource("goods_by_good_2013", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        goodsXML = SWXMLHash.parse(contents as! String)
        
        // Create lists of countries in each sector section
        for good in goodsXML["Goods"]["Good"] {
            if good["Countries"]["Country"].all.count > 0 {
                allGoods.addObject((good["Good_Name"].element?.text)!)
                numCountriesByGood.updateValue(good["Countries"]["Country"].all.count, forKey: (good["Good_Name"].element?.text)!)
                
                if good["Good_Sector"].element?.text == "Agriculture" {
                    agGoods.addObject((good["Good_Name"].element?.text)!)
                } else if good["Good_Sector"].element?.text == "Manufacturing" {
                    manGoods.addObject((good["Good_Name"].element?.text)!)
                } else if good["Good_Sector"].element?.text == "Mining" {
                    minGoods.addObject((good["Good_Name"].element?.text)!)
                } else {
                    othGoods.addObject((good["Good_Name"].element?.text)!)
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure the ugly table cell selection is cleared when returning to this view
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(tableIndex, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        switch state {
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch state {
        case 1:
            switch section {
            case 0:
                return "Agriculture/Forestry/Fishing"
            case 1:
                return "Manufacturing"
            case 2:
                return "Mining/Quarrying"
            case 3:
                return "Other"
            default:
                print("default")
            }
        default:
            return "All Goods"
        }
        
        return "N/A"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.

        switch state {
        case 1:
            switch section {
            case 0:
                return agGoods.count
            case 1:
                return manGoods.count
            case 2:
                return minGoods.count
            default:
                return othGoods.count
            }
            
        default:
            return allGoods.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var goodName = "Cotton"
        
        // Determine the grouping the user has selected
        switch state {
            
        //
        case 1:
            
            switch indexPath.section {
            case 0:
                goodName = agGoods[indexPath.row] as! String
            case 1:
                goodName = manGoods[indexPath.row] as! String
            case 2:
                goodName = minGoods[indexPath.row] as! String
            default:
                goodName = othGoods[indexPath.row] as! String
            }
            
            // Default
        default:
            goodName = allGoods[indexPath.row] as! String
        }
        
        cell.textLabel?.text = goodName
        cell.detailTextLabel?.text = String(numCountriesByGood[goodName]!)
        
        cell.imageView?.image = UIImage(named: goodName.stringByReplacingOccurrencesOfString("/", withString: ":"))
        
        // Resize icons
        let rect = CGRectMake(0, 0, 33, 33)
        let size = CGSizeMake(33, 33)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        cell.imageView?.image?.drawInRect(rect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        return cell
    }

    @IBAction func groupChanged(sender: UISegmentedControl) {
        state = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        // Determine the grouping the user has selected
//        switch state {
//            
//        // For A—Z mode
//        case 0:
//            return Array()
//            
//        case 1:
//            return ["Man", "Ag", "Min", "Oth"]
//            
//            // For other modes, no section index is necessary
//        default:
//            return Array()
//        }
//    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goodSelectedFromGoodsTable" {
            let svc = segue.destinationViewController as! GoodController
            svc.goodName = (sender as! UITableViewCell).textLabel!.text!
        }
    }

}
