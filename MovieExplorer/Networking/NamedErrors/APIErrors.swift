//
//  APIErrors.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 23/06/25.
//
import UIKit

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case noInternet
    case serverError(code: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Error Resolving the Service" //invalid URL
        case .noData: return "No Data Found"
        case .decodingError: return "Recived Invalid or Corrupt Data."
        case .noInternet: return "No Internet Available."
        case .serverError(let code): return "Server Error, code:  \(code)."
        }
    }
}
