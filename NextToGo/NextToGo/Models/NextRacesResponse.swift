//
//  NextRacesResponse.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation


struct NextRacesResponse: Decodable {
    let status: Int
    let data: Data
}

extension NextRacesResponse {
    struct Data: Decodable {
        let nextToGoIds: [String]
        let raceSummaries: [String: RaceSummary]
        
        enum CodingKeys: String, CodingKey {
            case nextToGoIds = "next_to_go_ids"
            case raceSummaries = "race_summaries"
        }
    }
}

extension NextRacesResponse.Data {
    struct RaceSummary: Decodable {
        let raceId: String
        let raceNumber: Int
        let meetingName: String
        let advertisedStart: AdvertisedStart
        let categoryId: String
        
        enum CodingKeys: String, CodingKey {
            case raceId = "race_id"
            case raceNumber = "race_number"
            case meetingName = "meeting_name"
            case advertisedStart = "advertised_start"
            case categoryId = "category_id"
        }
    }
}

extension NextRacesResponse.Data.RaceSummary {
    struct AdvertisedStart: Decodable {
        let seconds: Double
    }
}

extension Race {
    init(summary: NextRacesResponse.Data.RaceSummary) {
        let raceId = summary.raceId
        let raceNumber = summary.raceNumber
        let meetingName = summary.meetingName
        let advertisedStart = summary.advertisedStart.seconds
        let remainingSeconds = Int(advertisedStart - Date().timeIntervalSince1970)
        let category = Category(rawValue:summary.categoryId) ?? .horse

        self.init(raceId: raceId, meetingName: meetingName, raceNumber: raceNumber, remainingSeconds: remainingSeconds, category: category)
    }
}
