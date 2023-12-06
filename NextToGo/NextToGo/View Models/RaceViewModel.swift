//
//  RaceViewModel.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/7/23.
//

import Foundation

class RaceViewModel: Identifiable {
    
    private var race : Race
    let meetingName: String
    let raceNumber: String
    var countdown: Int
    
    init(race: Race) {
        self.race = race
        self.countdown = race.advertisedStart
        self.meetingName = race.meetingName
        self.raceNumber = "\(race.raceNumber)"
    }
    
    var raceType: RaceType {
        if race.categoryID == RaceCategoryID.greyhound {
            return .greyhound
        } else if race.categoryID == RaceCategoryID.harness {
            return .harness
        } else if race.categoryID == RaceCategoryID.horse {
            return .horse
        } else {
            //TODO: add an invalid case for error handling
            return .horse
        }
    }
    
    var countdownDisplay: String {
        let hms = convertSecondsToHMS(countdown)
        var result = ""
        if hms.0 >= 0 {
            result += "\(hms.0)h"
        }
        if hms.1 >= 0 {
            result += " \(hms.1)m"
        }
        result += " \(hms.2)s"
        return result
    }
    
    //MARK: - Helper Functions
    func convertSecondsToHMS(_ seconds: Int) -> (Int, Int, Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = (seconds % 3600) % 60
        return (hours, minutes, remainingSeconds)
    }
    
    
}
