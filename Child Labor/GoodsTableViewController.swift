//
//  ProductsController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 3/8/15.
//  Copyright (c) 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class GoodsTableViewController: UITableViewController, NSXMLParserDelegate {
    
    var parser = NSXMLParser()
    var goods = NSMutableArray()
    var countries = NSMutableArray()
    var currentGood = ""
    var numCountriesPerGood = NSMutableDictionary()
    var element = NSString()
    var buffer = NSMutableString()
    var sortedArray = NSArray()
    
    var state = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Hide search bar by default
        self.tableView.setContentOffset(CGPointMake(0, 44), animated: false)
        
        var urlpath = NSBundle.mainBundle().pathForResource("all_goods_by_good", ofType: "xml")
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
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        buffer.appendString(string!)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Good_Name" {
            goods.addObject(buffer)
            currentGood = buffer as String
            countries = NSMutableArray()
        }
        
        if elementName == "Good_List" {
//            // Eliminate duplicates
//            goods.setArray(NSSet(array: goods as [AnyObject]).allObjects)
//            
            // Alphabitize goods
            sortedArray = (goods as AnyObject as! [String]).sorted {$0 < $1}
        }
        
        if elementName == "Country" {
            countries.addObject(buffer)
        }
        
        if elementName == "Good" {
            numCountriesPerGood[currentGood] = String(countries.count)
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
                println("default")
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
            return 8
        default:
            return goods.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var goodName = (sortedArray.objectAtIndex(indexPath.row) as? String)!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        cell.textLabel?.text = goodName
        cell.detailTextLabel?.text = numCountriesPerGood[goodName] as? String
        
        cell.imageView?.image = UIImage(named: goodName)
        
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
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        //        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        //        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goodSelectedFromGoodsTable" {
            var svc = segue.destinationViewController as! GoodViewController
            svc.goodName = (sender as! UITableViewCell).textLabel!.text!
        }
    }

}
