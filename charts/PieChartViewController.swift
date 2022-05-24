
import UIKit


struct CountryRegionItem: Identifiable {
    var id = UUID()
    var title: String
    var color: UIColor
}

enum GoodsSectors: String, CaseIterable {

    case agriculture = "Agriculture"
    case manufacturing = "Manufacturing"
    case mining = "Mining"
    case other = "Other"
}

class PieChartViewController: UIViewController {
    
    @IBOutlet weak var circularPieView : CircularSliceView!
    @IBOutlet weak var goodsSegments : UISegmentedControl!
    
    @IBOutlet weak var colorCodesCollectionView : UICollectionView!
    private(set) var leadingSpace = UIDevice.isIPad() ? 16.0 : 10.0
        
    private let countryRegionArray: [CountryRegionItem] = [
        CountryRegionItem(title: "Europe and Eurasia", color: UIColor(red: 57.0/255.0, green: 89.0/255.0, blue: 122.0/255.0, alpha: 1)),
        CountryRegionItem(title: "Indo-Pacific", color: UIColor(red: 147.0/255.0, green: 78.0/255.0, blue: 80.0/255.0, alpha: 1)),
        CountryRegionItem(title: "Latin America and the Caribbean", color: UIColor(red: 108.0/255.0, green: 129.0/255.0, blue: 79.0/255.0, alpha: 1)),
        CountryRegionItem(title: "Middle East and North Africa", color: UIColor(red: 218.0/255.0, green: 142.0/255.0, blue: 57.0/255.0, alpha: 1)),
        CountryRegionItem(title: "Sub-Saharan Africa", color: UIColor(red: 130.0/255.0, green: 152.0/255.0, blue: 143.0/255.0, alpha: 1))
    ]
    var goodsXML = SWXMLHash.parse("<xml></xml>")
    
    var goodsSectors = Dictionary<String, Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setupCollectionView()
        self.setupNavigationBar()
        self.parseGoodsData()
    }
    
    func setupCollectionView() {
        self.colorCodesCollectionView.layer.borderColor = UIColor.black.cgColor
        self.colorCodesCollectionView.layer.borderWidth = 2
        
        self.colorCodesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCollectionCell")
        self.colorCodesCollectionView.register(UINib(nibName:"CustomColorCodeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomColorCodeCollectionViewCell")
        
    }
    
    func setupNavigationBar() {
        
        self.title = "Goods By Sector And Region"
        // Navigation bar color
        self.navigationController?.navigationBar.topItem?.title = " "
        
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
    
    func setupPieChartView(segmentInfo: Dictionary<String, Any>) {
        circularPieView.segments.removeAll()
        
        var segments = [Segment]()
        
        for (_, goodsSector) in segmentInfo.keys.enumerated() {
            if let value = segmentInfo[goodsSector] as? Int {
                let filterdRegion = countryRegionArray.filter { $0.title.contains(goodsSector) }
                let regionColor = (filterdRegion.count > 0) ? filterdRegion[0].color : .randomColor()
                let segement = Segment.init(color: regionColor, value: CGFloat(value), title : goodsSector)
                segments.append(segement)
            }
        }
        circularPieView.segments = segments
    }
    
    func parseGoodsData() {
        let urlPath = Bundle.main.path(forResource: "goods_2016", ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        goodsXML = SWXMLHash.parse(contents! as String)
        
        for good in goodsXML["Goods"]["Good"].all {
            if let goodsSector = good["Good_Sector"].element?.text {
                
                for country in good["Countries"]["Country"].all {
                    if  let countryRegion  = country["Country_Region"].element?.text, !countryRegion.isEmpty {
                        
                        if var currentSector = self.goodsSectors[goodsSector] as? Dictionary<String, Any> {
                            if var regionInfo = currentSector[countryRegion] as? Int {
                                regionInfo += 1
                                currentSector[countryRegion] = regionInfo
                            } else {
                                currentSector[countryRegion] = 1
                            }
                            self.goodsSectors[goodsSector] = currentSector
                        } else {
                            self.goodsSectors[goodsSector] = [countryRegion : 1]
                        }
                    }
                }
            }
        }
        self.setupSegmentControl()
        
    }
    
    func setupSegmentControl() {
        self.goodsSegments.removeAllSegments()
        
        for segmentName in GoodsSectors.allCases.reversed() {
            self.goodsSegments.insertSegment(withTitle: segmentName.rawValue, at: 0, animated: true)
        }
        self.goodsSegments.selectedSegmentIndex = 0
        
        for segmentItem : UIView in self.goodsSegments.subviews
        {
            for item : Any in segmentItem.subviews {
                if let i = item as? UILabel {
                    i.numberOfLines = 0
                }
            }
        }
        
        var segmentFrame = self.goodsSegments.frame
        segmentFrame.size.height = 60
        self.goodsSegments.frame = segmentFrame
        
        self.refreshChartInfo()
    }
    
    func refreshChartInfo() {
        if let selectedSegment = self.goodsSegments.titleForSegment(at: self.goodsSegments.selectedSegmentIndex), let chartInfo = self.goodsSectors[selectedSegment] as? Dictionary<String, Any> {
            self.setupPieChartView(segmentInfo: chartInfo)
        }
    }
    
    @IBAction func refreshGoodsSection(_ sender: UISegmentedControl) {
        self.refreshChartInfo()
    }
    
}

// MARK: - UICollectionView Delegate & Datasource
extension PieChartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryRegionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCollectionCell", for: indexPath)
        
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomColorCodeCollectionViewCell", for: indexPath) as? CustomColorCodeCollectionViewCell else {
            return cell
        }
        colorCell.lblTitle.text = countryRegionArray[indexPath.item].title
        colorCell.colorCodeLbl.backgroundColor = countryRegionArray[indexPath.item].color
        
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize = .zero
        
        if UIDevice.isIPad() {
            size = self.getIpadSize(with: leadingSpace)
        } else {
            let screenWidth = UIScreen.main.bounds.size.width
            let cellDimension = (screenWidth) - leadingSpace
            size = CGSize(width: cellDimension, height: 30)
        }
        
        return size
    }
    
    func getIpadSize(with lineSpacing: CGFloat = 0.0) -> CGSize {
        let deviceWidth = UIScreen.main.bounds.size.width
        var size = CGSize.zero
        let currentOrientation = UIDevice.current.currentOrientation
        let portraitDimension = (deviceWidth / 2.0) - lineSpacing
        let landScapeDimension = (deviceWidth / 3.0) - lineSpacing
        let portraitSize = CGSize(width: portraitDimension, height: 30)
        let landscapeSize = CGSize(width: landScapeDimension, height: 30)
        switch currentOrientation {
        case .portrait, .portraitUpsideDown:
            size = portraitSize
        default :
            size = landscapeSize
        }
        return size
    }
}
