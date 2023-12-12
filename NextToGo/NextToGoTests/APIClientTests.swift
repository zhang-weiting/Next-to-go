//
//  APIClientTests.swift
//  NextToGoTests
//
//  Created by Weiting Zhang on 12/11/23.
//

import XCTest

@testable import NextToGo

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    var isDataFromUrlCalled = false
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        } else if let data = data,
                  let response = response {
            return (data, response)
        } else {
            throw NetworkError.invalidResponse
        }
    }
}



final class APIClientTests: XCTestCase {
    
    private var mockURLSession: MockURLSession!
    private var mockAPIClient: APIClient!
    
    override func setUpWithError() throws {
        mockURLSession = MockURLSession(data: nil, response: nil, error: nil)
        mockAPIClient = APIClient(session: mockURLSession)
    }
    
    override func tearDownWithError() throws {
        mockURLSession = nil
        mockAPIClient = nil
    }
    
    func testFetchNextRacesInvalidResponse() async throws {
        let response = HTTPURLResponse(url: APIEndpoint.endpointURL(for: .nextRaces)!, statusCode: 400, httpVersion: nil, headerFields: nil)
        mockURLSession = MockURLSession(data: nil, response: response, error: nil)
        mockAPIClient = APIClient(session: mockURLSession)
        do {
            _ = try await mockAPIClient.fetchNextRaces()
            XCTFail("Expected throws but got success")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse)
        }
    }
    
    func testFetchNextRacesNoData() async throws {
        let response = HTTPURLResponse(url: APIEndpoint.endpointURL(for: .nextRaces)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession = MockURLSession(data: Data(), response: response, error: nil)
        mockAPIClient = APIClient(session: mockURLSession)
        do {
            _ = try await mockAPIClient.fetchNextRaces()
            XCTFail("Expected throws but got success")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.noData)
        }
    }
    
    func testFetchNextRacesDecodingError() async throws {
        let response = HTTPURLResponse(url: APIEndpoint.endpointURL(for: .nextRaces)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let badData =
        """
        bad data
        """.data(using: .utf8)
        mockURLSession = MockURLSession(data: badData, response: response, error: nil)
        mockAPIClient = APIClient(session: mockURLSession)
        do {
            _ = try await mockAPIClient.fetchNextRaces()
            XCTFail("Expected throws but got success")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.decodingError)
        }
    }
    
    func testFetchNextRacesSuccess() async throws {
        let response = HTTPURLResponse(url: APIEndpoint.endpointURL(for: .nextRaces)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data =
        """
        {
           "status":200,
           "data":{
              "next_to_go_ids":[
                 "09ea0f04-a207-4986-b5dd-1f4cb102126f"
              ],
              "race_summaries":{
                 "09ea0f04-a207-4986-b5dd-1f4cb102126f":{
                    "race_id":"09ea0f04-a207-4986-b5dd-1f4cb102126f",
                    "race_number":5,
                    "meeting_name":"Kasamatsu",
                    "category_id":"4a2788f8-e825-4d36-9894-efd4baf1cfae",
                    "advertised_start":{
                       "seconds":1702267800
                    },
                    "venue_id":"ee67caf8-e6db-4086-b31a-91bd79c8d8cd",
                    "venue_name":"Kasamatsu",
                    "venue_state":"JPN",
                    "venue_country":"JPN"
                 }
              }
           }
        }
        """.data(using: .utf8)
        mockURLSession = MockURLSession(data: data, response: response, error: nil)
        mockAPIClient = APIClient(session: mockURLSession)
        do {
            let list = try await mockAPIClient.fetchNextRaces()
            let expectedRace = Race(
                raceId: "09ea0f04-a207-4986-b5dd-1f4cb102126f",
                meetingName: "Kasamatsu",
                raceNumber: 5,
                remainingSeconds: Int(1702267800 - Date().timeIntervalSince1970), //an alternative way to test without using reference date
                category: .horse
            )
            XCTAssertEqual(list, [expectedRace])
        } catch {
            XCTFail("Expected success but got throws")
        }
    }
    
}
