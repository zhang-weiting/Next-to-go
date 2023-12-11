//
//  HomeScreenVMTests.swift
//  NextToGoTests
//
//  Created by Weiting Zhang on 12/7/23.
//

import XCTest

@testable import NextToGo

class MockAPIClient: NextRacesFetching {
    
    var isFetchingNextRacesCalled = false
    
    func fetchNextRaces() async throws -> [Race] {
        isFetchingNextRacesCalled = true
        let testRace = Race(
            raceId: "11",
            meetingName: "name11",
            raceNumber: 11,
            remainingSeconds: 10,
            category: .horse
        )
        return [testRace]
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
        testRace1 = Race(raceId: "1", meetingName: "name1", raceNumber: 1, remainingSeconds: -132, category: .horse)
        testRace2 = Race(raceId: "2", meetingName: "name2", raceNumber: 2, remainingSeconds: -60, category: .horse)
        testRace3 = Race(raceId: "3", meetingName: "name3", raceNumber: 3, remainingSeconds: -8, category: .horse)
        testRace4 = Race(raceId: "4", meetingName: "name4", raceNumber: 4, remainingSeconds: -7, category: .harness)
        testRace5 = Race(raceId: "5", meetingName: "name5", raceNumber: 5, remainingSeconds: 0, category: .harness)
        testRace6 = Race(raceId: "6", meetingName: "name6", raceNumber: 6, remainingSeconds: 1, category: .harness)
        testRace7 = Race(raceId: "7", meetingName: "name7", raceNumber: 7, remainingSeconds: 2, category: .harness)
        testRace8 = Race(raceId: "8", meetingName: "name8", raceNumber: 8, remainingSeconds: 3, category: .greyhound)
        testRace9 = Race(raceId: "9", meetingName: "name9", raceNumber: 9, remainingSeconds: 60, category: .greyhound)
        testRace10 = Race(raceId: "10", meetingName: "name10", raceNumber: 10, remainingSeconds: 3601, category: .greyhound)
    }
    
    override func tearDownWithError() throws {
        homeScreenVM = nil
        testRace1 = nil
        testRace2 = nil
        testRace3 = nil
        testRace4 = nil
        testRace5 = nil
        testRace6 = nil
        testRace7 = nil
        testRace8 = nil
        testRace9 = nil
        testRace10 = nil
    }
    
    func testformatted() {
        let formatted1 = homeScreenVM.formatted(testRace1.remainingSeconds)
        let formatted2 = homeScreenVM.formatted(testRace2.remainingSeconds)
        let formatted3 = homeScreenVM.formatted(testRace3.remainingSeconds)
        let formatted4 = homeScreenVM.formatted(testRace4.remainingSeconds)
        let formatted5 = homeScreenVM.formatted(testRace5.remainingSeconds)
        let formatted6 = homeScreenVM.formatted(testRace6.remainingSeconds)
        let formatted7 = homeScreenVM.formatted(testRace7.remainingSeconds)
        let formatted8 = homeScreenVM.formatted(testRace8.remainingSeconds)
        let formatted9 = homeScreenVM.formatted(testRace9.remainingSeconds)
        let formatted10 = homeScreenVM.formatted(testRace10.remainingSeconds)
        
        XCTAssertEqual(formatted1, "-2m -12s")
        XCTAssertEqual(formatted2, "-1m 0s")
        XCTAssertEqual(formatted3, "-8s")
        XCTAssertEqual(formatted4, "-7s")
        XCTAssertEqual(formatted5, "0s")
        XCTAssertEqual(formatted6, "1s")
        XCTAssertEqual(formatted7, "2s")
        XCTAssertEqual(formatted8, "3s")
        XCTAssertEqual(formatted9, "1m 0s")
        XCTAssertEqual(formatted10, "1h 1s")
    }
    
