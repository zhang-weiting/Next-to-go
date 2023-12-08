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
    
    private let apiClient: NextRacesFetching
    
    init(apiClient: NextRacesFetching) {
        self.apiClient = apiClient
    }
    
    var raceList: [Race] = []
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var showAlert = false
    var errorMessage = ""
    var filters: Set<Race.Category> = [.horse, .greyhound, .harness]
    
    ///sorted race list in ascending order
    var sortedRaceList: [Race] {
        raceList.sorted { $0.remainingSeconds < $1.remainingSeconds }
    }
    
    ///filter race list in to exclude the races that are more than 1 min old
    var filteredRaceList: [Race] {
        raceList.filter{ $0.remainingSeconds > -59 }
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
    func countdown(current: Date = Date()) {
        var updateRaceList = [Race]()
        for race in filteredRaceList {
            let newRace = Race(
                raceId: race.raceId,
                meetingName: race.meetingName,
                raceNumber: race.raceNumber,
                remainingSeconds: race.remainingSeconds - 1,
                category: race.category
            )
            if newRace.remainingSeconds < -59 {
                let index = raceList.firstIndex{ $0 == race }
                if let index = index {
                    raceList.remove(at: index)
                }
                Task {
                    await fetchNextRaces()
                }
            } else {
                updateRaceList.append(newRace)
            }
        }
        raceList = updateRaceList
    }
    
    func formatted(_ seconds: Int) -> String {
        let hour =  seconds / 3600
        let minute = (seconds % 3600) / 60
        let second = (seconds % 3600) % 60
        var formattedString = ""
        if hour > 0 {
            formattedString += "\(hour)h"
        }
        if minute != 0 {
            formattedString += " \(minute)m"
        }
        formattedString += " \(second)s"
        return formattedString
    }
}
