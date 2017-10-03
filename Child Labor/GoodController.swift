//
//  GoodController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 7/8/15.
//  Copyright © 2015 E J Kalafarski. All rights reserved.
//

import UIKit

class GoodController: UITableViewController {
    
    var goodName = "Cotton"
    
    var countries = NSMutableArray()
    var exploitations = NSMutableArray()
    
    @IBOutlet weak var goodTitle: UILabel!
    @IBOutlet weak var goodImage: UIImageView!
    @IBOutlet weak var sector: UILabel!
    
    var state = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Good Profile Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        // Do any additional setup after loading the view.
        self.title = goodName
        goodTitle.text = goodName
        goodImage.image = UIImage(named:"icons_" + goodName.replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: " ", with: "_"))!
        
        let urlPathGoods = Bundle.main.path(forResource: "goods_2016", ofType: "xml")
        var contentsGoods: NSString?
        do {
            contentsGoods = try NSString(contentsOfFile: urlPathGoods!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contentsGoods = nil
        }
        let goodsXML = SWXMLHash.parse(contentsGoods as! String)
        
        for good in goodsXML["Goods"]["Good"].all {
            if good["Good_Name"].element?.text == self.goodName {
                sector.text = good["Good_Sector"].element?.text
                
                for country in good["Countries"]["Country"].all {
                    countries.add((country["Country_Name"].element?.text)!)
                    
                    // Add the exploitation type to an array
                    if country["Child_Labor"].element?.text == "Yes" && country["Forced_Labor"].element?.text == "No" {
                        exploitations.add(0)
                    } else if country["Child_Labor"].element?.text == "No" && country["Forced_Labor"].element?.text == "Yes" {
                        exploitations.add(1)
                    } else if country["Child_Labor"].element?.text == "Yes" && country["Forced_Labor"].element?.text == "Yes" && country["Forced_Child_Labor"].element?.text == "No" {
                        exploitations.add(2)
                    } else {
                        exploitations.add(3)
                    }
                }
                
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var typeOfLabor = ""
        var numCountriesWithThisType = 0
        switch state {
        case 0:
            typeOfLabor = "Exploitive"
            
            numCountriesWithThisType = countries.count
        case 1:
            typeOfLabor = "Child"

            for i in 0...countries.count - 1 {
                if exploitations[i] as! Int == 0 || exploitations[i] as! Int == 2 || exploitations[i] as! Int == 3 {
                    numCountriesWithThisType += 1
                }
            }
        case 2:
            typeOfLabor = "Forced"

            for i in 0...countries.count - 1 {
                if exploitations[i] as! Int == 1 || exploitations[i] as! Int == 2 || exploitations[i] as! Int == 3 {
                    numCountriesWithThisType += 1
                }
            }
        default:
            typeOfLabor = "Forced Child"

            for i in 0...countries.count - 1 {
                if exploitations[i] as! Int == 3 {
                    numCountriesWithThisType += 1
                }
            }
}
        
        return "Produced With \(typeOfLabor) Labor in \(numCountriesWithThisType) Countr" + (numCountriesWithThisType == 1 ? "y" : "ies")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If you want the grouped table view in iOS 9 to have a white background, you need to override it here
        tableView.backgroundColor = UIColor.white
        
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        
        //
        let countryName = (countries.object(at: indexPath.row) as! NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        //
        let cl : UIView? = cell.viewWithTag(101)
        let fl : UIView? = cell.viewWithTag(102)
        let titleLabel : UILabel? = cell.viewWithTag(301) as? UILabel
        
        let clImage : UIImageView? = cl!.viewWithTag(201) as? UIImageView
        let clLabel : UILabel? = cl!.viewWithTag(202) as? UILabel
        
        titleLabel?.text = countryName
        let flagImage = UIImage(named: countryName.replacingOccurrences(of: " ", with: "_", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "ô", with: "o", options: NSString.CompareOptions.literal, range: nil))
        cell.imageView?.image = flagImage
        
        // Resize flag icons to a constant width, centered vertically
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
        
        cell.backgroundColor = UIColor.white
        titleLabel?.textColor = UIColor.black
        cell.isUserInteractionEnabled = true
        
        //
        switch exploitations[indexPath.row] as! Int {
        case 0:
            cl?.isHidden = false
            fl?.isHidden = true
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
            
            if state == 2 || state == 3 {
                cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                titleLabel?.textColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
                cell.isUserInteractionEnabled = false
                cell.accessibilityElementsHidden = true;
            }
        case 1:
            cl?.isHidden = true
            fl?.isHidden = false
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
            
            if state == 1 || state == 3 {
                cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                titleLabel?.textColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
                cell.isUserInteractionEnabled = false
                cell.accessibilityElementsHidden = true;
            }
        case 2:
            cl?.isHidden = false
            fl?.isHidden = false
            clImage?.image = UIImage(named: "hand")
            clLabel?.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
            clLabel?.text = "CL"
            clLabel?.accessibilityLabel = "Child Labor"
            
            if state == 3 {
                cell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                titleLabel?.textColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
                cell.isUserInteractionEnabled = false
                cell.accessibilityElementsHidden = true;
            }
        default:
            cl?.isHidden = false
            fl?.isHidden = false
            clImage?.image = UIImage(named: "hand-black")
            clLabel?.textColor = UIColor.black
            clLabel?.text = "FCL"
            clLabel?.accessibilityLabel = "Forced Child Labor"
        }

        return cell
    }



    @IBAction func filterChanged(_ sender: AnyObject) {
        state = sender.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countrySelectedFromGoodView" {
            let svc = segue.destination as! CountryController
            svc.countryName = ((sender as! UITableViewCell).viewWithTag(301) as! UILabel).text!
        }
    }

}