    func testAutoRefresh() {
        // reset initial state
        mockAPIClient.isFetchingNextRacesCalled = false
        // verify initial state
        XCTAssertFalse(mockAPIClient.isFetchingNextRacesCalled)
        
        let expectation = XCTestExpectation(
            description: "fetch next to go races"
        )
        let asyncAwaitDuration = 0.5
        
        homeScreenVM.autoRefresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + asyncAwaitDuration) {
            expectation.fulfill()
            // verify state after
            XCTAssertTrue(self.mockAPIClient.isFetchingNextRacesCalled)
            XCTAssertEqual(self.homeScreenVM.activeRaceList, [Race(
                raceId: "11",
                meetingName: "name11",
                raceNumber: 11,
                remainingSeconds: 10,
                category: .horse
            )])
        }
        wait(for: [expectation], timeout: asyncAwaitDuration)
    }
    
    func testCountdown() {
        
        homeScreenVM.activeRaceList = [testRace2, testRace3, testRace4, testRace5, testRace6]
        XCTAssertEqual(homeScreenVM.activeRaceList.count, 5)
        
        homeScreenVM.countdown()
        let expectedRace3 = Race(raceId: "3", meetingName: "name3", raceNumber: 3, remainingSeconds: -9, category: .horse)
        let expectedRace4 = Race(raceId: "4", meetingName: "name4", raceNumber: 4, remainingSeconds: -8, category: .harness)
        let expectedRace5 = Race(raceId: "5", meetingName: "name5", raceNumber: 5, remainingSeconds: -1, category: .harness)
        let expectedRace6 = Race(raceId: "6", meetingName: "name6", raceNumber: 6, remainingSeconds: 0, category: .harness)
        XCTAssertEqual(homeScreenVM.activeRaceList.count, 4)
        XCTAssertEqual(homeScreenVM.activeRaceList, [expectedRace3, expectedRace4, expectedRace5, expectedRace6])
        
        
        homeScreenVM.activeRaceList = [testRace7, testRace8, testRace9, testRace10]
        XCTAssertEqual(homeScreenVM.activeRaceList.count, 4)
        
        homeScreenVM.countdown()
        let expectedRace7 = Race(raceId: "7", meetingName: "name7", raceNumber: 7, remainingSeconds: 1, category: .harness)
        let expectedRace8 = Race(raceId: "8", meetingName: "name8", raceNumber: 8, remainingSeconds: 2, category: .greyhound)
        let expectedRace9 = Race(raceId: "9", meetingName: "name9", raceNumber: 9, remainingSeconds: 59, category: .greyhound)
        let expectedRace10 = Race(raceId: "10", meetingName: "name10", raceNumber: 10, remainingSeconds: 3600, category: .greyhound)
        XCTAssertEqual(homeScreenVM.activeRaceList.count, 4)
        XCTAssertEqual(homeScreenVM.activeRaceList, [expectedRace7, expectedRace8, expectedRace9, expectedRace10])
    }
    
    func testRenderRaceList() {
        homeScreenVM.activeRaceList = [testRace2, testRace3, testRace4, testRace5, testRace6, testRace7, testRace8, testRace9, testRace10]
        
        homeScreenVM.filters = [.horse, .greyhound, .harness]
        let renderedList1 = homeScreenVM.renderRaceList()
        XCTAssertEqual(renderedList1, [testRace2, testRace3, testRace4, testRace5, testRace6])
        
        homeScreenVM.filters = [.horse, .greyhound]
        let renderedList2 = homeScreenVM.renderRaceList()
        XCTAssertEqual(renderedList2, [testRace2, testRace3, testRace8, testRace9, testRace10])
        
        homeScreenVM.filters = [.harness]
        let renderedList3 = homeScreenVM.renderRaceList()
        XCTAssertEqual(renderedList3, [testRace4, testRace5, testRace6, testRace7])
        
        homeScreenVM.filters = []
        let renderedList4 = homeScreenVM.renderRaceList()
        XCTAssertEqual(renderedList4, [testRace6, testRace7, testRace8, testRace9, testRace10])
    }
    
    func testUpdateFilter() {
        homeScreenVM.filters = [.horse, .greyhound, .harness]
        homeScreenVM.updateFilter(.horse, selected: false)
        XCTAssertEqual(homeScreenVM.filters, [.greyhound, .harness])
        XCTAssertFalse(homeScreenVM.sortedNfilteredRaceList.contains{$0.category == .horse})
        
        homeScreenVM.updateFilter(.harness, selected: false)
        XCTAssertEqual(homeScreenVM.filters, [.greyhound])
        XCTAssertFalse(homeScreenVM.sortedNfilteredRaceList.contains{ $0.category == .horse && $0.category == .greyhound })
        
        homeScreenVM.updateFilter(.harness, selected: true)
        XCTAssertEqual(homeScreenVM.filters, [.harness, .greyhound])
        XCTAssertFalse(homeScreenVM.sortedNfilteredRaceList.contains{ $0.category == .horse })
    }
    
    func testFetchNextRaces() async {
        // reset initial state
        mockAPIClient.isFetchingNextRacesCalled = false
        // verify initial state
        XCTAssertFalse(mockAPIClient.isFetchingNextRacesCalled)
        
        let expectation = XCTestExpectation(
            description: "fetch next to go races"
        )
        let asyncAwaitDuration = 0.5
        
        await homeScreenVM.fetchNextRaces()
        expectation.fulfill()
        XCTAssertTrue(self.mockAPIClient.isFetchingNextRacesCalled)
        await fulfillment(of: [expectation], timeout: asyncAwaitDuration)
    }
    
}
