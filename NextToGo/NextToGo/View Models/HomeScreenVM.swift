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
    
    var activeRaceList: [Race] = []
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var showAlert = false
    var errorMessage = ""
    var filters: Set<Race.Category> = [.horse, .greyhound, .harness]
    
    ///sorted the active race list in ascending order
    var sortedRaceList: [Race] {
        activeRaceList.sorted { $0.remainingSeconds < $1.remainingSeconds }
    }
    
    ///an active race list that is sorted in ascending with category filters applied
    var sortedNfilteredRaceList: [Race] {
        sortedRaceList.filter { filters.contains($0.category) }
    }
    
    /**
     By calling this function, fetchNextRaces within the APIClient will be fired and the result will be published to the race list.
     The resulting race list applies one filter to exclude the races that are more than 1 min old from its advertised start time.
     Any throws will be reflect to the error message, and therefore presented in the home screen.
     */
    func fetchNextRaces() async {
        errorMessage = ""
        do {
            let raceList = try await apiClient.fetchNextRaces()
            activeRaceList = raceList.filter{ $0.remainingSeconds > -60 }
        } catch {
            //TODO: error handling
            errorMessage = "Something went wrong"
        }
    }
    
    /**
     Call this function to update the category filter selection so that the filter is applied to the displayed race list.
     
     - Parameter category: the race category in the filter to be updated.
     - Parameter selected: a boolean value to indicate whether the category is selected or unselcted.
     
     */
    func updateFilter(_ category: Race.Category, selected: Bool) {
        if selected {
            filters.insert(category)
        } else {
            filters.remove(category)
        }
    }
    
    /**
     This function is used to display the list of race depending on whether the filter selections are all deselected.
     
     - Returns: If all filters are deselected, return the last 5 items in the sorted race list.
                Otherwise return the first 5 items in the sorted list with filters applied .
     
     */
    func renderRaceList() -> [Race] {
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
    func countdown() {
        var updatedRaceList = activeRaceList.map { race in
            Race(
                raceId: race.raceId,
                meetingName: race.meetingName,
                raceNumber: race.raceNumber,
                remainingSeconds: race.remainingSeconds - 1,
                category: race.category
            )
        }
        ///prevent two races that have same time remaing so that the fetch method is not called twice
        updatedRaceList.removeAll { $0.remainingSeconds <= -60 }
        activeRaceList = updatedRaceList
    }
    
    func autoRefresh() {
        Task {
            await fetchNextRaces()
        }
    }
    
    /**
     Call this function to format the remaing seconds of a race into HR MIN SEC format.
     Only show the hour component when more than 1 hour equivalent seconds remaining.
     
     - Parameter seconds: the remaing seconds of a next to go race.
     
     */
    func formatted(_ seconds: Int) -> String {
        let hour =  seconds / 3600
        let minute = (seconds % 3600) / 60
        let second = (seconds % 3600) % 60
        var formattedString = ""
        if hour > 0 { formattedString += "\(hour)h" }
        if minute != 0 { formattedString += " \(minute)m" }
        formattedString += " \(second)s"
        return formattedString.trimmingCharacters(in: .whitespaces)
    }
}
