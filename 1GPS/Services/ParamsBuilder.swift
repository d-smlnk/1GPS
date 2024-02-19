//
//  ParamsBuilder.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import Foundation
import Alamofire

struct ParamsBuilder {
    
    private let apiKey: String
    private let trackerID: Int
    private let functionCode: Int
    private let startTimeUNIX: TimeInterval
    private let endTimeUNIX: TimeInterval
    
    init(apiKey: String, trackerID: Int = 0, functionCode: Int = 0, startTimeUNIX: TimeInterval = DateComponents(year: -1).date?.timeIntervalSince1970 ?? 0, endTimeUNIX: TimeInterval = Date.timeIntervalSinceReferenceDate) {
        self.apiKey = apiKey
        self.trackerID = trackerID
        self.functionCode = functionCode
        self.startTimeUNIX = startTimeUNIX
        self.endTimeUNIX = endTimeUNIX
    }
    
    func getParameters() -> Parameters {
        let params: Parameters = [
            "s": apiKey,
            "c": functionCode,
            "i": trackerID,
            "x": startTimeUNIX,
            "y": endTimeUNIX
        ]
        return params
    }
}
