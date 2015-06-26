//
//  CountriesController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 3/8/15.
//  Copyright (c) 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class CountriesTableViewController: UITableViewController, NSXMLParserDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var countriesSearchBar: UISearchBar!
    
    var parser = NSXMLParser()
    var element = NSString()
    var buffer = NSMutableString()
    
    var countries = NSMutableArray()
    var regions = NSMutableArray()
    
    var state = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.countriesSearchBar.delegate = self
        
        // Give section index a clear background
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        
        // Hide search bar by default
        self.tableView.setContentOffset(CGPointMake(0, 44), animated: false)
        
        // Populate the list
        var urlpath = NSBundle.mainBundle().pathForResource("all_goods_by_country", ofType: "xml")
        let url:NSURL = NSURL.fileURLWithPath(urlpath!)!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
        
        var otherurlpath = NSBundle.mainBundle().pathForResource("countries_2013", ofType: "xml")
        var contents = NSString(contentsOfFile: otherurlpath!, encoding: NSUTF8StringEncoding, error: nil)
        let xml = SWXMLHash.parse(contents as! String)
        
        println(xml["Countries"]["Country"].all.count)
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
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        buffer.appendString(string!)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Country_Name" {
            countries.addObject(buffer)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        
        // Determine which grouping the user has selected
        switch state {
            
        // For A–Z mode
        case 0:
            return 26
        
        // For assessment level mode
        case 1:
            return 5
            
        // For region mode
        case 2:
            return 5
            
        // For region mode
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Determine which grouping the user has selected
        switch state {
            
        // For A–Z mode
        case 0:
            // Set section title for each letter of the alphabet
            return String(Array("ABCDEFGHIJKLMNOPQRSTUVQXYZ")[section])
        
        // For assessment level mode
        case 1:
            switch section {
            case 0:
                return "Significant Advancement"
            case 1:
                return "Moderate Advancement"
            case 2:
                return "Minimal Advancement"
            case 3:
                return "No Advancement"
            default:
                return "No Data"
            }
        
        // For region mode
        case 2:
            switch section {
            case 0:
                return "Asia & Pacific"
            case 1:
                return "Europe & Eurasia"
            case 2:
                return "Latin America & Caribbean"
            case 3:
                return "Middle East & North Africa"
            default:
                return "Sub-Saharan Africa"
            }
        
        // For region mode
        default:
            return "All Countries"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        
        // Determine the grouping the user has selected
        switch state {
        
        // For A–Z mode
        case 0:
            
            var letter = Array("ABCDEFGHIJKLMNOPQRSTUVQXYZ")[section]
            
            // Count countries starting with this letter
            var numberOfCountriesStartingWithThisLetter = 0
            for country in countries {
                if Array((country as! NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))[0] == letter {
                    numberOfCountriesStartingWithThisLetter++
                }
            }
            
            return numberOfCountriesStartingWithThisLetter
            
        // For assessment level mode
        case 1:
            return 5
            
        // For region mode
        case 2:
            return 5
            
        // For region mode
        default:
            return countries.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        // Determine index of first country with this letter
        var letter = Array("ABCDEFGHIJKLMNOPQRSTUVQXYZ")[indexPath.section]
        
        // Count countries starting with this letter
        var startingCountryIndex = 0
        for country in countries {
            if Array((country as! NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()))[0] != letter {
                startingCountryIndex++
            } else {
                break;
            }
        }
        
        var countryName = (countries.objectAtIndex(startingCountryIndex + indexPath.row) as! NSString).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        cell.textLabel?.text = countryName
        let flagImage = UIImage(named: countryName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil))
        cell.imageView?.image = flagImage
        
        // Resize icons
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

        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
        // Determine the grouping the user has selected
        switch state {
        
        // For A—Z mode
        case 0:
            return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
            
        // For other modes, no section index is necessary
        default:
            return Array()
        }
    }

    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
//        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }

    @IBAction func groupChanged(sender: UISegmentedControl) {
        state = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "countrySelectedFromCountriesTable" {
            var svc = segue.destinationViewController as! CountryViewController
            svc.countryName = (sender as! UITableViewCell).textLabel!.text!
        }
    }

}
