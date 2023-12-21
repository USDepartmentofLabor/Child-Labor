//
//  CountryController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/8/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class CountryController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var countryName = "Brazil"
    var multipleTerritories = false
    
    var goods = NSMutableArray()
    var exploitations = NSMutableArray()
    var url = ""
    var adjustedLabels = false

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var countryTitle: UILabel!
    @IBOutlet weak var advancementLevel: UILabel!
    @IBOutlet weak var countryMap: UIImageView!
    @IBOutlet weak var countryProfile: UILabel!
    @IBOutlet weak var collectionHeader: UILabel!
    @IBOutlet weak var goodsCollection: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    
    var goodsWithDerivedCountry: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Set view title
        self.title = countryName
        
        // Set labels
        countryTitle.text = countryName
        
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents as! String)
        
        for country in countriesXML["Countries"]["Country"].all {
            if country["Name"].element?.text == self.countryName {
                countryMap.image = UIImage(named: (country["Name"].element?.text)!.replacingOccurrences(of: "ô", with: "o", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ã", with: "a", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "é", with: "e", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "í", with: "i", options: NSString.CompareOptions.literal, range: nil) + "-map")
                
                
                url = (country["Webpage"].element?.text)!
                
                if (country["Advancement_Level"].element?.text != nil) {
                    advancementLevel.text = (country["Advancement_Level"].element?.text)!
                } else {
                    advancementLevel.text = "Not Covered in TDA Report"
                    countryMap.image = nil
                }
                
                // If there is no profile for this country
                if ((country["Description"].element?.text == nil) || (country["Description"].element?.text == nil))  {
                    // Hide the "more" button
                    moreButton.isHidden = true
                    
                    // Reduce the height of the country profile label to 0
                    countryProfile.addConstraints([NSLayoutConstraint(item: countryProfile, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)])
                    
                    // Expand header frame relative to new profile height
                    let oldHeightOfHeaderView = headerView.frame.height
                    var newRect = headerView.frame
                    newRect.size.height = oldHeightOfHeaderView - 96
                    headerView.frame = newRect
                    self.tableView.tableHeaderView = headerView
                } else {
                    countryProfile.text = country["Description"].element?.text
                }
                
                // If there are no goods for this country
                if country["Goods"]["Good"].all.count == 0 {
                    let oldCollectionHeaderHeight = collectionHeader.frame.height
                    let oldCollectionViewHeight = goodsCollection.frame.height
                    
                    // Hide the goods collection by adjusting its height constraint
                    collectionHeader.addConstraints([NSLayoutConstraint(item: collectionHeader, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)])
                    goodsCollection.addConstraints([NSLayoutConstraint(item: goodsCollection, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0)])

                    // Reduce the height of the header view by the height of the collection
                    let oldHeightOfHeaderView = headerView.frame.height
                    var newRect = headerView.frame
                    newRect.size.height = oldHeightOfHeaderView - (oldCollectionHeaderHeight + oldCollectionViewHeight)
                    headerView.frame = newRect
                    self.tableView.tableHeaderView = headerView
                } else {
                    for good in country["Goods"]["Good"].all {
                        let goodName = good["Good_Name"].element?.text
                        
                        let childLaborStatusForGood = good["Child_Labor"].element?.text
                        let forcedLaborStatusForGood = good["Forced_Labor"].element?.text
                        let forcedChildLaborStatusForGood = good["Forced_Child_Labor"].element?.text
                        let derivedLaborStatus = good["Derived_Labor_Exploitation"].element?.text
                        
                        goods.add(goodName!)
                        
                        // Add the exploitation type to an array
                        if childLaborStatusForGood == "Yes" && forcedLaborStatusForGood == "No" {
                            exploitations.add(0)
                        }
                        else if childLaborStatusForGood == "No" && forcedLaborStatusForGood == "Yes" && forcedChildLaborStatusForGood == "Yes" {
                            exploitations.add(3)
                        }
                        else if childLaborStatusForGood == "No" && forcedLaborStatusForGood == "Yes" {
                            exploitations.add(1)
                        } else if childLaborStatusForGood == "Yes" && forcedLaborStatusForGood == "Yes" && forcedChildLaborStatusForGood == "No" {
                            exploitations.add(2)
                        } else if derivedLaborStatus == "Yes" {
                            exploitations.add(4)
                            let derivedCountry = good["Derived_Country"].element?.text ?? "no"
                            goodsWithDerivedCountry.updateValue(derivedCountry, forKey: goodName ?? "")
                        } else {
                            exploitations.add(3)
                        }
                    }
                }
                
                multipleTerritories = country["Multiple_Territories"].element?.text == "Yes"
                
                break;
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure the ugly table cell selection is cleared when returning to this view
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: tableIndex, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.countryProfile, metaData: self.countryName)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (!adjustedLabels) {
            // Expand header frame relative to new label heights
            var newRect = headerView.frame
            newRect.size.height += getLabelSizeIncrease(countryTitle) + getLabelSizeIncrease(advancementLevel)
            headerView.frame = newRect
            self.tableView.tableHeaderView = headerView
            adjustedLabels = true
        }
    }
    
    func getLabelSizeIncrease(_ label: UILabel) -> CGFloat {
        let old = label.frame.height;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.sizeToFit()
        label.layoutIfNeeded()
        return label.frame.height - old
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If you want the grouped table view in iOS 9 to have a white background, you need to override it here
        tableView.backgroundColor = UIColor.white

        collectionHeader.text = String(goods.count) + " GOOD" + (goods.count == 1 ? "" : "S") + " PRODUCED WITH EXPLOITATIVE LABOR"
        
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Good", for: indexPath) as UICollectionViewCell
        
        //
        let goodButton : UIButton? = cell.viewWithTag(201) as? UIButton
        let goodLabel : UILabel? = cell.viewWithTag(301) as? UILabel
        
        //
        let cl : UIView? = cell.viewWithTag(101)
        let fl : UIView? = cell.viewWithTag(102)
        let dl : UIView? = cell.viewWithTag(103)
        
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
        goodButton!.setImage(UIImage(named:"icons_" + (goodName as AnyObject).replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: " ", with: "_"))?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        
        goodButton?.accessibilityLabel = goodName as? String
        if #available(iOS 13.0, *) {
            goodLabel?.textColor = UIColor.black
        } else {
            // Fallback on earlier versions
        }
        //
        switch exploitations[indexPath.row] as! Int {
        case 0:
            cl?.isHidden = false
            fl?.isHidden = true
            dl?.isHidden = true
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
        case 1:
            cl?.isHidden = true
            fl?.isHidden = false
            dl?.isHidden = true
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
        case 2:
            cl?.isHidden = false
            fl?.isHidden = false
            dl?.isHidden = true
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
        case 4:
            cl?.isHidden = true
            fl?.isHidden = true
            dl?.isHidden = false
            let flagImageView : UIImageView? = dl!.viewWithTag(405) as? UIImageView
            flagImageView?.isHidden = true
            clLabel?.accessibilityLabel = "Derived Labor"
            if let derivedCountry = goodsWithDerivedCountry[goodName as! String] {
                let countryName = derivedCountry.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ô", with: "o", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ã", with: "a", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "é", with: "e", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "í", with: "i", options: NSString.CompareOptions.literal, range: nil)
                if let flagImage = UIImage(named: countryName) {
                    flagImageView?.isHidden = false
                    flagImageView?.image = flagImage
                    flagImageView?.layer.borderColor = UIColor.gray.cgColor
                    flagImageView?.layer.borderWidth = 1
                }
            }
        default:
            cl?.isHidden = false
            fl?.isHidden = false
            dl?.isHidden = true
            clImage?.image = UIImage(named: "hand-black")
            clLabel?.textColor = UIColor.black
            clLabel?.text = "FCL"
            clLabel?.accessibilityLabel = "Forced Child Labor"
        }
//        if #available(iOS 13.0, *) {
//            clLabel?.textColor = .label
//        } else {
//            // Fallback on earlier versions
//        }
        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If this is a TVPRA-only country, or one of British Indian Ocean Territories, Heard and McDonald Islands, or Pitcairn Island, it has no indicator or PDF buttons, so return 0 for both sections
        if ["China", "Iran", "Malaysia", "Turkey (Türkiye)", "North Korea", "Taiwan", "Tajikistan", "Turkmenistan", "Vietnam", "British Indian Ocean Territories", "Heard and McDonald Islands", "Pitcairn Islands", "Russia", "Sudan", "Venezuela"].contains(self.countryName) {
            return 0
            
        // Otherwise
        } else {
            switch section {
            
            // Indicator buttons
            case 0:
                return 6
            
            // Full Report PDF button
            case 1:
                return 2
                
            default:
                return 0
            }
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")

        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        if (indexPath.section == 0) {
            switch indexPath.row {
            case 0:
                cell?.textLabel?.text = "Suggested Actions"
            case 1:
                cell?.textLabel?.text = "Statistics"
            case 2:
                cell?.textLabel?.text = "International Conventions"
            case 3:
                cell?.textLabel?.text = "Legal Standards"
            case 4:
                cell?.textLabel?.text = "Enforcement"
            case 5:
                cell?.textLabel?.text = "Coordinating Mechanisms"
                
            default:
                cell?.textLabel?.text = ""
                
            
            }
        }
        if (indexPath.section == 1) {
        switch indexPath.row {
//               case 0:
//                   cell?.textLabel?.text = "Report PDF"
               case 0:
                   cell?.textLabel?.text = "Country Webpage"
                //added new cell ILAB Projects
               case 1:
                   cell?.textLabel?.text = "ILAB Projects"
                   
               default:
                   cell?.textLabel?.text = ""
                               
            }
        }
        let chevron = UIImage(named: "arrow.png")
        cell?.accessoryType = .disclosureIndicator
        cell?.accessoryView = UIImageView(image: chevron)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0){
            if (indexPath.row == 0) {
                Analytics.trackAction(.countryProfile, category: .suggestedActions, metaData: self.countryName)
             performSegue(withIdentifier: "presentSuggestedActions", sender: self)
            }
        
        if (indexPath.row == 1) {
            if (countryName=="Somalia") {
                //performSegue(withIdentifier: "presentStats", sender: self)
                Analytics.trackAction(.countryProfile, category: .statistics, metaData: self.countryName)
                performSegue(withIdentifier: "presentSomalia", sender: self)

            }

            else
            if (countryName=="Pakistan") {
                Analytics.trackAction(.countryProfile, category: .statistics, metaData: self.countryName)
                performSegue(withIdentifier: "presentStats", sender: self)
                
            }
            
            else if (countryName=="Tanzania") {
                Analytics.trackAction(.countryProfile, category: .statistics, metaData: self.countryName)
                performSegue(withIdentifier: "presentStats", sender: self)
                
            }
                
            else {
                Analytics.trackAction(.countryProfile, category: .statistics, metaData: self.countryName)
                performSegue(withIdentifier: "presentStats", sender: self)
            }
        }
        if (indexPath.row == 2) {
            Analytics.trackAction(.countryProfile, category: .internationalConventions, metaData: self.countryName)
         performSegue(withIdentifier: "presentConventions", sender: self)
        }
        if (indexPath.row == 3) {
            if multipleTerritories {
                
                Analytics.trackAction(.countryProfile, category: .legalStandards, metaData: self.countryName)
                performSegue(withIdentifier: "presentLegalStandardsMultiWrapper", sender: self)
                
            }
            else {
                Analytics.trackAction(.countryProfile, category: .legalStandards, metaData: self.countryName)
                performSegue(withIdentifier: "presentLegalStandardsWrapper", sender: self)
            }
        }
        
        if (indexPath.row == 4) {
            if multipleTerritories {
                Analytics.trackAction(.countryProfile, category: .enforcement, metaData: self.countryName)
                performSegue(withIdentifier: "presentEnforcementMulti", sender: self)
            }
            else {
                Analytics.trackAction(.countryProfile, category: .enforcement, metaData: self.countryName)
                performSegue(withIdentifier: "presentEnforcement", sender: self)
            }
        }
        if (indexPath.row == 5) {
            Analytics.trackAction(.countryProfile, category: .coordinationMechanisms, metaData: self.countryName)
         performSegue(withIdentifier: "presentCoordination", sender: self)
        }
            
        }
        
        if (indexPath.section == 1)
        {
//            if (indexPath.row == 0) {
//                    performSegue(withIdentifier: "presentFullReportDocument", sender: self)
//                   }
            if (indexPath.row == 0) {
                
                if(self.countryName == "Côte d\'Ivoire")
                {
                    url = "https://www.dol.gov/agencies/ilab/resources/reports/child-labor/c%C3%B4te-dIvoire"
                }
                
                Analytics.trackAction(.countryProfile, category: .countryWebPage, metaData: self.countryName)
                 UIApplication.shared.openURL(URL(string: url)!)
                
                
            }
            if (indexPath.row == 1) {
                Analytics.trackAction(.countryProfile, category: .iLabProjects, metaData: self.countryName)
                    performSegue(withIdentifier: "presentILABProjects", sender: self)
                   }
            
        }
        
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: tableIndex, animated: false)
        }
        
        
    }
    
    @IBAction func showWholeProfile(_ sender: AnyObject) {
        let oldHeightOfCountryProfile = countryProfile.frame.height
        let oldHeightOfHeaderView = headerView.frame.height

        // Expand the label with the profile in it
        countryProfile.numberOfLines = 0
        countryProfile.lineBreakMode = NSLineBreakMode.byWordWrapping
        countryProfile.sizeToFit()
        
        // Hide the "more" button
        (sender as! UIView).isHidden = true
        
        // Expand header frame relative to new profile height
        var newRect = headerView.frame
        newRect.size.height = oldHeightOfHeaderView - oldHeightOfCountryProfile + countryProfile.frame.height
        headerView.frame = newRect
        self.tableView.tableHeaderView = headerView
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goodSelectedFromCountryProfile" {
            let svc = segue.destination as! GoodController
            svc.goodName = ((sender as! UIButton).superview?.viewWithTag(301) as! UILabel).text!
            Analytics.trackAction(.countryProfile, category: .goodSelected, metaData: self.countryName + ":" + svc.goodName)
        } else if segue.identifier == "presentFullReportDocument" {
            let svc = segue.destination as! FullReportViewController
            svc.countryName = self.countryName.replacingOccurrences(of: "ô", with: "o", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ã", with: "a", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "é", with: "e", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "í", with: "i", options: NSString.CompareOptions.literal, range: nil)
        } else if segue.identifier == "presentSuggestedActions" {
            let svc = segue.destination as! SuggestedActionsTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentStats" {
            let svc = segue.destination as! StatisticsTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentSomalia" {
            let svc = segue.destination as! SomaliaTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentConventions" {
            let svc = segue.destination as! ConventionsTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentLegalStandardsMultiWrapper" {
            let svc = segue.destination as! LegalStandardsMultiWrapperViewController
            svc.setCountryName(cn: self.countryName)
            
        } else if segue.identifier == "presentLegalStandardsWrapper" {
            let svc = segue.destination as! LegalStandardsWrapperViewController
            svc.setCountryName(cn: self.countryName)
        } else if segue.identifier == "presentEnforcement" {
            let svc = segue.destination as! EnforceTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentEnforcementMulti" {
            let svc = segue.destination as! EnforcementMultiTableViewController
            svc.countryName = self.countryName
        } else if segue.identifier == "presentCoordination" {
            let svc = segue.destination as! CoordTableViewController
            svc.countryName = self.countryName
        }else if segue.identifier == "presentILABProjects" {
            let svc = segue.destination as! ILABProjectsController
            svc.countryName = self.countryName
        }
        
       
       
}
}
