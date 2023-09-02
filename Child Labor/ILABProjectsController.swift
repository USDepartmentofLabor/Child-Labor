//
//  ILABProjectsController.swift
//  Child Labor
//
//  Created by Gnanendra Kumar on 24/06/21.
//  Copyright © 2021 U.S. Department of Labor. All rights reserved.
//

import Foundation
import UIKit
class ILABProjectsController : UIViewController,UITableViewDelegate,UITableViewDataSource, UIWebViewDelegate{
    let screenSize = UIScreen.main.bounds
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = projectsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProjectTableViewCell
        



        cell.link.tag = indexPath.row
                
                
            
        cell.link.loadHTMLString("<html><a href=\""+(links[indexPath.item] as! String)+"\">"+(titles[indexPath.item] as! String)+"</a></html>", baseURL: nil)
        cell.link.delegate = self
        cell.link.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height:CGFloat(0.0))
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = screenSize.width
        let value:String = (titles[indexPath.item] as! String)
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
            return value.count < 60 ? 50 : value.height(constraintedWidth:screenWidth-200)
            case .pad:
                return value.height(constraintedWidth:screenWidth-600)
        @unknown default:
                return value.height(constraintedWidth:screenWidth-200)
            }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.openURL(URL(string: (links[indexPath.item] as! String))!)
    }
    
    @IBOutlet weak var projectsTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    var countryName = ""
    var titles = NSMutableArray()
    var links = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.isHidden = true
        // Get the country data
        let urlPath = Bundle.main.path(forResource: "countries_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        let countriesXML = SWXMLHash.parse(contents! as String)
        
        for country in countriesXML["Countries"]["Country"].all {
            if country["Name"].element?.text == self.countryName {
                if((country.children.description.contains("ILAB_Projects")) == true){
                    for project in country["ILAB_Projects"].all {
                        for proj in project["Project"].children{
                            let key = String(proj.all[0].element?.name ?? "")
                            let val = String(proj.all[0].element?.text ?? "")
                            if(key == "Title"){
                                titles.add(val)
                            }else{
                                links.add(val)
                            }
                        }
                    }
                }
                break;
            }
        }
        if(titles.count == 0){
            noDataLabel.isHidden = false
            projectsTableView.isHidden = true
        }else{
            noDataLabel.isHidden = true
            projectsTableView.isHidden = false
        }
        projectsTableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        projectsTableView.reloadData()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
            switch navigationType {
            case .linkClicked:
                guard let url = request.url else { return true }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
                return false
            default:
                // TODO: handle other navigation types such reload, back or forward...
                return true
            }
        }
    
    
}
