//
//  CountryController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 5/11/15.
//  Copyright (c) 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var countryName = "Brazil"
    
    var goods = NSMutableArray()
    var exploitations = NSMutableArray()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var advancementLevel: UILabel!
    @IBOutlet weak var countryProfile: UILabel!
    @IBOutlet weak var listHeader: UILabel!
    @IBOutlet weak var countryMap: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContent: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set view title
        self.title = self.countryName
        
        // Set labels
        countryTitle.text = self.countryName
        
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
                    advancementLevel.text = (country["Advancement_Level"].element?.text)! + " Advancement"
                } else {
                    advancementLevel.text = "No Assessment Level Data"
                }
                countryProfile.text = country["Description"].element?.text
                
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listHeader.text = String(goods.count) + " GOOD" + (goods.count == 1 ? "" : "S") + " PRODUCED WITH EXPLOITED LABOR"
        
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
            clLabel?.text = "Child"
        case 1:
            cl?.hidden = true
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "Child"
        case 2:
            cl?.hidden = false
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "Child"
        default:
            cl?.hidden = false
            fl?.hidden = false
            clImage?.image = UIImage(named: "hand-black")
            clLabel?.textColor = UIColor.blackColor()
            clLabel?.text = "F. Child"
        }

        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
        case 0:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Indicator")!
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Suggested Actions"
            case 1:
                cell.textLabel?.text = "Statistics"
            case 2:
                cell.textLabel?.text = "International Conventions"
            default:
                cell.textLabel?.text = "Laws"
            }
        default:
            switch indexPath.row {
            default:
                cell.textLabel?.text = "Report PDF"
            }

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.performSegueWithIdentifier("presentSuggestedActions", sender: self)
            case 1:
                self.performSegueWithIdentifier("presentStatistics", sender: self)
            case 2:
                self.performSegueWithIdentifier("presentConventions", sender: self)
            default:
                self.performSegueWithIdentifier("presentLaws", sender: self)
            }
        default:
            switch indexPath.row {
            default:
                self.performSegueWithIdentifier("presentFullReportDocument", sender: self)
            }
            
        }
    }

    @IBAction func showEntireProfile(sender: AnyObject) {
        // Expand the label with the profile in it
        self.countryProfile.numberOfLines = 0
        self.countryProfile.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.countryProfile.sizeToFit()
        
        // Hide the "more" button
        (sender as! UIView).hidden = true
        
        // Expand the size of the scroll content view
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width, countryProfile.frame.height + 575)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goodSelectedFromCountryProfile" {
            let svc = segue.destinationViewController as! GoodViewController
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
