//
//  Requestables.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

protocol Requestables {
    
    // The response of `Requestable` expects either JSON object or empty.
    associatedtype Response: Decodable

    // The base of URL.
    var baseURL: URL { get }

    // The path of URL.
    var path: String { get }

    // The header field of HTTP.
    var headerField: [String: String] { get }
    
    // If the request needs OAuth authorization, this will set `true`. The default value is `false`.
    var isAuthorizedRequest: Bool { get }
    
    // The http method. e.g. `.get`
    var httpMethod: HTTPsMethods { get }
    
    // The http body parameter, The default value is `nil`.
    var httpBody: Data? { get }
    
    // Additional query paramters for URL, The default value is `[:]`.
    var queryParameters: [String: Any] { get }
    
    // If the response is empty, this should be true.
    var isNoContent: Bool { get }
}
extension Requestables {
    
    var baseURL: URL {
        return URL(string: IntegrationsNetworking.shared.baseURL)!
    }
    
    var queryParameters: [String: Any] {
        return [:]
    }
    
    var headerField: [String: String] {
        return [:]
    }
    
    var isAuthorizedRequest: Bool {
        return false
    }
    
    var httpBody: Data? {
        return nil
    }
    
    var isNoContent: Bool {
        return false
    }
    
    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var urlRequest = URLRequest(url: url)
        var header: [String: String] = headerField

        urlRequest.httpMethod = httpMethod.rawValue
        
        // Set custom header filed if the request needs authorization.
//        if isAuthorizedRequest {
//            header["Authorization"] = "Bearer \(UserDefaults.accessToken)"
//        }
        
        header.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let body = httpBody {
            urlRequest.httpBody = body
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return urlRequest
        }
        
        urlComponents.query = queryParameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        urlRequest.url = urlComponents.url
        return urlRequest
    }
}


extension URLRequest {
    
    /**
     Returns a cURL command representation of this URL request.
     */
    public var asCURL: String {
        guard let url = url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }

}
