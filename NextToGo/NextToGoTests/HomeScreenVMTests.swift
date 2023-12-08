//
//  HomeScreenVMTests.swift
//  NextToGoTests
//
//  Created by Weiting Zhang on 12/7/23.
//

import XCTest

@testable import NextToGo

class MockAPIClient: NextRacesFetching {

    var isFetchNextRacesCalled = false
    
    func fetchNextRaces() async throws -> [Race] {
        isFetchNextRacesCalled = true
        return []
    }
}

final class HomeScreenVMTests: XCTestCase {
    
    private var homeScreenVM: HomeScreenVM!
    private var mockAPIClient: MockAPIClient!
    private var testRace1: Race!
    private var testRace2: Race!
    private var testRace3: Race!
    private var testRace4: Race!
    private var testRace5: Race!
    private var testRace6: Race!
    private var testRace7: Race!
    private var testRace8: Race!
    private var testRace9: Race!
    private var testRace10: Race!

    override func setUpWithError() throws {
        mockAPIClient = MockAPIClient()
        homeScreenVM = HomeScreenVM(apiClient: mockAPIClient)
        testRace1 = Race(raceId: "1", meetingName: "name1", raceNumber: 1, remainingSeconds: -10, category: .horse)
        testRace2 = Race(raceId: "2", meetingName: "name2", raceNumber: 2, remainingSeconds: -9, category: .horse)
        testRace3 = Race(raceId: "3", meetingName: "name3", raceNumber: 3, remainingSeconds: -8, category: .horse)
        testRace4 = Race(raceId: "4", meetingName: "name4", raceNumber: 4, remainingSeconds: -7, category: .harness)
        testRace5 = Race(raceId: "5", meetingName: "name5", raceNumber: 5, remainingSeconds: 0, category: .harness)
        testRace6 = Race(raceId: "6", meetingName: "name6", raceNumber: 6, remainingSeconds: 1, category: .harness)
        testRace7 = Race(raceId: "7", meetingName: "name7", raceNumber: 7, remainingSeconds: 2, category: .harness)
        testRace8 = Race(raceId: "8", meetingName: "name8", raceNumber: 8, remainingSeconds: 3, category: .greyhound)
        testRace9 = Race(raceId: "9", meetingName: "name9", raceNumber: 9, remainingSeconds: 4, category: .greyhound)
        testRace10 = Race(raceId: "10", meetingName: "name10", raceNumber: 10, remainingSeconds: -60, category: .greyhound)
    }

    override func tearDownWithError() throws {
        homeScreenVM = nil
        testRace1 = nil
        testRace2 = nil
        testRace3 = nil
    }
    
    func testCountdown() {
        
        homeScreenVM.raceList = [testRace1, testRace2, testRace3]
        homeScreenVM.countdown()
        
        let expectedRace1 = Race(raceId: "1", meetingName: "name1", raceNumber: 1, remainingSeconds: -11, category: .horse)
        let expectedRace2 = Race(raceId: "2", meetingName: "name2", raceNumber: 2, remainingSeconds: -10, category: .horse)
        let expectedRace3 = Race(raceId: "3", meetingName: "name3", raceNumber: 3, remainingSeconds: -9, category: .horse)
        
        XCTAssertEqual(homeScreenVM.raceList, [expectedRace1, expectedRace2, expectedRace3])
        
        
        homeScreenVM.raceList = [testRace10]
        homeScreenVM.countdown()
        XCTAssertEqual(homeScreenVM.raceList, [])
    }

    func testRenderedList() {
        homeScreenVM.raceList = [testRace1, testRace2, testRace3, testRace4, testRace5, testRace6, testRace7, testRace8, testRace9, testRace10]
        
        homeScreenVM.filters = [.horse, .greyhound, .harness]
        let renderedList1 = homeScreenVM.renderedList()
        XCTAssertEqual(renderedList1, [testRace3, testRace6, testRace9, testRace2, testRace5])
        
        homeScreenVM.filters = [.horse, .greyhound]
        let renderedList2 = homeScreenVM.renderedList()
        XCTAssertEqual(renderedList2, [testRace3, testRace9, testRace2, testRace8, testRace1])
        
        homeScreenVM.filters = []
        let renderedList3 = homeScreenVM.renderedList()
        XCTAssertEqual(renderedList3, [testRace8, testRace1, testRace4, testRace7, testRace10])
       
    }
    
    func testUpdateFilters() {
        homeScreenVM.filters = [.horse, .greyhound, .harness]
        
        homeScreenVM.updateFilters(race: .horse, selected: false)
        XCTAssertFalse(homeScreenVM.sortedNfilteredRaceList.contains{$0.category == .horse})
    }
    
}
