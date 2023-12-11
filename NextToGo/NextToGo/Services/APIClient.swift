//
//  APIClient.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

protocol NextRacesFetching {
    func fetchNextRaces() async throws -> [Race]
}

protocol URLSessionProtocol {
    func data(
        from url: URL,
        delegate: (URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
}

extension URLSession : URLSessionProtocol{}

struct APIClient: NextRacesFetching {
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    /**
     HTTP Get method to get a list of next to go races. The default count is 10.
     
     - Returns: a list of 10 next to go races.
     
     */
    func fetchNextRaces() async throws -> [Race] {
        guard let url = APIEndpoint.endpointURL(for: .nextRaces) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await session.data(from: url, delegate: nil)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        do {
            let nextRacesResponse = try JSONDecoder().decode(NextRacesResponse.self, from: data)
            return nextRacesResponse.data.nextToGoIds
                .compactMap { nextRacesResponse.data.raceSummaries[$0] }
                .compactMap { Race(summary: $0) }
        } catch {
            throw NetworkError.decodingError
        }
    }
    
}
