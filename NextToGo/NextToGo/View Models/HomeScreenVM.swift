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
    
    var raceList: [Race] = []
    private let apiClient: NextRacesFetching
    
    init(apiClient: NextRacesFetching) {
        self.apiClient = apiClient
    }
    
    var showAlert = false
    var errorMessage = ""
    var filters: Set<Race.Category> = [.horse, .greyhound, .harness]
    
    ///sorted race list in ascending order
    var sortedRaceList: [Race] {
        raceList.sorted { $0.advertisedStart < $1.advertisedStart }
    }
    
    ///a sorted race list with category filters applied
    var sortedNfilteredRaceList: [Race] {
        sortedRaceList.filter { filters.contains($0.category) }
    }
    
    /**
     By calling function, fetchNextRaces within the APIClient will be called and the result will be published to the race list.
     Any throws will be reflect to the error message, and therefore presented in the home screen.
     */
    func fetchNextRaces() async {
        errorMessage = ""
        do {
            raceList = try await apiClient.fetchNextRaces()
        } catch {
            //TODO: error handling
            errorMessage = "Something went wrong"
        }
    }
    
    ///call this function to update the category filter selection to update the displayed race list.
    func updateFilters(race: Race.Category, selected: Bool) {
        if selected {
            filters.insert(race)
        } else {
            filters.remove(race)
        }
    }
    
    /**
     This function is used to display the list of race depending on whether the filter selections are all deselected.
     
     - Returns: If all filters are deselected, return the last 5 items in the sorted list. Otherwise return the first 5 sorted and filtered races.
     
     */
    func renderedList() -> [Race] {
        if filters.isEmpty {
            return Array(sortedRaceList.suffix(5))
        } else {
            return Array(sortedNfilteredRaceList.prefix(5))
        }
    }
    
    /**
     This function will calculate the time remaining and return the formatted string to be used to display in UI.
     Also, it will observe if any race is 1 min pass the advertised start and reload the race list.
     
     - Parameters race: the Race to apply the countdown method.
     
     */
    func countdown(race: Race, current: Date = Date()) -> String {
        let time = Int(race.advertisedStart - current.timeIntervalSince1970)
        let hour =  time / 3600
        let minute = (time % 3600) / 60
        let second = (time % 3600) % 60
        
        var countdownDisplay = ""
        if hour > 0 {
            countdownDisplay += "\(hour)h"
        }
        if minute != 0 {
            countdownDisplay += " \(minute)m"
        }
        countdownDisplay += " \(second)s"
        if minute <= -1 {
            let index = raceList.firstIndex{ $0 == race }
            if let index = index {
                raceList.remove(at: index)
            }
            Task {
                await fetchNextRaces()
            }
            return ""
        }
        return countdownDisplay
    }
}
