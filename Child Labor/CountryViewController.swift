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
    
    var countriesXML = SWXMLHash.parse("<xml></xml>")
    var goodsXML = SWXMLHash.parse("<xml></xml>")
    
    var goods = NSMutableArray()
    var exploitations = NSMutableArray()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var advancementLevel: UILabel!
    @IBOutlet weak var countryProfile: UILabel!
    @IBOutlet weak var listHeader: UILabel!
    @IBOutlet weak var countryMap: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set view title
        self.title = self.countryName
        
        // Set labels
        countryTitle.text = self.countryName
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_2013", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        countriesXML = SWXMLHash.parse(contents as! String)
        
        // Get the goods data
        let urlPathGoods = NSBundle.mainBundle().pathForResource("goods_by_good_2013", ofType: "xml")
        var contentsGoods: NSString?
        do {
            contentsGoods = try NSString(contentsOfFile: urlPathGoods!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contentsGoods = nil
        }
        goodsXML = SWXMLHash.parse(contentsGoods as! String)
        
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text == self.countryName {
                advancementLevel.text = country["Advancement_Level"].element?.text
                countryProfile.text = country["Description"].element?.text
                countryMap.image = UIImage(named: (country["Name"].element?.text)! + "-map")
                
                for good in country["Goods"]["Good"] {
                    goods.addObject((good["Good_Name"].element?.text)!)
                    
                    // Add the exploitation type to an array
                    if good["Child_Labor"].element?.text == "Yes" && good["Forced_Labor"].element?.text == "No" {
                        exploitations.addObject(0)
                    } else if good["Child_Labor"].element?.text == "Yes" && good["Forced_Labor"].element?.text == "No" {
                        exploitations.addObject(1)
                    } else if good["Child_Labor"].element?.text == "Yes" && good["Forced_Labor"].element?.text == "Yes" && good["Forced_Child_Labor"].element?.text == "No" {
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
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text == self.countryName {
                let numGoods = country["Goods"]["Good"].all.count
                
                listHeader.text = String(numGoods) + " GOOD" + (numGoods == 1 ? "" : "S") + " PRODUCED WITH EXPLOITED LABOR"
                
                return numGoods
            }
        }
        
        return 0
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
        
        var countryIndex = 0
        for country in countriesXML["Countries"]["Country"] {
            if country["Name"].element?.text != self.countryName {
                countryIndex++
            } else {
                break;
            }
        }
        
        // Parse out the name of the good
        let goodName = countriesXML["Countries"]["Country"][countryIndex]["Goods"]["Good"][indexPath.row]["Good_Name"].element?.text
        
        goodLabel?.text = goodName
        goodButton!.setImage(UIImage(named:goodName!)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        // 
        switch exploitations[indexPath.row] as! Int {
        case 0:
            cl?.hidden = false
            fl?.hidden = true
        case 1:
            cl?.hidden = true
            fl?.hidden = false
        case 2:
            cl?.hidden = false
            fl?.hidden = false
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
                cell.textLabel?.text = "Conventions"
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
