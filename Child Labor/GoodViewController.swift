//
//  GoodController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 5/11/15.
//  Copyright (c) 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class GoodViewController: UIViewController, UITableViewDelegate {
    
    var goodName = "Cotton"
    
    var countriesXML = SWXMLHash.parse("<xml></xml>")
    var goodsXML = SWXMLHash.parse("<xml></xml>")
    
    var countries = NSMutableArray()
    var exploitations = NSMutableArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var goodImage: UIImageView!
    @IBOutlet weak var goodTitle: UILabel!
    
    @IBOutlet weak var sector: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = goodName
        goodTitle.text = goodName
        goodImage.image = UIImage(named:goodName.stringByReplacingOccurrencesOfString("/", withString: ":"))!

        let urlPath = NSBundle.mainBundle().pathForResource("countries_xls_2013", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        countriesXML = SWXMLHash.parse(contents as! String)
        
        let urlPathGoods = NSBundle.mainBundle().pathForResource("goods_by_good_2013", ofType: "xml")
        var contentsGoods: NSString?
        do {
            contentsGoods = try NSString(contentsOfFile: urlPathGoods!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contentsGoods = nil
        }
        goodsXML = SWXMLHash.parse(contentsGoods as! String)
        
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "PRODUCED WITH EXPLOITED LABOR IN " + String(countries.count) + " COUNTR" + (countries.count == 1 ? "Y" : "IES")
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        var frame = tableView.frame
        frame.size.height = CGFloat(countries.count * 44) + 88
        tableView.frame = frame
        
        return countries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Country")!
        
        let countryName = (countries.objectAtIndex(indexPath.row) as! NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        //
        let cl : UIView? = cell.viewWithTag(101)
        let fl : UIView? = cell.viewWithTag(102)
        
        let clImage : UIImageView? = cl!.viewWithTag(201) as? UIImageView
        let clLabel : UILabel? = cl!.viewWithTag(202) as? UILabel
        
        cell.textLabel?.text = countryName
        let flagImage = UIImage(named: countryName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil))
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "countrySelectedFromGoodView" {
            let svc = segue.destinationViewController as! CountryViewController
            svc.countryName = (sender as! UITableViewCell).textLabel!.text!
        }
    }

}
