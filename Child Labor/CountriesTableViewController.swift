//
//  CountriesController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 3/8/15.
//  U.S. Government Work https://www.usa.gov/government-works
//

import UIKit

class CountriesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var state = 0
    
    var hasDataByCounty: [String: Bool] = [:]
    
    @IBOutlet weak var searchFilterview: UIView!
    @IBOutlet weak var searchBarFilter: UISearchBar!
    
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
    
    var aCountriesAll = NSMutableArray()
    var bCountriesAll = NSMutableArray()
    var cCountriesAll = NSMutableArray()
    var dCountriesAll = NSMutableArray()
    var eCountriesAll = NSMutableArray()
    var fCountriesAll = NSMutableArray()
    var gCountriesAll = NSMutableArray()
    var hCountriesAll = NSMutableArray()
    var iCountriesAll = NSMutableArray()
    var jCountriesAll = NSMutableArray()
    var kCountriesAll = NSMutableArray()
    var lCountriesAll = NSMutableArray()
    var mCountriesAll = NSMutableArray()
    var nCountriesAll = NSMutableArray()
    var oCountriesAll = NSMutableArray()
    var pCountriesAll = NSMutableArray()
    var qCountriesAll = NSMutableArray()
    var rCountriesAll = NSMutableArray()
    var sCountriesAll = NSMutableArray()
    var tCountriesAll = NSMutableArray()
    var uCountriesAll = NSMutableArray()
    var vCountriesAll = NSMutableArray()
    var wCountriesAll = NSMutableArray()
    var xCountriesAll = NSMutableArray()
    var yCountriesAll = NSMutableArray()
    var zCountriesAll = NSMutableArray()
    
    
    // Lists for countries in each advancement level section
    var sigCountries = NSMutableArray()
    var modCountries = NSMutableArray()
    var minCountries = NSMutableArray()
    var noCountries = NSMutableArray()
    var noAssessmentCountries = NSMutableArray()
    var noDataCountries = NSMutableArray()
    
    var sigCountriesAll = NSMutableArray()
    var modCountriesAll = NSMutableArray()
    var minCountriesAll = NSMutableArray()
    var noCountriesAll = NSMutableArray()
    var noAssessmentCountriesAll = NSMutableArray()
    var noDataCountriesAll = NSMutableArray()
    
    // Lists for countries in each region section
    var asiaCountries = NSMutableArray()
    var europeCountries = NSMutableArray()
    var latinCountries = NSMutableArray()
    var middleCountries = NSMutableArray()
    var saharanCountries = NSMutableArray()
    
    var asiaCountriesAll = NSMutableArray()
    var europeCountriesAll = NSMutableArray()
    var latinCountriesAll = NSMutableArray()
    var middleCountriesAll = NSMutableArray()
    var saharanCountriesAll = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Countries List Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        // Give section index a clear background
        self.tableView.sectionIndexBackgroundColor = UIColor.clear
        
        self.searchBarFilter.delegate = self
        
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        // For each country
        for country in countriesXML["Countries"]["Country"] {
            let countryName = country["Name"].element?.text
            
            // Create lists of countries in each letter section
            if Array(countryName!.characters)[0] == "A" {
                aCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "B" {
                bCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "C" {
                cCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "D" {
                dCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "E" {
                eCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "F" {
                fCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "G" {
                gCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "H" {
                hCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "I" {
                iCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "J" {
                jCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "K" {
                kCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "L" {
                lCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "M" {
                mCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "N" {
                nCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "O" {
                oCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "P" {
                pCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "Q" {
                qCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "R" {
                rCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "S" {
                sCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "T" {
                tCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "U" {
                uCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "V" {
                vCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "W" {
                wCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "X" {
                xCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "Y" {
                yCountries.add(countryName!)
            } else if Array(countryName!.characters)[0] == "Z" {
                zCountries.add(countryName!)
            }

            // Create lists of countries in each advancement level section
            if ((country["Advancement_Level"].element?.text?.hasPrefix("Significant")) == true) {
                sigCountries.add(countryName!)
            } else if country["Advancement_Level"].element?.text?.hasPrefix("Moderate") == true {
                modCountries.add(countryName!)
            } else if country["Advancement_Level"].element?.text?.hasPrefix("Minimal") == true{
                minCountries.add(countryName!)
            } else if country["Advancement_Level"].element?.text?.hasPrefix("No Advancement") == true {
                noCountries.add(countryName!)
            } else if country["Advancement_Level"].element?.text?.hasPrefix("No Assessment") == true {
                noAssessmentCountries.add(countryName!)
            } else {
                noDataCountries.add(countryName!)
            }

            // Create lists of countries in each region section
            if country["Region"].element?.text == "Asia & the Pacific" {
                asiaCountries.add(countryName!)
            } else if country["Region"].element?.text == "Europe & Eurasia" {
                europeCountries.add(countryName!)
            } else if country["Region"].element?.text == "Latin America & the Caribbean" {
                latinCountries.add(countryName!)
            } else if country["Region"].element?.text == "Middle East & North Africa" {
                middleCountries.add(countryName!)
            } else if country["Region"].element?.text == "Sub-Saharan Africa" {
                saharanCountries.add(countryName!)
            }
            
            // Record whether each country has a profile in an associative array
            if (country["Description"].element?.text == nil && country["Goods"]["Good"].all.count == 0) {
                hasDataByCounty[countryName!] = false
            } else {
                hasDataByCounty[countryName!] = true
            }
        }
        
        // Save all values for each section so that we can filter later
        aCountriesAll = aCountries
        bCountriesAll = bCountries
        cCountriesAll = cCountries
        dCountriesAll = dCountries
        eCountriesAll = eCountries
        fCountriesAll = fCountries
        gCountriesAll = gCountries
        hCountriesAll = hCountries
        iCountriesAll = iCountries
        jCountriesAll = jCountries
        kCountriesAll = kCountries
        lCountriesAll = lCountries
        mCountriesAll = mCountries
        nCountriesAll = nCountries
        oCountriesAll = oCountries
        pCountriesAll = pCountries
        qCountriesAll = qCountries
        rCountriesAll = rCountries
        sCountriesAll = sCountries
        tCountriesAll = tCountries
        uCountriesAll = uCountries
        vCountriesAll = vCountries
        wCountriesAll = wCountries
        xCountriesAll = xCountries
        yCountriesAll = yCountries
        zCountriesAll = zCountries
        
        sigCountriesAll = sigCountries
        modCountriesAll = modCountries
        minCountriesAll = minCountries
        noCountriesAll = noCountries
        noAssessmentCountriesAll = noAssessmentCountries
        noDataCountriesAll = noDataCountries
        
        asiaCountriesAll = asiaCountries
        europeCountriesAll = europeCountries
        latinCountriesAll = latinCountries
        middleCountriesAll = middleCountries
        saharanCountriesAll = saharanCountries
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure the ugly table cell selection is cleared when returning to this view
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: tableIndex, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        
        // Determine which grouping the user has selected
        switch state {
            
        // For A–Z mode
        case 0:
            return 26
        
        // For assessment level mode
        case 1:
            return 6
            
        // For region mode
        case 2:
            return 5
            
        // Default
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        // If empty section don't return a header
        if getSectionData(section).count == 0 {
            return nil
        }
        
        // Determine which grouping the user has selected
        switch state {
            
        // For A–Z mode
        case 0:
            // Set section title for each letter of the alphabet
            return String(Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)[section])
        
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
            case 4:
                return "No Assessment"
            default:
                return "Not Covered in TDA Report"
            }
        
        // For region mode
        case 2:
            switch section {
            case 0:
                return "Asia & the Pacific"
            case 1:
                return "Europe & Eurasia"
            case 2:
                return "Latin America & the Caribbean"
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            case 4:
                return noAssessmentCountries.count
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
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
            case 4:
                countryName = noAssessmentCountries[indexPath.row] as! String
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
        let flagImage = UIImage(named: countryName.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ô", with: "o", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ã", with: "a", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "é", with: "e", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "í", with: "i", options: NSString.CompareOptions.literal, range: nil))
        cell.imageView?.image = flagImage
        
        // Resize icon
        if (flagImage != nil) {
            let adjustedWidth = flagImage!.size.width * 44 / flagImage!.size.height
            
            let size = CGSize(width: 42, height: 44)
            if adjustedWidth >= 42 {
                let rect = CGRect(x: 0, y: ((44 - (flagImage!.size.height * 42 / flagImage!.size.width)) / 2), width: 42, height: flagImage!.size.height * 42 / flagImage!.size.width)
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                cell.imageView?.image?.draw(in: rect)
                cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext();
            } else {
                let rect = CGRect(x: 0, y: 0, width: adjustedWidth, height: size.height)
                UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
                cell.imageView?.image?.draw(in: rect)
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
    
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        
//        // Determine the grouping the user has selected
//        switch state {
//        
//        // For A—Z mode
//        case 0:
//            return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
//            
////        case 1:
////            return ["Sig", "Mod", "Min", "No", "N/A"]
////            
////        case 2:
////            return ["Asi", "Eur", "Lat", "Mid", "Afr"]
//            
//        // For other modes, no section index is necessary
//        default:
//            return Array()
//        }
//    }
    
    @IBAction func groupChanged(_ sender: UISegmentedControl) {
        state = sender.selectedSegmentIndex
        
        // self.searchFilterview.hidden = state != 0
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterResults()
    }
    
    func filterResults() {
        let query = self.searchBarFilter.text
        
        aCountries = filterSection(aCountriesAll, query: query!)
        bCountries = filterSection(bCountriesAll, query: query!)
        cCountries = filterSection(cCountriesAll, query: query!)
        dCountries = filterSection(dCountriesAll, query: query!)
        eCountries = filterSection(eCountriesAll, query: query!)
        fCountries = filterSection(fCountriesAll, query: query!)
        gCountries = filterSection(gCountriesAll, query: query!)
        hCountries = filterSection(hCountriesAll, query: query!)
        iCountries = filterSection(iCountriesAll, query: query!)
        jCountries = filterSection(jCountriesAll, query: query!)
        kCountries = filterSection(kCountriesAll, query: query!)
        lCountries = filterSection(lCountriesAll, query: query!)
        mCountries = filterSection(mCountriesAll, query: query!)
        nCountries = filterSection(nCountriesAll, query: query!)
        oCountries = filterSection(oCountriesAll, query: query!)
        pCountries = filterSection(pCountriesAll, query: query!)
        qCountries = filterSection(qCountriesAll, query: query!)
        rCountries = filterSection(rCountriesAll, query: query!)
        sCountries = filterSection(sCountriesAll, query: query!)
        tCountries = filterSection(tCountriesAll, query: query!)
        uCountries = filterSection(uCountriesAll, query: query!)
        vCountries = filterSection(vCountriesAll, query: query!)
        wCountries = filterSection(wCountriesAll, query: query!)
        xCountries = filterSection(xCountriesAll, query: query!)
        yCountries = filterSection(yCountriesAll, query: query!)
        zCountries = filterSection(zCountriesAll, query: query!)
        
        sigCountries = filterSection(sigCountriesAll, query: query!)
        modCountries = filterSection(modCountriesAll, query: query!)
        minCountries = filterSection(minCountriesAll, query: query!)
        noCountries = filterSection(noCountriesAll, query: query!)
        noAssessmentCountries = filterSection(noAssessmentCountriesAll, query: query!)
        noDataCountries = filterSection(noDataCountriesAll, query: query!)
        
        asiaCountries = filterSection(asiaCountriesAll, query: query!)
        europeCountries = filterSection(europeCountriesAll, query: query!)
        latinCountries = filterSection(latinCountriesAll, query: query!)
        middleCountries = filterSection(middleCountriesAll, query: query!)
        saharanCountries = filterSection(saharanCountriesAll, query: query!)
        
        tableView.reloadData();
    }
    
    func filterSection(_ array: NSMutableArray, query: String) -> NSMutableArray {
        if query.isEmpty {
            return array
        }
        
        let tempArray = array.filter() {
            let countryName = ($0 as! String).replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ô", with: "o", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ã", with: "a", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "é", with: "e", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "í", with: "i", options: NSString.CompareOptions.literal, range: nil)
            return countryName.lowercased().hasPrefix(query.lowercased())
        }
        return NSMutableArray(array: tempArray)
    }
    
    func getSectionData(_ section: Int) -> NSMutableArray {
        
        // Determine the grouping the user has selected
        switch state {
            
        // For A–Z mode
        case 0:
            
            switch section {
            case 0:
                return aCountries
            case 1:
                return bCountries
            case 2:
                return cCountries
            case 3:
                return dCountries
            case 4:
                return eCountries
            case 5:
                return fCountries
            case 6:
                return gCountries
            case 7:
                return hCountries
            case 8:
                return iCountries
            case 9:
                return jCountries
            case 10:
                return kCountries
            case 11:
                return lCountries
            case 12:
                return mCountries
            case 13:
                return nCountries
            case 14:
                return oCountries
            case 15:
                return pCountries
            case 16:
                return qCountries
            case 17:
                return rCountries
            case 18:
                return sCountries
            case 19:
                return tCountries
            case 20:
                return uCountries
            case 21:
                return vCountries
            case 22:
                return wCountries
            case 23:
                return xCountries
            case 24:
                return yCountries
            case 25:
                return zCountries
            default:
                return aCountries
            }
            
        // For assessment level mode
        case 1:
            switch section {
            case 0:
                return sigCountries
            case 1:
                return modCountries
            case 2:
                return minCountries
            case 3:
                return noCountries
            case 4:
                return noAssessmentCountries
            default:
                return noDataCountries
            }
            
        // For region mode
        default:
            switch section {
            case 0:
                return asiaCountries
            case 1:
                return europeCountries
            case 2:
                return latinCountries
            case 3:
                return middleCountries
            default:
                return saharanCountries
            }
        }
    
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (getSectionData(section).count == 0) {
            return CGFloat.leastNormalMagnitude
        }
        return UITableViewAutomaticDimension;
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.searchBarFilter.text = nil
        filterResults()
        
        if segue.identifier == "countrySelectedFromCountriesTable" {
            let svc = segue.destination as! CountryController
            svc.countryName = (sender as! UITableViewCell).textLabel!.text!
        }
    }

}
