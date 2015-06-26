//
//  CountryController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 5/11/15.
//  Copyright (c) 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController, NSXMLParserDelegate, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var countryName = "Brazil"
    
    var parser = NSXMLParser()
    var currentCountry = ""
    var goods = NSMutableArray()
    var goodsExploitationType = NSMutableArray()
    var clType = false
    var flType = false
    var fclType = false

    var element = NSString()
    var buffer = NSMutableString()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var countryProfile: UILabel!
    @IBOutlet weak var listHeader: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set view title
        self.title = countryName
        
        // Set labels
        countryTitle.text = countryName
        
        // Parse the country's data
        var urlpath = NSBundle.mainBundle().pathForResource("all_goods_by_country", ofType: "xml")
        let url:NSURL = NSURL.fileURLWithPath(urlpath!)!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure the ugly table cell selection is cleared when returning to this view
        if let tableIndex = self.tableView.indexPathForSelectedRow() {
            self.tableView.deselectRowAtIndexPath(tableIndex, animated: false)
        }
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        element = elementName
        
        buffer = NSMutableString.alloc()
        buffer = ""
        
        if elementName == "Good" {
            clType = false
            flType = false
            fclType = false
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        buffer.appendString(string!)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Country_Name" {
            currentCountry = buffer as String
        }
        
        if elementName == "Child_Labor" {
            if (buffer as String == "T") {
                clType = true
            }
        }
        
        if elementName == "Forced_Labor" {
            if (buffer as String == "T") {
                flType = true
            }
        }
        
        if elementName == "Forced_Child_Labor" {
            if (buffer as String == "T") {
                fclType = true
            }
        }
        
        if elementName == "Good_Name" {
            if currentCountry == countryName {
                goods.addObject(buffer)
            }
        }
        
        if elementName == "Good" {
            if currentCountry == countryName {
                if clType && !flType && !fclType {
                    goodsExploitationType.addObject(0)
                } else if !clType && flType && !fclType {
                    goodsExploitationType.addObject(1)
                } else if clType && flType && !fclType {
                    goodsExploitationType.addObject(2)
                } else {
                    goodsExploitationType.addObject(3)
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listHeader.text = String(goods.count) + " GOOD" + (goods.count == 1 ? "" : "S") + " PRODUCED WITH EXPLOITED LABOR"

        return goods.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Good", forIndexPath: indexPath) as! UICollectionViewCell
        
        //
        var goodButton : UIButton? = cell.viewWithTag(201) as? UIButton
        var goodLabel : UILabel? = cell.viewWithTag(301) as? UILabel
        
        //
        var cl : UIView? = cell.viewWithTag(101)
        var fl : UIView? = cell.viewWithTag(102)
        
        var clImage : UIImageView? = cl!.viewWithTag(401) as? UIImageView
        var clLabel : UILabel? = cl!.viewWithTag(402) as? UILabel
        
        // Parse out the name of the good
        var goodName = ((goods[indexPath.row]) as! String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        goodLabel?.text = goodName
        
        goodButton!.setImage(UIImage(named:goodName)?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        
        // Hide
        switch goodsExploitationType.objectAtIndex(indexPath.row) as! Int {
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Indicator") as! UITableViewCell
        
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
