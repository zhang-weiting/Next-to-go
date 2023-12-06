//
//  HomeScreenVM.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/7/23.
//

import Foundation
import Observation

@Observable
class HomeScreenVM {
    
    let apiClient = APIClient()
    var raceList : [RaceViewModel] = []
    var isFetching: Bool = false
    var errorMessage = ""
    var isHorseSelected = true
    var isHarnessSelected = true
    var isGreyhoundSelected = true
    var isCountdowning = false
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var sortedRaceList: [RaceViewModel] {
        raceList.sorted {
            $0.countdown < $1.countdown
        }
    }
    
    var filteredRaceList: [RaceViewModel] {
        sortedRaceList.filter { race in
            if (race.raceType == .greyhound && !isGreyhoundSelected) ||
                (race.raceType == .horse && !isHorseSelected) ||
                (race.raceType == .harness && !isHarnessSelected) {
                return false
            } else {
                return true
            }
        }
    }
    
    func fetchNextRacesByCount(_ count: Int) async {
        isFetching = true
        do {
            let races = try await apiClient.nextRacesByCount(count)
            raceList = races.map(RaceViewModel.init)
            isFetching = false
        } catch {
            errorMessage = "Something went wrong"
        }
    }
    
}
