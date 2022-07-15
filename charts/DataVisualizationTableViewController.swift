
import UIKit

enum ChartTypes: String, CaseIterable {
    
    //case proportionalChart = "Most common goods produced with exploited labor"
    case goodsBySector = "Goods By Sector"
    case goodsByRegion = "Goods By Region"
    case assesmentLevelByRegion = "Assesment Level By Region"
}
class DataVisualizationTableViewController: UITableViewController {
   
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.sendGAIEvent()
        self.setupNavigationBar()
        self.setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Data Visualizations"
    }
    
    func sendGAIEvent() {
        // Record GA view
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: "DataVisualization List Screen")
        tracker?.send(GAIDictionaryBuilder.createAppView().build() as? [AnyHashable: Any])
    }
    
    func setupNavigationBar() {
        
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
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

extension DataVisualizationTableViewController {
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ChartTypes.allCases.count
     }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell()
        
        let chartType = ChartTypes.allCases[indexPath.row]
        cell.textLabel?.text = chartType.rawValue
       
         let chevron = UIImage(named: "arrow.png")
         cell.textLabel?.numberOfLines = 0
         cell.accessoryType = .disclosureIndicator
         cell.accessoryView = UIImageView(image: chevron)
         if #available(iOS 13.0, *) {
             cell.textLabel?.textColor = .label
         } else {
             // Fallback on earlier versions
         }
         return cell
     }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc: UIViewController?
        let chartType = ChartTypes.allCases[indexPath.row]

        switch chartType {
//        case .proportionalChart:
//            vc = ProportionalChartViewController.loadFromNib()
//            break
        case .goodsBySector:
            vc = PieChartViewController(chartType: .goodsSectorType)
            break
        case .goodsByRegion:
            vc = PieChartViewController(chartType: .countryRegionType)
            break
        case .assesmentLevelByRegion:
            vc = AssesmentsPageViewController()
            break
        @unknown default:
            vc = ProportionalChartViewController.loadFromNib()
            break
        }
 
        guard let viewController = vc else { return }
        navigationController?.pushViewController(viewController, animated: true)

    }
}

