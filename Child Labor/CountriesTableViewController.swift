//
//  CountriesController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 3/8/15.
//  U.S. Government Work https://www.usa.gov/government-works
//

import UIKit

class CountriesTableViewController: UITableViewController {
    
    var state = 0
    
    var hasDataByCounty: [String: Bool] = [:]
    
    // Lists for countries in each letter section
    var aCountries = NSMutableArray()
    var bCountries = NSMutableArray()
    var cCountries = NSMutableArray()
    var dCountries = NSMutableArray()
    var eCountries = NSMutableArray()
    var fCountries = NSMutableArray()
    var gCountries = NSMutableArray()
    var hCountries = NSMutableArray()
    var iCountries = NSMutableArray()
    var jCountries = NSMutableArray()
    var kCountries = NSMutableArray()
    var lCountries = NSMutableArray()
    var mCountries = NSMutableArray()
    var nCountries = NSMutableArray()
    var oCountries = NSMutableArray()
    var pCountries = NSMutableArray()
    var qCountries = NSMutableArray()
    var rCountries = NSMutableArray()
    var sCountries = NSMutableArray()
    var tCountries = NSMutableArray()
    var uCountries = NSMutableArray()
    var vCountries = NSMutableArray()
    var wCountries = NSMutableArray()
    var xCountries = NSMutableArray()
    var yCountries = NSMutableArray()
    var zCountries = NSMutableArray()
    
    // Lists for countries in each advancement level section
    var sigCountries = NSMutableArray()
    var modCountries = NSMutableArray()
    var minCountries = NSMutableArray()
    var noCountries = NSMutableArray()
    var noDataCountries = NSMutableArray()
    
