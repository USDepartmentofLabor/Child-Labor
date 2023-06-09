
import Foundation

class AssesmentLevelParser {
    
    var goodsXML = SWXMLHash.parse("<xml></xml>")
    var goodsSectors = Dictionary<String, Any>()
    var onCompletionGoodsParsing: ((Dictionary<String, Any?>) -> Void)?
    var onFilterCountryRegionCompletion: (([Segment]) -> Void)?
    
    func parseGoodsData() {
        let urlPath = Bundle.main.path(forResource: kCountriesXmlFile, ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }

        goodsXML = SWXMLHash.parse(contents! as String)
                
        for country in goodsXML[kCountries][kCountry].all {
            
            if let countryRegion = country["Region"].element?.text, !countryRegion.isEmpty {
                if var advancementLevel  = country["Advancement_Level"].element?.text, !countryRegion.isEmpty, !advancementLevel.isEmpty {
                    if advancementLevel.contains("Minimal Advancement") {
                        advancementLevel = "Minimal Advancement"
                    }
                    if advancementLevel.contains("No Advancement") {
                        advancementLevel = "No Advancement"
                    }
                    if var currentSector = self.goodsSectors[countryRegion] as? Dictionary<String, Any> {
                        if var advancementInfo = currentSector[advancementLevel] as? Int {
                            advancementInfo += 1
                            currentSector[advancementLevel] = advancementInfo
                        } else {
                            currentSector[advancementLevel] = 1
                        }
                        self.goodsSectors[countryRegion] = currentSector
                    } else {
                        self.goodsSectors[countryRegion] = [advancementLevel : 1]
                    }
                    
                }
            }
        }
        
        self.onCompletionGoodsParsing?(self.goodsSectors)
    }
    
    func parseNewDVAsCoutryData() {
        let urlPath = Bundle.main.path(forResource: kCountriesXmlFile, ofType: "xml")
        var contents: NSString?
        do {
            contents = try NSString(contentsOfFile: urlPath!, encoding: String.Encoding.utf8.rawValue)
        } catch _ {
            contents = nil
        }
        
        goodsXML = SWXMLHash.parse(contents! as String)
        
        for country in goodsXML[kCountries][kCountry].all {
            if let countryRegion = country["Region"].element?.text, !countryRegion.isEmpty {
                var enforcementss = ""
                if var enforcement = country["Enforcements"]["Labor_Inspectors_Intl_Standards"]["Territory"]["Enforcement"].element?.text {
                    enforcementss = enforcement
                } else {
                    if var enforcements = country["Enforcements"]["Labor_Inspectors_Intl_Standards"].element?.text, !enforcements.isEmpty {
                        enforcementss = enforcements
                    }
                }
                if enforcementss.count > 0 {
                    if var currentSector = self.goodsSectors[countryRegion] as? Dictionary<String, Any> {
                        if var advancementInfo = currentSector[enforcementss] as? Int {
                            advancementInfo += 1
                            currentSector[enforcementss] = advancementInfo
                        } else {
                            currentSector[enforcementss] = 1
                        }
                        self.goodsSectors[countryRegion] = currentSector
                    } else {
                        self.goodsSectors[countryRegion] = [enforcementss : 1]
                    }
                }
            }
        }
        
        self.onCompletionGoodsParsing?(self.goodsSectors)
    }
    
}
