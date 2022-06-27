//
//  SomaliaTableViewController.swift
//  Child Labor
//
//  Created by Sanganal, Akshay on 8/28/17.
//  Copyright © 2017 U.S. Department of Labor. All rights reserved.
//

import UIKit

class PakistanTableViewController: UITableViewController {
    
    var countryName = "Pakistan"
    
    @IBOutlet weak var agricultureLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    
    var analyticsData: [Segment] = [Segment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Pakistan Statistics Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        self.readDataFromXML()
        self.addTableViewFooter()
    }
    
    func readDataFromXML() {
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents! as String)
        
        for country in countriesXML["Countries"]["Country"].all {
            if country["Name"].element?.text == "Pakistan" {
                
                let statistics = country["Country_Statistics"]
                
                // Agriculture
                if let agriculturePercentage = statistics["Children_Work_Statistics"]["Agriculture"].element {
                    if agriculturePercentage.text != nil {
                        if agriculturePercentage.text != "" {
                            agricultureLabel.text = String(format: "%.1f", (agriculturePercentage.text as NSString).floatValue * 100.0) + "%"
                            agricultureLabel.textColor = UIColor.black
                            
                            if (agriculturePercentage.text as NSString).floatValue > 0 {
                                let agricultureSector = Segment.init(color: UIColor(red: 57.0/255.0, green: 89.0/255.0, blue: 122.0/255.0, alpha: 1), value: CGFloat((agriculturePercentage.text as NSString).floatValue * 100.0), title : "Agriculture", isFloatType: true)
                                analyticsData.append(agricultureSector)
                            }
                        }
                    }
                    if (agriculturePercentage.text == "Unavailable" || agriculturePercentage.text == "unavailable")
                    {
                        agricultureLabel.text = "Unavailable"
                        agricultureLabel.textColor = UIColor.black
                    }
                    if agriculturePercentage.text == "N/A"
                    {
                        agricultureLabel.text = "N/A"
                        agricultureLabel.accessibilityLabel = "Not Available"
                        agricultureLabel.textColor = UIColor.black
                    }
                    
                }
                
                // Services
                if let servicesPercentage = statistics["Children_Work_Statistics"]["Services"].element {
                    if servicesPercentage.text != nil {
                        if servicesPercentage.text != "" {
                            servicesLabel.text = String(format: "%.1f", (servicesPercentage.text as NSString).floatValue * 100.0) + "%"
                            servicesLabel.textColor = UIColor.black
                            if (servicesPercentage.text as NSString).floatValue > 0 {
                                let servicesSector = Segment.init(color: UIColor(red: 108.0/255.0, green: 129.0/255.0, blue: 79.0/255.0, alpha: 1), value: CGFloat((servicesPercentage.text as NSString).floatValue * 100.0), title : "Services", isFloatType: true)
                                analyticsData.append(servicesSector)
                            }
                        }
                    }
                    if (servicesPercentage.text == "Unavailable" || servicesPercentage.text == "unavailable")
                    {
                        servicesLabel.text = "Unavailable"
                        servicesLabel.textColor = UIColor.black
                    }
                    if servicesPercentage.text == "N/A"
                    {
                        servicesLabel.text = "N/A"
                        servicesLabel.accessibilityLabel = "Not Available"
                        servicesLabel.textColor = UIColor.black
                    }
                    
                }
                
                // Industry
                if let industryPercentage = statistics["Children_Work_Statistics"]["Industry"].element {
                    if industryPercentage.text != nil {
                        if industryPercentage.text != "" {
                            industryLabel.text = String(format: "%.1f", (industryPercentage.text as NSString).floatValue * 100.0) + "%"
                            industryLabel.textColor = UIColor.black
                            if (industryPercentage.text as NSString).floatValue > 0 {
                                let industrySector = Segment.init(color: UIColor(red: 218.0/255.0, green: 142.0/255.0, blue: 57.0/255.0, alpha: 1), value: CGFloat((industryPercentage.text as NSString).floatValue * 100.0), title : "Industry", isFloatType: true)
                                analyticsData.append(industrySector)
                            }
                        }
                    }
                    if (industryPercentage.text == "Unavailable" || industryPercentage.text == "unavailable")
                    {
                        industryLabel.text = "Unavailable"
                        industryLabel.textColor = UIColor.black
                    }
                    if industryPercentage.text == "N/A"
                    {
                        industryLabel.text = "N/A"
                        industryLabel.accessibilityLabel = "Not Available"
                        industryLabel.textColor = UIColor.black
                    }
                }
                if #available(iOS 13.0, *) {
                    servicesLabel.textColor = .label
                    agricultureLabel.textColor = .label
                    industryLabel.textColor = .label
                } else {
                    // Fallback on earlier versions
                }
                break;
            }
        }
    }
    
    func addTableViewFooter() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 50))
        customView.backgroundColor = UIColor.clear
        let button = UIButton(frame: CGRect(x: 20, y: 0, width: self.tableView.frame.width - 40, height: 50))
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize:20)
        button.backgroundColor = .lightGray.withAlphaComponent(0.8)
        button.layer.cornerRadius = 20
        button.setTitle("Open Analysis", for: .normal)
        button.addTarget(self, action: #selector(openWorkingStatics), for: .touchUpInside)
        customView.addSubview(button)
        self.tableView.tableFooterView = customView
        
    }
    
    @objc func openWorkingStatics(_ sender: UIButton!) {
                
        let viewController = PieChartViewController()
        viewController.isFromWorkingStatistics = true
        viewController.workingStatistics = analyticsData
        viewController.countryName = self.countryName
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 0 : 3
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.gray
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.gray
    }
}

