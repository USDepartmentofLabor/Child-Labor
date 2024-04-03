//
//  TopicItemViewModel.swift
//  MSHA-Miners
//
//  Created by Greg Gruse on 4/20/22.
//

import Foundation
import SwiftUI

public class Model {
    
    private static var singletonModelData: Model = {
        let model = Model()
        return model
    }()
    
    // MARK: - Accessors
    class func shared() -> Model {
        return singletonModelData
    }
    
    var goods: [Good]
    
    init() {
        print("GGG: Starting Data Load \(Date().description(with: Locale.current))")
        self.goods = Model.readData(fileName: "goods").data.sorted(by: { $1.good > $0.good })
    }
    
    static func readData(fileName: String) -> GoodsData {
        print("GGG: Processing file: \(fileName)")
        let fileName = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonString = try! String(contentsOfFile: fileName ?? "Error")
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        do {
            let goodsData = try decoder.decode(GoodsData.self, from: jsonData)
            return goodsData
        } catch DecodingError.dataCorrupted(let context) {
            print("Data corrupted: \(context)")
            return GoodsData(data: [])
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return GoodsData(data: [])
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return GoodsData(data: [])
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return GoodsData(data: [])
        } catch {
            print("Error during decoding:", error.localizedDescription)
            return GoodsData(data: [])
        }
    }
    
    public struct GoodsData: Codable {
        var data: [Good]
    }
    
    public struct Good: Codable {
        var country_numeric_iso_code: String
        var country_iso_code: String
        var country: String
        var sector: String
        var good: String
        var exploitation_type: String
        var year_added: String
        var year_removed: String?
        
    }
}
