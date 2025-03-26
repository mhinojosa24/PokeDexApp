//
//  Network.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import Foundation


// MARK: - API Client Protocol
protocol APIClient {
    func fetchData(_ url: URL) async throws -> (Data, URLResponse)
    func parseHTTPResponse(response: (data: Data, response: URLResponse)) throws -> Data
}

// MARK: - Network Client
class NetworkClient: APIClient {
    enum HTTPError: Error, LocalizedError {
        case badRequest
        case unauthorized
        case notFound
        case invalidResponse(Data)
        case http(response: HTTPURLResponse, data: Data)
        
        var errorDescription: String? {
            switch self {
            case .badRequest: return "Bad request"
            case .unauthorized: return "Unauthorized access"
            case .notFound: return "Resource not found"
            case .http(
                let response,
                _
            ): return "HTTP error with status code \(response.statusCode)"
            default: return "An error occurred."
            }
        }
    }
    
    /// Fetches data from a given URL asynchronously using `URLSession`.
    /// - Parameters:
    ///   - url: The `URL` from which data needs to be fetched.
    ///   - completion: A closure that gets called upon completion of the data task.
    ///     It returns a `Result<Data, Error>`:
    ///     - `.success(Data)`: Contains the fetched `Data` if the request is successful.
    ///     - `.failure(Error)`: Contains an `Error` if there is an issue with the network request or fetching data.
    func fetchData(_ url: URL) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(from: url)
    }
    
    func parseHTTPResponse(response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            throw NetworkClient.HTTPError.invalidResponse(response.data)
        }
        
        let statusCodeMapping: [Int: NetworkClient.HTTPError] = [
            400: .badRequest,
            401: .unauthorized,
            404: .notFound
        ]
        
        if (200..<300).contains(httpResponse.statusCode) {
            return response.data
        }
        
        if let error = statusCodeMapping[httpResponse.statusCode] {
            throw error
        } else {
            throw NetworkClient.HTTPError
                .http(response: httpResponse, data: response.data)
        }
    }
}
