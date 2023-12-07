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
    
    private var raceList: [Race] = []
    private let apiClient: NextRacesFetching
    
    init(apiClient: NextRacesFetching) {
        self.apiClient = apiClient
    }
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var errorMessage = ""
    var filters: Set<Race.Category> = [.horse, .greyhound, .harness]
    
    var sortedRaceList: [Race] {
        raceList.sorted { $0.advertisedStart < $1.advertisedStart }
    }
    
    var sortedNfilteredRaceList: [Race] {
        sortedRaceList.filter { filters.contains($0.category) }
    }
    
    func fetchNextRaces() async {
        do {
            raceList = try await apiClient.fetchNextRaces()
        } catch {
            //TODO: error handling
            errorMessage = "Something went wrong"
        }
    }
    
    func updateFilters(race: Race.Category, selected: Bool) {
        if selected {
            filters.insert(race)
        } else {
            filters.remove(race)
        }
    }
    
    func renderedList() -> [Race] {
        if filters.isEmpty {
            return Array(sortedRaceList.suffix(5))
        } else {
            return Array(sortedNfilteredRaceList.prefix(5))
        }
    }
    
}
