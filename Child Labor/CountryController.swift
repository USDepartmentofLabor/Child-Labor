//
//  CountryController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/8/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class CountryController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var countryName = "Brazil"
    
    var goods = NSMutableArray()
    var exploitations = NSMutableArray()

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var advancementLevel: UILabel!
    @IBOutlet weak var countryMap: UIImageView!
    @IBOutlet weak var countryProfile: UILabel!
    @IBOutlet weak var collectionHeader: UILabel!
    @IBOutlet weak var goodsCollection: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Set view title
        self.title = countryName
        
        // Set labels
        countryTitle.text = countryName
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_xls_2013", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text == self.countryName {
                countryMap.image = UIImage(named: (country["Name"].element?.text)! + "-map")
                if (country["Advancement_Level"].element?.text != nil) {
                    if (country["Advancement_Level"].element?.text)! == "No Advancement" {
                        advancementLevel.text = (country["Advancement_Level"].element?.text)!
                    } else {
                        advancementLevel.text = (country["Advancement_Level"].element?.text)! + " Advancement"
                    }
                } else {
                    advancementLevel.text = "No Assessment Level Data"
                }
                
                // If there is no profile for this country
                if country["Description"].element?.text == nil {
                    // Hide the "more" button
                    moreButton.hidden = true
                    
                    // Reduce the height of the country profile label to 0
                    countryProfile.addConstraints([NSLayoutConstraint(item: countryProfile, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0)])
                    
                    // Expand header frame relative to new profile height
                    let oldHeightOfHeaderView = headerView.frame.height
                    var newRect = headerView.frame
                    newRect.size.height = oldHeightOfHeaderView - 96
                    headerView.frame = newRect
                    self.tableView.tableHeaderView = headerView
                } else {
                    countryProfile.text = country["Description"].element?.text
                }
                
                // If there are no goods for this country
                if country["Goods"]["Good"].all.count == 0 {
                    let oldCollectionHeaderHeight = collectionHeader.frame.height
                    let oldCollectionViewHeight = goodsCollection.frame.height
                    
                    // Hide the goods collection by adjusting its height constraint
                    collectionHeader.addConstraints([NSLayoutConstraint(item: collectionHeader, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0)])
                    goodsCollection.addConstraints([NSLayoutConstraint(item: goodsCollection, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0)])

                    // Reduce the height of the header view by the height of the collection
                    let oldHeightOfHeaderView = headerView.frame.height
                    var newRect = headerView.frame
                    newRect.size.height = oldHeightOfHeaderView - (oldCollectionHeaderHeight + oldCollectionViewHeight)
                    headerView.frame = newRect
                    self.tableView.tableHeaderView = headerView
                } else {
                    for good in country["Goods"]["Good"] {
                        let goodName = good["Good_Name"].element?.text
                        
                        let childLaborStatusForGood = good["Child_Labor"].element?.text
                        let forcedLaborStatusForGood = good["Forced_Labor"].element?.text
                        let forcedChildLaborStatusForGood = good["Forced_Child_Labor"].element?.text
                        
                        goods.addObject(goodName!)
                        
                        // Add the exploitation type to an array
                        if childLaborStatusForGood == "Yes" && forcedLaborStatusForGood == "No" {
                            exploitations.addObject(0)
                        } else if childLaborStatusForGood == "No" && forcedLaborStatusForGood == "Yes" {
                            exploitations.addObject(1)
                        } else if childLaborStatusForGood == "Yes" && forcedLaborStatusForGood == "Yes" && forcedChildLaborStatusForGood == "No" {
                            exploitations.addObject(2)
                        } else {
                            exploitations.addObject(3)
                        }
                    }
                }
                
                break;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionHeader.text = String(goods.count) + " GOOD" + (goods.count == 1 ? "" : "S") + " PRODUCED WITH EXPLOITIVE LABOR"
        
        return goods.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Good", forIndexPath: indexPath) as UICollectionViewCell
        
        //
        let goodButton : UIButton? = cell.viewWithTag(201) as? UIButton
        let goodLabel : UILabel? = cell.viewWithTag(301) as? UILabel
        
        //
        let cl : UIView? = cell.viewWithTag(101)
        let fl : UIView? = cell.viewWithTag(102)
        
        let clImage : UIImageView? = cl!.viewWithTag(401) as? UIImageView
        let clLabel : UILabel? = cl!.viewWithTag(402) as? UILabel
        
        //        var countryIndex = 0
        //        for country in countriesXML["Countries"]["Country"] {
        //            if country["Name"].element?.text != self.countryName {
        //                countryIndex++
        //            } else {
        //                break;
        //            }
        //        }
        //
        // Parse out the name of the good
        let goodName = goods[indexPath.row]
        
        goodLabel?.text = goodName as? String
        goodButton!.setImage(UIImage(named:goodName.stringByReplacingOccurrencesOfString("/", withString: ":"))?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        //
        switch exploitations[indexPath.row] as! Int {
        case 0:
            cl?.hidden = false
            fl?.hidden = true
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
        case 1:
            cl?.hidden = true
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
        case 2:
            cl?.hidden = false
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
        default:
            cl?.hidden = false
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand-black")
            clLabel?.textColor = UIColor.blackColor()
            clLabel?.text = "FCL"
        }
        
        return cell
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 4
        default:
            return 1
        }
    }

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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    @IBAction func showWholeProfile(sender: AnyObject) {
        let oldHeightOfCountryProfile = countryProfile.frame.height
        let oldHeightOfHeaderView = headerView.frame.height

        // Expand the label with the profile in it
        countryProfile.numberOfLines = 0
        countryProfile.lineBreakMode = NSLineBreakMode.ByWordWrapping
        countryProfile.sizeToFit()
        
        // Hide the "more" button
        (sender as! UIView).hidden = true
        
        // Expand header frame relative to new profile height
        var newRect = headerView.frame
        newRect.size.height = oldHeightOfHeaderView - oldHeightOfCountryProfile + countryProfile.frame.height
        headerView.frame = newRect
        self.tableView.tableHeaderView = headerView
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goodSelectedFromCountryProfile" {
            let svc = segue.destinationViewController as! GoodController
            svc.goodName = ((sender as! UIButton).superview?.viewWithTag(301) as! UILabel).text!
        } else if segue.identifier == "presentFullReportDocument" {
            let svc = segue.destinationViewController as! FullReportViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentSuggestedActions" {
            let svc = segue.destinationViewController as! SuggestedActionsTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentStatistics" {
            let svc = segue.destinationViewController as! StatisticsTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentConventions" {
            let svc = segue.destinationViewController as! ConventionsTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentLaws" {
            let svc = segue.destinationViewController as! LawsTableViewController
            svc.countryName = self.countryName
        }
    }

}
