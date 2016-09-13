//
//  GoodController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/8/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class GoodController: UITableViewController {
    
    var goodName = "Cotton"
    
    var countries = NSMutableArray()
    var exploitations = NSMutableArray()
    
    @IBOutlet weak var goodTitle: UILabel!
    @IBOutlet weak var goodImage: UIImageView!
    @IBOutlet weak var sector: UILabel!
    
    var state = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Good Profile Screen")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        // Do any additional setup after loading the view.
        self.title = goodName
        goodTitle.text = goodName
        goodImage.image = UIImage(named:"icons_" + goodName.stringByReplacingOccurrencesOfString("/", withString: "_").stringByReplacingOccurrencesOfString(" ", withString: "_"))!
        
        let urlPathGoods = NSBundle.mainBundle().pathForResource("goods_2015", ofType: "xml")
        var contentsGoods: NSString?
        do {
            contentsGoods = try NSString(contentsOfFile: urlPathGoods!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contentsGoods = nil
        }
        let goodsXML = SWXMLHash.parse(contentsGoods as! String)
        
        for good in goodsXML["Goods"]["Good"] {
            if good["Good_Name"].element?.text == self.goodName {
                sector.text = good["Good_Sector"].element?.text
                
                for country in good["Countries"]["Country"] {
                    countries.addObject((country["Country_Name"].element?.text)!)
                    
                    // Add the exploitation type to an array
                    if country["Child_Labor"].element?.text == "Yes" && country["Forced_Labor"].element?.text == "No" {
                        exploitations.addObject(0)
                    } else if country["Child_Labor"].element?.text == "No" && country["Forced_Labor"].element?.text == "Yes" {
                        exploitations.addObject(1)
                    } else if country["Child_Labor"].element?.text == "Yes" && country["Forced_Labor"].element?.text == "Yes" && country["Forced_Child_Labor"].element?.text == "No" {
                        exploitations.addObject(2)
                    } else {
                        exploitations.addObject(3)
                    }
                }
                
                break;
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
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var typeOfLabor = ""
        var numCountriesWithThisType = 0
        switch state {
        case 0:
            typeOfLabor = "Exploitive"
            
            numCountriesWithThisType = countries.count
        case 1:
            typeOfLabor = "Child"

            for i in 0...countries.count - 1 {
                if exploitations[i] as! Int == 0 || exploitations[i] as! Int == 2 || exploitations[i] as! Int == 3 {
                    numCountriesWithThisType += 1
                }
            }
        case 2:
            typeOfLabor = "Forced"

            for i in 0...countries.count - 1 {
                if exploitations[i] as! Int == 1 || exploitations[i] as! Int == 2 || exploitations[i] as! Int == 3 {
                    numCountriesWithThisType += 1
                }
            }
        default:
            typeOfLabor = "Forced Child"

            for i in 0...countries.count - 1 {
                if exploitations[i] as! Int == 3 {
                    numCountriesWithThisType += 1
                }
            }
}
        
        return "Produced With \(typeOfLabor) Labor in \(numCountriesWithThisType) Countr" + (numCountriesWithThisType == 1 ? "y" : "ies")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If you want the grouped table view in iOS 9 to have a white background, you need to override it here
        tableView.backgroundColor = UIColor.whiteColor()
        
        return countries.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Country", forIndexPath: indexPath)
        
        //
        let countryName = (countries.objectAtIndex(indexPath.row) as! NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        //
        let cl : UIView? = cell.viewWithTag(101)
        let fl : UIView? = cell.viewWithTag(102)
        let titleLabel : UILabel? = cell.viewWithTag(301) as? UILabel
        
        let clImage : UIImageView? = cl!.viewWithTag(201) as? UIImageView
        let clLabel : UILabel? = cl!.viewWithTag(202) as? UILabel
        
        titleLabel?.text = countryName
        let flagImage = UIImage(named: countryName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("ô", withString: "o", options: NSStringCompareOptions.LiteralSearch, range: nil))
        cell.imageView?.image = flagImage
        
        // Resize flag icons to a constant width, centered vertically
        if (flagImage != nil) {
            let adjustedWidth = flagImage!.size.width * 44 / flagImage!.size.height
            
            let size = CGSizeMake(42, 44)
            if adjustedWidth >= 42 {
                let rect = CGRectMake(0, ((44 - (flagImage!.size.height * 42 / flagImage!.size.width)) / 2), 42, flagImage!.size.height * 42 / flagImage!.size.width)
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
                cell.imageView?.image?.drawInRect(rect)
                cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext();
            } else {
                let rect = CGRectMake(0, 0, adjustedWidth, size.height)
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
                cell.imageView?.image?.drawInRect(rect)
                cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext();
            }
        }
        
        cell.backgroundColor = UIColor.whiteColor()
        titleLabel?.textColor = UIColor.blackColor()
        cell.userInteractionEnabled = true
        
        //
        switch exploitations[indexPath.row] as! Int {
        case 0:
            cl?.hidden = false
            fl?.hidden = true
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
            
            if state == 2 || state == 3 {
                cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                titleLabel?.textColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                cell.userInteractionEnabled = false
            }
        case 1:
            cl?.hidden = true
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
            
            if state == 1 || state == 3 {
                cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                titleLabel?.textColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
                cell.userInteractionEnabled = false
            }
        case 2:
            cl?.hidden = false
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
            
            if state == 3 {
                cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                titleLabel?.textColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
                cell.userInteractionEnabled = false
            }
        default:
            cl?.hidden = false
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand-black")
            clLabel?.textColor = UIColor.blackColor()
            clLabel?.text = "FCL"
            clLabel?.accessibilityLabel = "Forced Child Labor"
        }

        return cell
    }

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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    @IBAction func filterChanged(sender: AnyObject) {
        state = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "countrySelectedFromGoodView" {
            let svc = segue.destinationViewController as! CountryController
            svc.countryName = ((sender as! UITableViewCell).viewWithTag(301) as! UILabel).text!
        }
    }

}
