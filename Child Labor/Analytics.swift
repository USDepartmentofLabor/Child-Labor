
//
//  Util.swift
//  BLS-OOH-iOS
//
//  Created by Nidhi Chawla on 7/10/19.
//  Copyright © 2019 Department of Labor. All rights reserved.
//

import Foundation
import UIKit

let appName = "Sweat and Toil"

enum Screen: String, Codable {
    case boot
    case dataVisualizationList
    case pakistanStatistics
    case conventions
    case countryProfile
    case countryList
    case explotation
    case factSheet
    case reportPDF
    case index
    case goodProfile
    case goodList
    case lawsList
    case lawsMulti
    case lawsStandards
    case lawsMultiStandards
    case coordination
    case statistics
    case somaliaStatistics
    case suggestedActions
    case enforcement
    case similarApp
    case tanzaniaStatistics
    case home
    case moreInfo
    case info
}

enum Category: String, Codable {
    case homeButtonPress
    case bootUp
    case none
}

enum EventType: String, Codable {
    case view
    case action
}

struct AnalyticsEvent: Codable {
    var type: EventType
    var screen: Screen
    var timeStamp: String
    var category: Category
    var metaData: String
}

struct Session: Codable {
    var anonymousDeviceId: String
    var deviceClass: String
    var osPlatform: String
    var appVersion: String
    var application: String
    var sessionStart: String
}


class Analytics {
    
    static var analyticsFilePath = ""
    static let dateFormatter = ISO8601DateFormatter()
    static let backgroundQueue = DispatchQueue.global(qos: .background)
    static var firstRequest = true
    
    static func bootInit()  {
        
        
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime, .withTimeZone]
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        setupSessionDataFile(analyticsFilePath)
        backgroundQueue.async {
            uploadSessionData()
        }
    }
    static func uploadSessionData()  {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let fileNames = getFilesWithPrefix(prefix: "session-")
        for fileURL in fileNames {
            guard !fileURL.absoluteString.contains(analyticsFilePath) else {
                continue
            }
            do {
                let fileContents = try Data(contentsOf: fileURL)
                if let contentsString = String(data: fileContents, encoding: .utf8) {
                    print("Contents of \(fileURL.absoluteString):")
                    print(contentsString)
                    let finalString = contentsString + "]}"
                    print("GGG: FinalString: \(finalString)")
                    sendSessionDataToAWS(finalString, fileLocation: fileURL)
                } else {
                    print("Unable to decode contents of \(fileURL.absoluteString) as UTF-8.")
                }
            } catch {
                print("Error reading contents of \(fileURL.absoluteString): \(error)")
            }
        }
  
        // After the task is done, schedule it to run again after 10 minutes
        backgroundQueue.asyncAfter(deadline: .now() + 600) { // 600 seconds = 10 minutes
             uploadSessionData() // Call the function again after the specified time interval
         }
    }
    
    static func getFilesWithPrefix(prefix: String) -> [URL] {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            let filteredFiles = fileURLs.filter { $0.lastPathComponent.hasPrefix(prefix) }
            return filteredFiles
        } catch {
            print("Error accessing document directory: \(error)")
            return []
        }
    }
    
    static public func sendSessionDataToAWS(_ sessionData: String, fileLocation: URL) {
        
        let url = URL(string: "https://mjy3f15q2d.execute-api.us-east-1.amazonaws.com/msha/usagemetricsjs")!
        var request = URLRequest(url: url)
        
        let currentTime = Date()
        let formattedTime = dateFormatter.string(from: currentTime)
        
        var jsonData: [String: Any] = [
            "app-id": "madpush",
            "date-time": formattedTime
        ]
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer owlO64/z5Z9CPsE1J4", forHTTPHeaderField: "Authorization")
        request.httpBody = sessionData.data(using: .utf8)
        print("GGG: \(sessionData)")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let dat = data {
                let dataStr = String(data: dat, encoding: .utf8)
                print(dataStr)
            }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if httpResponse.statusCode == 200 {
                do {
                    try FileManager.default.removeItem(at: fileLocation)
                    print("File deleted successfully")
                } catch {
                    print("Error deleting file: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    static func setupSessionDataFile(_ currentAnalyticsFile: String)  {
        
        let os = ProcessInfo.processInfo.operatingSystemVersion
        let osVersionString = "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
        
        var appVersionStr = ""
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            appVersionStr = "\(appVersion) ( \(buildNumber) )"
        } else {
            appVersionStr = "unknown"
        }
        
        let date = Date()
        let bootTimeStamp = dateFormatter.string(from: date)

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let tmpAnalyticsFilePath = documentsDirectory.appendingPathComponent("session-\(bootTimeStamp)").path

        let bootEvent = AnalyticsEvent(
            type: .view,
            screen: .boot,
            timeStamp: bootTimeStamp,
            category: .bootUp,
            metaData: "")
        
        let session = Session(
            anonymousDeviceId: UUID().uuidString,
            deviceClass: UIDevice.current.model,
            osPlatform: osVersionString,
            appVersion: appVersionStr,
            application: appName,
            sessionStart: bootTimeStamp)
        
        do {
            let jsonData = try JSONEncoder().encode(session)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                let tweakedJson = jsonString.replacingOccurrences(of: "}", with: ",\"analytics\":[")
                
                if FileManager.default.createFile(atPath: tmpAnalyticsFilePath, contents: tweakedJson.data(using: .utf8), attributes: nil) {
                    print("File created successfully.")
                    analyticsFilePath = tmpAnalyticsFilePath
                    firstRequest = true
                } else {
                    print("Error creating the file.")
                }
            }
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
    }
    
    static func appendToFile(content: Data) {
        guard let fileHandle = FileHandle(forWritingAtPath: analyticsFilePath) else {
            print("File not found or unable to open for writing.")
            // Handle the error as needed
            return
        }

        fileHandle.seekToEndOfFile()
        fileHandle.write(content)

        fileHandle.closeFile()
    }
    
    static func trackScreenView(_ screen: Screen, category: Category = .none, metaData: String = "" )  {
        doTrack(.view, screen: screen, category: category, metaData: metaData)
    }
    
    static func trackAction(_ screen: Screen, category: Category = .none, metaData: String = "" )  {
        doTrack(.action, screen: screen, category: category, metaData: metaData)
    }
    
    static func doTrack(_ type:EventType, screen: Screen, category: Category = .none, metaData: String = "" )  {
        if !analyticsFilePath.isEmpty {
            backgroundQueue.async {
                do {
                    let date = Date()
                    let timeStamp = dateFormatter.string(from: date)
                    
                    let screenView = AnalyticsEvent(
                        type: type,
                        screen: screen,
                        timeStamp: timeStamp,
                        category: category,
                        metaData: metaData)
                    
                    
                    let commaByte: UInt8 = 44
                    let commaData = Data([commaByte])
                    let jsonData = try JSONEncoder().encode(screenView)
                    var modJsonData = jsonData
                    if !firstRequest {
                        modJsonData = commaData + jsonData
                    }
                    appendToFile(content: modJsonData)
                    firstRequest = false
                    
                } catch {
                    print("Error encoding JSON: \(error)")
                }
            }
        }
    }
    
//    static func appendDataToFile(data: Data, filePath: String) {
//
//        if let fileHandle = FileHandle(forWritingAtPath: filePath) {
//            // Move to the end of the file
//            fileHandle.seekToEndOfFile()
//
//            // Write the data
//            fileHandle.write(data)
//
//            // Close the file
//            fileHandle.closeFile()
//        } else {
//            // If the file doesn't exist, create it and write the data
//            FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
//        }
//    }
}
