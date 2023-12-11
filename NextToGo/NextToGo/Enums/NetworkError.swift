//
//  NetworkError.swift
//  NextToGo
//
//  Created by Weiting Zhang on 12/6/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
}
