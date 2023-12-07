//
//  HomeScreenVMTests.swift
//  NextToGoTests
//
//  Created by Weiting Zhang on 12/7/23.
//

import XCTest

@testable import NextToGo

final class HomeScreenVMTests: XCTestCase {
    
    private var homeScreenVM: HomeScreenVM!
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
        homeScreenVM = HomeScreenVM(apiClient: APIClient())
        testRace1 = Race(raceId: "1", meetingName: "name1", raceNumber: 1, advertisedStart: 1701954180, category: .horse)
        testRace2 = Race(raceId: "2", meetingName: "name2", raceNumber: 2, advertisedStart: 1701953820, category: .horse)
        testRace3 = Race(raceId: "3", meetingName: "name3", raceNumber: 3, advertisedStart: 1701953520, category: .horse)
        testRace4 = Race(raceId: "4", meetingName: "name4", raceNumber: 4, advertisedStart: 1701954181, category: .harness)
        testRace5 = Race(raceId: "5", meetingName: "name5", raceNumber: 5, advertisedStart: 1701953822, category: .harness)
        testRace6 = Race(raceId: "6", meetingName: "name6", raceNumber: 6, advertisedStart: 1701953523, category: .harness)
        testRace7 = Race(raceId: "7", meetingName: "name7", raceNumber: 7, advertisedStart: 1701954184, category: .harness)
        testRace8 = Race(raceId: "8", meetingName: "name8", raceNumber: 8, advertisedStart: 1701953825, category: .greyhound)
        testRace9 = Race(raceId: "9", meetingName: "name9", raceNumber: 9, advertisedStart: 1701953526, category: .greyhound)
        testRace10 = Race(raceId: "10", meetingName: "name10", raceNumber: 10, advertisedStart: 1701954187, category: .greyhound)
    }

    override func tearDownWithError() throws {
        homeScreenVM = nil
        testRace1 = nil
        testRace2 = nil
        testRace3 = nil
    }
    
    func testCountdown() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        guard let relativeDate1 = formatter.date(from: "2023/12/07 23:30") else {
            return
        }
        
        let countdownDisplay1 = homeScreenVM.countdown(race: testRace1, current: relativeDate1)
        let countdownDisplay2 = homeScreenVM.countdown(race: testRace2, current: relativeDate1)
        let countdownDisplay3 = homeScreenVM.countdown(race: testRace3, current: relativeDate1)
        
        XCTAssertEqual(countdownDisplay1, " 33m 0s")
        XCTAssertEqual(countdownDisplay2, " 27m 0s")
        XCTAssertEqual(countdownDisplay3, " 22m 0s")
        
        homeScreenVM.raceList = [testRace1, testRace2, testRace3]
        guard let relativeDate2 = formatter.date(from: "2023/12/08 00:10") else {
            return
        }
        
        let _ = homeScreenVM.countdown(race: testRace1, current: relativeDate2)
        XCTAssertEqual(homeScreenVM.raceList, [testRace2, testRace3])
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
    
    //TODO: create mock URLSession
}
