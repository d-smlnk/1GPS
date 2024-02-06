//
//  TrackDatasource.swift
//  1GPS
//
//  Created by Дима Самойленко on 04.02.2024.
//

import Foundation
import Alamofire

enum ApiNetwork {
    
    case track
    
    var url: String {
        switch self {
        case .track:
            return "http://mega-gps.com/api3"
        }
    }
}

enum ErrorMessage: Error {
    case invalidData
    case invalidResponse
    case invalidApiKey
    case message(_ error: Error)
}

class TrackDatasource {
    
    private let parameters: ParamsBuilder
    
    init(parameters: ParamsBuilder) {
        self.parameters = parameters
    }
    
    func fetchTrackData(completion: @escaping(Result<TrackerModel, Error>) -> Void) {
        
        AF.request(ApiNetwork.track.url, method: .post, parameters: parameters.getParameters(), encoding: URLEncoding.default)
            .validate()
            .responseDecodable(of: TrackerModel.self) { response in
                
                if let statusCode = response.response?.statusCode {
                    
                    if let responseData = response.data,
                       let errorMessage = String(data: responseData, encoding: .utf8),
                       errorMessage.contains("Bad API KEY") {
                        completion(.failure(ErrorMessage.invalidApiKey))
                        return
                    }
                    print("Status code: \(statusCode)")
                }
                guard let csvDataString = String(data: response.data ?? Data(), encoding: .utf8) else {
                    completion(.failure(ErrorMessage.invalidData))
                    return
                }
                
                let csvParser = CSVToJSONParser(csvString: csvDataString)
                
                guard let jsonData = csvParser.convertCSVtoJSON() else {
                    completion(.failure(ErrorMessage.invalidData))
                    return
                }
                
                do {
                    let trackerModel = try JSONDecoder().decode(TrackerModel.self, from: jsonData)
                    
                    completion(.success(trackerModel))
                    
                } catch {
                    completion(.failure(ErrorMessage.message(error)))
                    print("Ошибка декодирования JSON: \(error)")
                }
            }
    }
}
