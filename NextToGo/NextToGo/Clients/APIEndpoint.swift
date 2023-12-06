//
//  APIEndpoint.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

enum APIEndpoint {
    
    static let racingBaseURL = "https://api.neds.com.au/rest/v1/racing"
    
    case nextRacesByCount(Int)
    
    private var path: String {
        switch self {
        case .nextRacesByCount(let count):
            return "/?method=nextraces&count=\(count)"
        }
    }
    
    static func endpointURL(for endpoint: APIEndpoint) -> URL? {
        let endpointPath = endpoint.path
        return URL(string: racingBaseURL + endpointPath)
    }
}
