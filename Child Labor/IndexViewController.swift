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
    
   var menuItems = ["Countries", "Goods", "Exploitation Types" ]
    
    @IBOutlet weak var dol_button: UIButton!
    @IBOutlet weak var ilab_button: UIButton!
    override func viewDidLoad() {

        super.viewDidLoad()


        
        // View name for Google Analytics
        self.screenName = "Index Screen"
        
        // Navigation bar color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 0.2, blue: 0.33, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        tableView.dataSource = self
        tableView.delegate = self
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clears selection on viewWillAppear
        if let tableIndex = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: tableIndex, animated: false)
        }
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
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "countriesSelectedFromIndex", sender: self)
        case 1:
            self.performSegue(withIdentifier: "goodsSelectedFromIndex", sender: self)
        default:
            self.performSegue(withIdentifier: "exploitationSelectedFromIndex", sender: self)
        }
    }

    @IBAction func openIlabWebsite(_ sender: AnyObject) {
        // Open website
        UIApplication.shared.openURL(URL(string: "http://www.dol.gov/ilab/")!)
    }
    
    @IBAction func openDolWebsite(_ sender: AnyObject) {
        // Open website
        UIApplication.shared.openURL(URL(string: "http://www.dol.gov")!)
    }
    
    

}
