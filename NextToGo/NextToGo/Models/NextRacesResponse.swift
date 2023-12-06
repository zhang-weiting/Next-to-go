//
//  NextRacesResponse.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

struct NextRacesResponse: Decodable {
    
    let races : [Race]
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    enum DataKeys: String, CodingKey {
        case nextToGoIds = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        var results = [Race]()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let dynamicKeysContainer = try nestedContainer.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .raceSummaries)
        for key in dynamicKeysContainer.allKeys {
            let value = try dynamicKeysContainer.decode(Race.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            results.append(value)
        }
        races = results
    }
}
