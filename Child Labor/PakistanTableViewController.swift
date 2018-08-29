//
//  SomaliaTableViewController.swift
//  Child Labor
//
//  Created by Sanganal, Akshay on 8/28/17.
//  Copyright © 2017 U.S. Department of Labor. All rights reserved.
//

import UIKit

class PakistanTableViewController: UITableViewController {
    
    var countryName = "Brazil"
    
    
    @IBOutlet weak var agrif: UILabel!
    @IBOutlet weak var agrip: UILabel!
    @IBOutlet weak var agris: UILabel!
    @IBOutlet weak var agrik: UILabel!
    @IBOutlet weak var agrib: UILabel!
    
    @IBOutlet weak var indf: UILabel!
    @IBOutlet weak var indp: UILabel!
    @IBOutlet weak var inds: UILabel!
    @IBOutlet weak var indk: UILabel!
    @IBOutlet weak var indb: UILabel!
    
    @IBOutlet weak var serf: UILabel!
    @IBOutlet weak var serp: UILabel!
    @IBOutlet weak var sers: UILabel!
    @IBOutlet weak var serk: UILabel!
    @IBOutlet weak var serb: UILabel!
    
    @IBOutlet weak var attf: UILabel!
    @IBOutlet weak var attp: UILabel!
    @IBOutlet weak var atts: UILabel!
    @IBOutlet weak var attk: UILabel!
    @IBOutlet weak var attb: UILabel!
    
    @IBOutlet weak var comf: UILabel!
    @IBOutlet weak var comp: UILabel!
    @IBOutlet weak var coms: UILabel!
    @IBOutlet weak var comk: UILabel!
    @IBOutlet weak var comb: UILabel!
    
    @IBOutlet weak var primf: UILabel!
    @IBOutlet weak var primp: UILabel!
    @IBOutlet weak var prims: UILabel!
    @IBOutlet weak var primk: UILabel!
    @IBOutlet weak var primb: UILabel!
    
    @IBOutlet weak var workingf: UILabel!
    @IBOutlet weak var workingp: UILabel!
    @IBOutlet weak var workings: UILabel!
    @IBOutlet weak var workingk: UILabel!
    @IBOutlet weak var workingb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "Somalia Statistics Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as! [AnyHashable: Any])
        
        
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents! as String)
        
        for country in countriesXML["Countries"]["Country"].all {
            if country["Name"].element?.text == "Pakistan"{
                
                
                workingf.text = "Unavailable (Unknown; ages 5-14)"
                workingf.textColor = UIColor.black;
                
                workingp.text = "12.4 % (Unknown; ages 5-14)"
                workingp.textColor = UIColor.black;
                
                workingk.text = "Unavailable"
                workingk.textColor = UIColor.black;
                
                workings.text = "13.2 % (Unknown; ages 5-14)"
                workings.textColor = UIColor.black;
                
                workingb.text = "13.2 % (Unknown; ages 5-14)"
                workingb.textColor = UIColor.black;
                
                
                
                
                agrif.text = "Unavailable"
                agrif.textColor = UIColor.black;
                
                agrip.text = "Unavailable"
                agrip.textColor = UIColor.black;
                
                agris.text = "Unavailable"
                agris.textColor = UIColor.black;
                
                agrib.text = "Unavailable"
                agrib.textColor = UIColor.black;
                
                agrik.text = "Unavailable"
                agrik.textColor = UIColor.black;
                
                
                
                
                
                indf.text = "Unavailable"
                indf.textColor = UIColor.black;
                
                indp.text = "Unavailable"
                indp.textColor = UIColor.black;
                
                inds.text = "Unavailable"
                inds.textColor = UIColor.black;
                
                indb.text = "Unavailable"
                indb.textColor = UIColor.black;

                indk.text = "Unavailable"
                indk.textColor = UIColor.black;

                
                
                serf.text = "Unavailable"
                serf.textColor = UIColor.black;
                
                serp.text = "Unavailable"
                serp.textColor = UIColor.black;
                
                sers.text = "Unavailable"
                sers.textColor = UIColor.black;
                
                serk.text = "Unavailable"
                serk.textColor = UIColor.black;
                
                serb.text = "Unavailable"
                serb.textColor = UIColor.black;
                
                
                attf.text = "Unavailable(Ages 5-14)"
                attf.textColor = UIColor.black;
                
                attp.text = "77.1% (Ages 5-14)"
                attp.textColor = UIColor.black;
                
                atts.text = "60.6% (Ages 5-14)"
                atts.textColor = UIColor.black;
                
                attb.text = "Unavailable"
                attb.textColor = UIColor.black;
                
                attk.text = "Unavailable"
                attk.textColor = UIColor.black;
                
                comf.text = "Unavailable (Ages 7-14)"
                comf.textColor = UIColor.black;
               
                comb.text = "Unavailable"
                comb.textColor = UIColor.black;
                
                comk.text = "Unavailable"
                comk.textColor = UIColor.black;
                
                
                comp.text = "8.2% (Ages 7-14)"
                comp.textColor = UIColor.black;
                
                coms.text = "11.6% (Ages 7-14)"
                coms.textColor = UIColor.black;
                
                primf.text = "73.7%"
                primf.textColor = UIColor.black;
                
                primp.text = "Unavailable"
                primp.textColor = UIColor.black;
                
                prims.text = "Unavailable"
                prims.textColor = UIColor.black;
                
                primb.text = "Unavailable"
                primb.textColor = UIColor.black;
                
                primk.text = "Unavailable"
                primk.textColor = UIColor.black;
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    
    
}

