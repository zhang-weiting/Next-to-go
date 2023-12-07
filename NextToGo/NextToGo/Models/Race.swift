//
//  Race.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

struct Race {
    let raceId: String
    let meetingName: String
    let raceNumber: Int
    let advertisedStart: Double
    let category: Category
}


extension Race {
    enum Category: String, CaseIterable {
        case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
        case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
        case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"

        var description: String {
            switch self {
            case.horse: "Horse"
            case .greyhound: "Greyhound"
            case .harness: "Harness"
            }
        }
    }
}
