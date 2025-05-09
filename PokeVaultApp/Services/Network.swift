//
//  Network.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import Foundation


// MARK: - API Client Protocol
protocol APIClient {
    func fetchData(_ url: URL) async throws -> (data: Data, response: URLResponse)
    func validateHTTPResponse(with dataTaskResult: (data: Data, response: URLResponse)) throws -> Data
    func fetch<T: Decodable>(url: URL, as type: T.Type) async throws -> T
}

// MARK: - Network Client
class NetworkClient: APIClient {
    /**
     An enumeration representing common HTTP error cases encountered during network requests.

     This enum conforms to both `Error` and `LocalizedError` so it can be thrown and provide
     user-friendly error descriptions. It encapsulates various HTTP error conditions:
     
     - `badRequest`: Represents a 400 status code, indicating that the request was malformed.
     - `unauthorized`: Represents a 401 status code, indicating that access is unauthorized.
     - `notFound`: Represents a 404 status code, meaning the requested resource does not exist.
     - `invalidResponse(Data)`: Indicates that the URL response could not be cast to an HTTPURLResponse.
       The associated `Data` is returned for debugging purposes.
     - `http(response: HTTPURLResponse, data: Data)`: Captures all other non-success HTTP status codes,
       providing both the `HTTPURLResponse` and the associated `Data` for further error handling.

     The computed property `errorDescription` provides a localized description for each error case.
     */
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
    
    /**
     A private URLSession instance configured with custom timeout intervals.

     This session is created using a closure that configures a `URLSessionConfiguration` with default settings,
     and then adjusts the following properties:
     - `timeoutIntervalForRequest`: 15 seconds, defining the maximum time a request should take before timing out.
     - `timeoutIntervalForResource`: 30 seconds, defining the maximum time a resource request should persist.

     The configured session is used throughout the network client to perform asynchronous data tasks.
     */
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    /// Fetches data from a given URL asynchronously using `URLSession`.
    /// - Parameters:
    ///   - url: The `URL` from which data needs to be fetched.
    ///   - completion: A closure that gets called upon completion of the data task.
    ///     It returns a `Result<Data, Error>`:
    ///     - `.success(Data)`: Contains the fetched `Data` if the request is successful.
    ///     - `.failure(Error)`: Contains an `Error` if there is an issue with the network request or fetching data.
    func fetchData(_ url: URL) async throws -> (data: Data, response: URLResponse) {
        return try await session.data(from: url)
    }
    
    /**
     Validates the HTTP response returned from a data task and returns the valid data.

     This method checks that the provided URLResponse is an HTTPURLResponse. It then verifies the status code:
     - If the status code is in the 200–299 range, the data is considered valid and is returned.
     - Otherwise, it compares the status code against a mapping of known HTTP errors. If a match is found, that error is thrown.
     - If the status code does not match any known errors, a generic HTTP error is thrown including the response and data.

     - Parameter dataTaskResult: A tuple containing the raw data and URLResponse obtained from an asynchronous URLSession data task.
     - Returns: The data if the HTTP response indicates a successful request (status code in the 200–299 range).
     - Throws:
       - `.invalidResponse(data)`, if the response cannot be cast as an HTTPURLResponse.
       - A specific HTTPError defined in the `statusCodeMapping` if the status code is 400, 401, or 404.
       - `.http(response:data)`, if the HTTP status code is outside the 200–299 range and not specifically mapped.
     */
    func validateHTTPResponse(with dataTaskResult: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = dataTaskResult.response as? HTTPURLResponse else {
            throw NetworkClient.HTTPError.invalidResponse(dataTaskResult.data)
        }
        
        let statusCodeMapping: [Int: NetworkClient.HTTPError] = [
            400: .badRequest,
            401: .unauthorized,
            404: .notFound
        ]
        
        if (200..<300).contains(httpResponse.statusCode) {
            return dataTaskResult.data
        }
        
        if let error = statusCodeMapping[httpResponse.statusCode] {
            throw error
        } else {
            throw NetworkClient.HTTPError.http(response: httpResponse, data: dataTaskResult.data)
        }
    }
    
    /// Generic fetch function to decode any Decodable type.
    ///  The fetch<T: Decodable>(url:as:) method lets you fetch and decode any model in one call.
    ///  HTTP errors are mapped and thrown consistently, reducing redundancy in your service code.
    func fetch<T: Decodable>(url: URL, as type: T.Type) async throws -> T {
        let dataTaskResult = try await fetchData(url)
        let validData = try validateHTTPResponse(with: dataTaskResult)
        return try JSONDecoder().decode(T.self, from: validData)
    }
}