    // Lists for countries in each region section
    var asiaCountries = NSMutableArray()
    var europeCountries = NSMutableArray()
    var latinCountries = NSMutableArray()
    var middleCountries = NSMutableArray()
    var saharanCountries = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: "Countries List Screen")
        tracker.send(GAIDictionaryBuilder.createAppView().build() as [NSObject : AnyObject])
        
        // Give section index a clear background
        self.tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        
        // Get the country data
        let urlPath = NSBundle.mainBundle().pathForResource("countries_for_app_2013", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        var countriesXML = SWXMLHash.parse(contents as! String)
        
        // For each country
        for country in countriesXML["Countries"]["Country"] {
            let countryName = country["Name"].element?.text
            
            // Create lists of countries in each letter section
            if Array(countryName!.characters)[0] == "A" {
                aCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "B" {
                bCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "C" {
                cCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "D" {
                dCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "E" {
                eCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "F" {
                fCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "G" {
                gCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "H" {
                hCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "I" {
                iCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "J" {
                jCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "K" {
                kCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "L" {
                lCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "M" {
                mCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "N" {
                nCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "O" {
                oCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "P" {
                pCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "Q" {
                qCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "R" {
                rCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "S" {
                sCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "T" {
                tCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "U" {
                uCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "V" {
                vCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "W" {
                wCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "X" {
                xCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "Y" {
                yCountries.addObject(countryName!)
            } else if Array(countryName!.characters)[0] == "Z" {
                zCountries.addObject(countryName!)
            }

            // Create lists of countries in each advancement level section
            if country["Advancement_Level"].element?.text == "Significant Advancement" {
                sigCountries.addObject(countryName!)
            } else if country["Advancement_Level"].element?.text == "Moderate Advancement" {
                modCountries.addObject(countryName!)
            } else if country["Advancement_Level"].element?.text == "Minimal Advancement" {
                minCountries.addObject(countryName!)
            } else if country["Advancement_Level"].element?.text == "No Advancement" {
                noCountries.addObject(countryName!)
            } else {
                noDataCountries.addObject(countryName!)
            }

            // Create lists of countries in each region section
            if country["Region"].element?.text == "Asia & Pacific" {
                asiaCountries.addObject(countryName!)
            } else if country["Region"].element?.text == "Europe & Eurasia" {
                europeCountries.addObject(countryName!)
            } else if country["Region"].element?.text == "Latin America & Caribbean" {
                latinCountries.addObject(countryName!)
            } else if country["Region"].element?.text == "Middle East & North Africa" {
                middleCountries.addObject(countryName!)
            } else if country["Region"].element?.text == "Sub-Saharan Africa" {
                saharanCountries.addObject(countryName!)
            }
            
            // Record whether each country has a profile in an associative array
            if (country["Description"].element?.text == nil && country["Goods"]["Good"].all.count == 0) {
                hasDataByCounty[countryName!] = false
            } else {
                hasDataByCounty[countryName!] = true
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
            
        // Default
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
            return String(Array("ABCDEFGHIJKLMNOPQRSTUVQXYZ".characters)[section])
        
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
        
        // Default
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
            // Get the letter for this section
//            let letter = Array("ABCDEFGHIJKLMNOPQRSTUVQXYZ".characters)[section]
            
            switch section {
            case 0:
                return aCountries.count
            case 1:
                return bCountries.count
            case 2:
                return cCountries.count
            case 3:
                return dCountries.count
            case 4:
                return eCountries.count
            case 5:
                return fCountries.count
            case 6:
                return gCountries.count
            case 7:
                return hCountries.count
            case 8:
                return iCountries.count
            case 9:
                return jCountries.count
            case 10:
                return kCountries.count
            case 11:
                return lCountries.count
            case 12:
                return mCountries.count
            case 13:
                return nCountries.count
            case 14:
                return oCountries.count
            case 15:
                return pCountries.count
            case 16:
                return qCountries.count
            case 17:
                return rCountries.count
            case 18:
                return sCountries.count
            case 19:
                return tCountries.count
            case 20:
                return uCountries.count
            case 21:
                return vCountries.count
            case 22:
                return wCountries.count
            case 23:
                return xCountries.count
            case 24:
                return yCountries.count
            case 25:
                return zCountries.count
            default:
                return aCountries.count
            }
            
        // For assessment level mode
        case 1:
            switch section {
            case 0:
                return sigCountries.count
            case 1:
                return modCountries.count
            case 2:
                return minCountries.count
            case 3:
                return noCountries.count
            default:
                return noDataCountries.count
            }
            
        // For region mode
        default:
            switch section {
            case 0:
                return asiaCountries.count
            case 1:
                return europeCountries.count
            case 2:
                return latinCountries.count
            case 3:
                return middleCountries.count
            default:
                return saharanCountries.count
            }
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell")!
        
        var countryName = ""
        
        // Determine the grouping the user has selected
        switch state {
            
        // For A–Z mode
        case 0:
            // Determine index of first country with this letter
//            let letter = Array("ABCDEFGHIJKLMNOPQRSTUVQXYZ".characters)[indexPath.section]
            
            switch indexPath.section {
            case 0:
                countryName = aCountries[indexPath.row] as! String
            case 1:
                countryName = bCountries[indexPath.row] as! String
            case 2:
                countryName = cCountries[indexPath.row] as! String
            case 3:
                countryName = dCountries[indexPath.row] as! String
            case 4:
                countryName = eCountries[indexPath.row] as! String
            case 5:
                countryName = fCountries[indexPath.row] as! String
            case 6:
                countryName = gCountries[indexPath.row] as! String
            case 7:
                countryName = hCountries[indexPath.row] as! String
            case 8:
                countryName = iCountries[indexPath.row] as! String
            case 9:
                countryName = jCountries[indexPath.row] as! String
            case 10:
                countryName = kCountries[indexPath.row] as! String
            case 11:
                countryName = lCountries[indexPath.row] as! String
            case 12:
                countryName = mCountries[indexPath.row] as! String
            case 13:
                countryName = nCountries[indexPath.row] as! String
            case 14:
                countryName = oCountries[indexPath.row] as! String
            case 15:
                countryName = pCountries[indexPath.row] as! String
            case 16:
                countryName = qCountries[indexPath.row] as! String
            case 17:
                countryName = rCountries[indexPath.row] as! String
            case 18:
                countryName = sCountries[indexPath.row] as! String
            case 19:
                countryName = tCountries[indexPath.row] as! String
            case 20:
                countryName = uCountries[indexPath.row] as! String
            case 21:
                countryName = vCountries[indexPath.row] as! String
            case 22:
                countryName = wCountries[indexPath.row] as! String
            case 23:
                countryName = xCountries[indexPath.row] as! String
            case 24:
                countryName = yCountries[indexPath.row] as! String
            case 25:
                countryName = zCountries[indexPath.row] as! String
            default:
                countryName = aCountries[indexPath.row] as! String
            }
            
        // For assessment level mode
        case 1:
            
            switch indexPath.section {
            case 0:
                countryName = sigCountries[indexPath.row] as! String
            case 1:
                countryName = modCountries[indexPath.row] as! String
            case 2:
                countryName = minCountries[indexPath.row] as! String
            case 3:
                countryName = noCountries[indexPath.row] as! String
            default:
                countryName = noDataCountries[indexPath.row] as! String
            }
            
        // For region mode
        default:
            
            switch indexPath.section {
            case 0:
                countryName = asiaCountries[indexPath.row] as! String
            case 1:
                countryName = europeCountries[indexPath.row] as! String
            case 2:
                countryName = latinCountries[indexPath.row] as! String
            case 3:
                countryName = middleCountries[indexPath.row] as! String
            default:
                countryName = saharanCountries[indexPath.row] as! String
            }
        }
        
        // Set cell title and icon
        cell.textLabel?.text = countryName
        let flagImage = UIImage(named: countryName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil).stringByReplacingOccurrencesOfString("ô", withString: "o", options: NSStringCompareOptions.LiteralSearch, range: nil))
        cell.imageView?.image = flagImage
        
        // Resize icon
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
        
//        if hasDataByCounty[countryName] == false {
//            cell.textLabel?.textColor = UIColor.lightGrayColor()
//            cell.detailTextLabel?.hidden = false
//            cell.userInteractionEnabled = false
//        }
        
        return cell
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        // Determine the grouping the user has selected
        switch state {
        
        // For A—Z mode
        case 0:
            return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
            
//        case 1:
//            return ["Sig", "Mod", "Min", "No", "N/A"]
//            
//        case 2:
//            return ["Asi", "Eur", "Lat", "Mid", "Afr"]
            
        // For other modes, no section index is necessary
        default:
            return Array()
        }
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
            let svc = segue.destinationViewController as! CountryController
            svc.countryName = (sender as! UITableViewCell).textLabel!.text!
        }
    }

}
