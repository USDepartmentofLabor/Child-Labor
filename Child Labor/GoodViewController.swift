//
//  GoodController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 5/11/15.
//  Copyright (c) 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class GoodViewController: UIViewController, NSXMLParserDelegate, UITableViewDelegate {
    
    var goodName = "Cotton"
    
    var countriesXML = SWXMLHash.parse("<xml></xml>")
    var goodsXML = SWXMLHash.parse("<xml></xml>")
    
    var parser = NSXMLParser()
    var currentGood = ""
    var countries = NSMutableArray()
    var countryExploitationType = NSMutableArray()
    var clType = false
    var flType = false
    var fclType = false
    var elements = NSMutableDictionary()
    var element = NSString()
    var buffer = NSMutableString()
    var sortedArray = NSArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var goodImage: UIImageView!
    @IBOutlet weak var goodTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = goodName
        goodTitle.text = goodName
        goodImage.image = UIImage(named:goodName.stringByReplacingOccurrencesOfString("/", withString: ":"))!

        let urlpath = NSBundle.mainBundle().pathForResource("all_goods_by_good", ofType: "xml")
        let url:NSURL = NSURL.fileURLWithPath(urlpath!)
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
        
        let urlPath = NSBundle.mainBundle().pathForResource("countries_2013", ofType: "xml")
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName
        
        buffer = NSMutableString.alloc()
        buffer = ""
        
        if elementName == "Country" {
            clType = false
            flType = false
            fclType = false
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        buffer.appendString(string!)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Good_Name" {
            currentGood = buffer as String
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

        
        if elementName == "Country_Name" {
            if currentGood == goodName {
                countries.addObject(buffer)
            }
        }
        if elementName == "Country" {
            if currentGood == goodName {
                if clType && !flType && !fclType {
                    countryExploitationType.addObject(0)
                } else if !clType && flType && !fclType {
                    countryExploitationType.addObject(1)
                } else if clType && flType && !fclType {
                    countryExploitationType.addObject(2)
                } else {
                    countryExploitationType.addObject(3)
                }
                
            }
        }
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
        let clView : UIView? = cell.viewWithTag(101)
        let flView : UIView? = cell.viewWithTag(102)
        
        let clImage : UIImageView? = clView!.viewWithTag(201) as? UIImageView
        let clLabel : UILabel? = clView!.viewWithTag(202) as? UILabel
        
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
        
        // Hide
        switch countryExploitationType.objectAtIndex(indexPath.row) as! Int {
        case 0:
            clView?.hidden = false
            flView?.hidden = true
        case 1:
            clView?.hidden = true
            flView?.hidden = false
        case 2:
            clView?.hidden = false
            flView?.hidden = false
        case 3:
            clView?.hidden = false
            flView?.hidden = false
            
            clImage?.image = UIImage(named: "hand-black")
            clLabel?.textColor = UIColor.blackColor()
            clLabel?.text = "Forced Child"
        default:
            break
        }
        
        // Because of iOS 7+ bug, cell background needs to be set to transparent after all other manipulations of the cell, or it reverts back to white
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
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
