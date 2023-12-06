//
//  RaceType.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

enum RaceType: CaseIterable {
    case horse
    case harness
    case greyhound
    
    var image: String {
        switch self {
        case .horse:
            return "HorseRacing"
        case .harness:
            return "HarnessRacing"
        case .greyhound:
            return "GreyhoundRacing"
        }
    }
}
