//
//  IndexViewController.swift
//  Child Labor
//
//  Created by E J Kalafarski on 5/26/15.
//  U.S. Government Work https://www.usa.gov/government-works
//

import UIKit

class IndexViewController: GAITrackedViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
   var menuItems = ["Countries/Areas", "Goods", "Exploitation Types","Data Visualizations" ]
    
    @IBOutlet weak var dol_button: UIButton!
    @IBOutlet weak var ilab_button: UIButton!
    override func viewDidLoad() {

        super.viewDidLoad()
        
        // Navigation bar color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
            appearance.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
            navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if #available(iOS 13.0, *) {
//            return .default
//        }else{
//            return .lightContent
//        }
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clears selection on viewWillAppear
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: tableIndex, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.trackScreenView(.index)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return menuItems.count
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = UITableViewCell()
      
        cell.textLabel?.text = menuItems[indexPath.row]
//        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        let chevron = UIImage(named: "arrow.png")
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: chevron)
        if #available(iOS 13.0, *) {
            cell.textLabel?.textColor = .label
        } else {
            // Fallback on earlier versions
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "countriesSelectedFromIndex", sender: self)
        case 1:
            self.performSegue(withIdentifier: "goodsSelectedFromIndex", sender: self)
        case 2:
            self.performSegue(withIdentifier: "exploitationSelectedFromIndex", sender: self)
        default:
            self.performSegue(withIdentifier: "DataVisualizationsSelectedFromIndex", sender: self)
        }
    }

    @IBAction func openIlabWebsite(_ sender: AnyObject) {
        // Open website
        UIApplication.shared.openURL(URL(string: "https://www.dol.gov/agencies/ilab")!)
    }
    
    @IBAction func openDolWebsite(_ sender: AnyObject) {
        // Open website
        UIApplication.shared.openURL(URL(string: "http://www.dol.gov")!)
    }
    
    

}
