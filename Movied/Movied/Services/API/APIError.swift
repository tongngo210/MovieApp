import Foundation

enum APIError: String, Error {
    case invalidURL = "Something bad happened with your URL"
    case unableToRequest = "Unable to complete the request"
    case invalidResponse = "Something bad happened with your Response"
    case unsafeData = "Your data is not safe"
    case invalidData = "Something bad happened with your Data"
}
