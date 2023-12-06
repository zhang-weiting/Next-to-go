//
//  APIClient.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

struct APIClient {
    
    /**
     HTTP Get method to get a list of next to go races by count.
     
     - Parameter count: number of next to go races to be included in the response.
     
     - Returns: a list of next to go races.
     
     */
    func nextRacesByCount(_ count: Int) async throws-> [Race] {
        guard let url = APIEndpoint.endpointURL(for: .nextRacesByCount(count)) else {
            throw NetworkError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let nextRacesResponse = try JSONDecoder().decode(NextRacesResponse.self, from: data)
            return nextRacesResponse.races
        } catch {
            throw NetworkError.decodingError
        }
    }
    
}
