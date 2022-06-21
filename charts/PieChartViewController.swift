
import UIKit


struct CountryRegionItem: Identifiable {
    var id = UUID()
    var title: String
    var color: UIColor
}

enum GoodsSector : String, CaseIterable {
    case agriculture = "Agriculture"
    case manufacturing = "Manufacturing"
    case mining = "Mining"
    case other = "Other"
}

enum ChartDataType: String {
    case goodsSectorType
    case countryRegionType
    case workingStatistics
}

class PieChartViewController: UIViewController {
    
    private lazy var countryTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize:16)
        return label
    }()
    
    @IBOutlet weak var circularPieView : CircularSliceView!
    @IBOutlet weak var goodsSegments : UISegmentedControl!
    
    @IBOutlet weak var colorCodesCollectionView : UICollectionView!
    @IBOutlet weak var segmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var isFromWorkingStatistics: Bool = false
    var countryName: String = ""
    var workingStatistics: [Segment]?
    private(set) var chartDataType: ChartDataType?
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
    
    //MARK: - Initialisation methods.
    /// Convenience init declaration
    required convenience init?(coder: NSCoder) {
        self.init(coder: coder)
    }
    
    /// Convenience delcaration for charttype view initialization.
    convenience init(chartType: ChartDataType? = nil) {
        self.init(nibName: "PieChartViewController",
                  bundle: Bundle(for: PieChartViewController.self))
        self.chartDataType = chartType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setupCollectionView()
        self.setupNavigationBar()
        if !isFromWorkingStatistics {
            self.parseGoodsData()
        }
        if !(self.chartDataType == .goodsSectorType) {
            self.goodsSegments.isHidden = true
            self.segmentHeightConstraint.constant = 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromWorkingStatistics {
            self.title = "Working Statistics"
            self.countryTitleLabel.text = "No Data Available"
            self.countryTitleLabel.frame = CGRect(x: 0, y: self.view.frame.height/2 , width: self.view.frame.width, height: 40)
            self.countryTitleLabel.center = self.view.center
            if self.workingStatistics?.count ?? 0 > 0 {
                self.countryTitleLabel.text = "\(countryName) Statistics"

                circularPieView.segments = self.workingStatistics ?? [Segment]()
                self.countryTitleLabel.frame = CGRect(x: 0, y: circularPieView.frame.minY - 30 , width: self.view.frame.width, height: 40)
            }
            self.view.addSubview(self.countryTitleLabel)

        }
    }
    
    private func setupCollectionView() {
        
        self.colorCodesCollectionView.layer.borderColor = UIColor.black.cgColor
        self.colorCodesCollectionView.layer.borderWidth = 2
        if isFromWorkingStatistics {
            self.colorCodesCollectionView.layer.borderColor = UIColor.clear.cgColor
            self.colorCodesCollectionView.layer.borderWidth = 0
        } else {
            if #available(iOS 12.0, *) {
                if (self.traitCollection.userInterfaceStyle == .dark) {
                    self.colorCodesCollectionView.backgroundColor = .black
                    self.colorCodesCollectionView.layer.borderColor = UIColor.white.cgColor
                }
            }
        }
        self.colorCodesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCollectionCell")
        self.colorCodesCollectionView.register(UINib(nibName:"CustomColorCodeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomColorCodeCollectionViewCell")
    }
    
    private func setupNavigationBar() {
        
        self.title = (self.chartDataType == .goodsSectorType) ? ChartTypes.goodsBySector.rawValue : ChartTypes.goodsByRegion.rawValue
        
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
        
        switch self.chartDataType {
        case .countryRegionType:
            filterSegmentDataWithCountryRegion()
            break
        case .goodsSectorType:
            filterSegementDataWithGoodsSector(segmentInfo: segmentInfo)
            break
        case .workingStatistics:
            break
        case .none:
                break
        
        }
        
        func filterSegmentDataWithCountryRegion() {
            
            var segments = [Segment]()
            
            let filteredGoodsData = self.goodsSectors.reduce(into: [String: [String: Int]]()) { partialResult, current in
                let date = current.key
                let dayRates = current.value
                (dayRates as! Dictionary<String, Any>).forEach { aDayRate in
                    var currencyRates = partialResult[aDayRate.key, default: [:]]
                    currencyRates[date] = aDayRate.value as? Int
                    partialResult[aDayRate.key] = currencyRates
                }
            }
            
            for countryRegion in self.countryRegionArray {
                if let regionGoods = filteredGoodsData[countryRegion.title] {
                    var sum = 0
                    for goodsSectorKey in regionGoods.keys {
                        sum += regionGoods[goodsSectorKey] ?? 0
                    }
                    
                    let filterdRegion = countryRegionArray.filter { $0.title.contains(countryRegion.title) }
                    let regionColor = (filterdRegion.count > 0) ? filterdRegion[0].color : .randomColor()
                    let segement = Segment.init(color: regionColor, value: CGFloat(sum), title : countryRegion.title)
                    segments.append(segement)
                }
            }
            circularPieView.segments = segments
        }
        
        func filterSegementDataWithGoodsSector(segmentInfo: Dictionary<String, Any>) {
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
        
    }

    private func parseGoodsData() {
        let parserModel = GoodsParser()
        parserModel.onCompletionGoodsParsing = { [weak self] goodsData in
            guard let self = self else { return }
            self.goodsSectors = goodsData as [String : Any]
            self.setupSegmentControl()
        }
        parserModel.parseGoodsData()
    }
    
    private func setupSegmentControl() {
        self.goodsSegments.removeAllSegments()
        
        for segmentName in GoodsSector.allCases.reversed() {
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
        self.goodsSegments.apportionsSegmentWidthsByContent = true
        self.refreshChartInfo()
    }
    
    private func refreshChartInfo() {
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
        return isFromWorkingStatistics ? (self.workingStatistics?.count ?? 0) :  countryRegionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCollectionCell", for: indexPath)
        
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomColorCodeCollectionViewCell", for: indexPath) as? CustomColorCodeCollectionViewCell else {
            return cell
        }
        let title = isFromWorkingStatistics ? self.workingStatistics?[indexPath.item].title : countryRegionArray[indexPath.item].title
        let color = isFromWorkingStatistics ? self.workingStatistics?[indexPath.item].color : countryRegionArray[indexPath.item].color
        colorCell.lblTitle.text = title
        colorCell.colorCodeLbl.backgroundColor = color
        if isFromWorkingStatistics {
            colorCell.lblTitle.textColor = .black
        } else {
            if #available(iOS 12.0, *) {
                if (self.traitCollection.userInterfaceStyle == .dark) {
                    colorCell.lblTitle.textColor = .white
                }
            } else {
                colorCell.lblTitle.textColor = .black
            }
        }
        
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize = .zero
        
        if UIDevice.isIPad() {
            size = self.getIpadSize(with: leadingSpace)
        } else {
            let screenWidth = UIScreen.main.bounds.size.width
            let cellDimension = screenWidth - leadingSpace
            size = CGSize(width: cellDimension, height: 40)
        }
        
        return size
    }
    
    func getIpadSize(with lineSpacing: CGFloat = 0.0) -> CGSize {
        let deviceWidth = UIScreen.main.bounds.size.width
        var size = CGSize.zero
        let currentOrientation = UIDevice.current.currentOrientation
        let portraitDimension = deviceWidth - lineSpacing
        let landScapeDimension = deviceWidth - lineSpacing
        let portraitSize = CGSize(width: portraitDimension, height: 50)
        let landscapeSize = CGSize(width: landScapeDimension, height: 50)
        switch currentOrientation {
        case .portrait, .portraitUpsideDown:
            size = portraitSize
        default :
            size = landscapeSize
        }
        return size
    }
    
    static func getDictValue(dict:[String: Any], path:String)->Any?{
           let arr = path.components(separatedBy: ".")
           if(arr.count == 1){
               return dict[String(arr[0])]
           }
           else if (arr.count > 1){
               let p = arr[1...arr.count-1].joined(separator: ".")
               let d = dict[String(arr[0])] as? [String: Any]
               if (d != nil){
                   return getDictValue(dict:d!, path:p)
               }
           }
           return nil
       }

}


