//
//  ProductsController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 3/8/15.
//  U.S. Government Work https://www.usa.gov/government-works
//

import UIKit

class GoodsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var state = 0
    
    @IBOutlet weak var goodsCount: UILabel!
    var goodsXML = SWXMLHash.parse("<xml></xml>")
    
    
    
    
    
    var allGoods = NSMutableArray()
    var numCountriesByGood: [String: Int] = [:]
    
    // Lists for countries in each advancement level section
    var manGoods = NSMutableArray()
    var agGoods = NSMutableArray()
    var minGoods = NSMutableArray()
    var othGoods = NSMutableArray()
    
    var allGoodsAll = NSMutableArray()
    var manGoodsAll = NSMutableArray()
    var agGoodsAll = NSMutableArray()
    var minGoodsAll = NSMutableArray()
    var othGoodsAll = NSMutableArray()
    
    @IBOutlet weak var searchBarFilter: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Goods List Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        // Populate the list
        let urlPath = Bundle.main.path(forResource: "goods_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        goodsXML = SWXMLHash.parse(contents! as String)
        
        // Create lists of countries in each sector section
        for good in goodsXML["Goods"]["Good"].all {
            if good["Countries"]["Country"].all.count > 0 {
                allGoods.add((good["Good_Name"].element?.text)!)
                numCountriesByGood.updateValue(good["Countries"]["Country"].all.count, forKey: (good["Good_Name"].element?.text)!)
                
                if good["Good_Sector"].element?.text == "Agriculture" {
                    agGoods.add((good["Good_Name"].element?.text)!)
                } else if good["Good_Sector"].element?.text == "Manufacturing" {
                    manGoods.add((good["Good_Name"].element?.text)!)
                } else if good["Good_Sector"].element?.text == "Mining" {
                    minGoods.add((good["Good_Name"].element?.text)!)
                } else {
                    othGoods.add((good["Good_Name"].element?.text)!)
                }
            }
        }
        
        // Save all values for each section so that we can filter later
        allGoodsAll = allGoods
        agGoodsAll = agGoods
        manGoodsAll = manGoods
        minGoodsAll = minGoods
        othGoodsAll = othGoods
        
        self.searchBarFilter.delegate = self
        
        
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
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        switch state {
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
                print("default")
            }
        default:
            return "All Goods"
        }
        
        return "N/A"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.

        switch state {
        case 1:
            switch section {
            case 0:
                return agGoods.count
            case 1:
                return manGoods.count
            case 2:
                return minGoods.count
            default:
                return othGoods.count
            }
            
        default:
            return allGoods.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        var goodName = "Cotton"
        
        // Determine the grouping the user has selected
        switch state {
            
        //
        case 1:
            
            switch indexPath.section {
            case 0:
                goodName = agGoods[indexPath.row] as! String
            case 1:
                goodName = manGoods[indexPath.row] as! String
            case 2:
                goodName = minGoods[indexPath.row] as! String
            default:
                goodName = othGoods[indexPath.row] as! String
            }
            
            // Default
        default:
            goodName = allGoods[indexPath.row] as! String
        }
        
        cell.textLabel?.text = goodName
        cell.detailTextLabel?.text = String(numCountriesByGood[goodName]!)


        cell.imageView?.image = UIImage(named: "icons_" + goodName.replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: " ", with: "_") + "-33")
        
        if #available(iOS 13.0, *) {
//            cell.imageView?.backgroundColor = .systemOrange
            cell.imageView?.backgroundColor = .white
            cell.imageView?.alpha = 1
        } else {
            // Fallback on earlier versions
        }
        
        

        if #available(iOS 13.0, *) {
            cell.textLabel?.textColor = .label
//            cell.imageView?.tintColor = .systemYellow
        } else {
            // Fallback on earlier versions
        }
        return cell
    }

    @IBAction func groupChanged(_ sender: UISegmentedControl) {
        state = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    
    func getGoodsCount()->Int{
        var goodsCount = 0
        for index in 0...self.tableView.numberOfSections-1{
            goodsCount += self.tableView.numberOfRows(inSection: index)
        }
        return goodsCount
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterResults()
    }
    
    func filterResults() {
        let query = self.searchBarFilter.text
        
        allGoods = filterSection(allGoodsAll, query: query!)
        manGoods = filterSection(manGoodsAll, query: query!)
        minGoods = filterSection(minGoodsAll, query: query!)
        agGoods = filterSection(agGoodsAll, query: query!)
        othGoods = filterSection(othGoodsAll, query: query!)
        
        tableView.reloadData();
        
        if(getGoodsCount() == 1)
        {
            goodsCount.text = "1 result found for search " + searchBarFilter.text!
        }
        if(getGoodsCount() == 156)
        {
            goodsCount.text = ""
        }
        else{
            if #available(iOS 12.0, *) {
                if (self.traitCollection.userInterfaceStyle == .dark) {
                   
                    if(getGoodsCount() == 156 && searchBarFilter.text! == "")
                    {
                        goodsCount.text = ""
                    } else {
                        goodsCount.textColor = UIColor.black
                        goodsCount.text = String(getGoodsCount()) + " results found for " + searchBarFilter.text!
                    }
                } else {
                     goodsCount.text = String(getGoodsCount()) + " results found for " + searchBarFilter.text!
                }
            } else {
                    if(getGoodsCount() == 1)
                    {
                        goodsCount.text = String(getGoodsCount()) + " results found for " + searchBarFilter.text!
                    }
                    if(getGoodsCount() == 156)
                    {
                        goodsCount.text = ""
                }
            }
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, goodsCount.text)
        }
    }
    
    func filterSection(_ array: NSMutableArray, query: String) -> NSMutableArray {
        if query.isEmpty {
            return array
        }
        
        let tempArray = array.filter() {
            let goodName = ($0 as! String)
//            return goodName.lowercased().range(of: query.lowercased()) != nil
            return goodName.starts(with: query)

        }
        return NSMutableArray(array: tempArray)
    }
    
    
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
//        // Determine the grouping the user has selected
//        switch state {
//            
//        // For A—Z mode
//        case 0:
//            return Array()
//            
//        case 1:
//            return ["Man", "Ag", "Min", "Oth"]
//            
//            // For other modes, no section index is necessary
//        default:
//            return Array()
//        }
//    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.searchBarFilter.text = nil
        filterResults()
        if segue.identifier == "goodSelectedFromGoodsTable" {
            let svc = segue.destination as! GoodController
            svc.goodName = (sender as! UITableViewCell).textLabel!.text!
        }
    }

}
