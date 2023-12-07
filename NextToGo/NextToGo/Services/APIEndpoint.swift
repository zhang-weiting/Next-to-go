//
//  APIEndpoint.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

enum APIEndpoint {
    
    static let racingBaseURL = "https://api.neds.com.au/rest/v1/racing"
    
    case nextRaces
    
    private var path: String {
        switch self {
        case .nextRaces:
            return "/?method=nextraces&count=10"
        }
    }
    
    static func endpointURL(for endpoint: APIEndpoint) -> URL? {
        let endpointPath = endpoint.path
        return URL(string: racingBaseURL + endpointPath)
    }
}
