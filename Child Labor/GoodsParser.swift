
import Foundation

class GoodsParser {
 
    var goodsXML = SWXMLHash.parse("<xml></xml>")
    var onCompletionGoodsParsing: ((Dictionary<String, Any?>) -> Void)?
    var onFilterCountryRegionCompletion: (([Segment]) -> Void)?
    
    func parseGoodsData() {
        var goodsSectors = Dictionary<String, Any>()

        let urlPath = Bundle.main.path(forResource: kGoodsXmlFile, ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        goodsXML = SWXMLHash.parse(contents! as String)
        
        for good in goodsXML[kGoods][kGood].all {
            if let goodsSector = good[kGoodSector].element?.text {
                
                for country in good[kCountries][kCountry].all {
                    if  let countryRegion  = country[kCountryRegion].element?.text, !countryRegion.isEmpty {
                        
                        if var currentSector = goodsSectors[goodsSector] as? Dictionary<String, Any> {
                            if var regionInfo = currentSector[countryRegion] as? Int {
                                regionInfo += 1
                                currentSector[countryRegion] = regionInfo
                            } else {
                                currentSector[countryRegion] = 1
                            }
                            goodsSectors[goodsSector] = currentSector
                        } else {
                            goodsSectors[goodsSector] = [countryRegion : 1]
                        }
                    }
                }
            }
        }
        
        self.onCompletionGoodsParsing?(goodsSectors)
    }
    

}
