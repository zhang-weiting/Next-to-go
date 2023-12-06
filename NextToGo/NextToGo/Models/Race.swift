//
//  Race.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

struct Race: Decodable, Hashable {
    let meetingName: String
    let raceNumber: Int
    let advertisedStart: Int
    let categoryID: String
    
    private enum CodingKeys: String, CodingKey {
        case meetingName = "meeting_name"
        case raceNumber = "race_number"
        case advertisedStart = "advertised_start"
        case categoryID = "category_id"
    }
    
    private enum AdvertisedStartKeys: String, CodingKey {
        case seconds = "seconds"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: AdvertisedStartKeys.self, forKey: .advertisedStart)
        meetingName = try container.decode(String.self, forKey: .meetingName)
        raceNumber = try container.decode(Int.self, forKey: .raceNumber)
        advertisedStart = try nestedContainer.decode(Int.self, forKey: .seconds)
        categoryID = try container.decode(String.self, forKey: .categoryID)
        
    }
}
