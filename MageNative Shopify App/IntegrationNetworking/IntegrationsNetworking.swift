//
//  StampedNetworking.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class IntegrationsNetworking {
    var baseURL: String {
            if customAppSettings.sharedInstance.isKangarooRewardsEnabled {
                return "https://api.kangaroorewards.com/"
            }
            else if customAppSettings.sharedInstance.isFeraReviewsEnabled {
                return "https://api.fera.ai/v3/private/reviews"
            }
            else if customAppSettings.sharedInstance.growaveRewardsIntegration || customAppSettings.sharedInstance.isGrowaveWishlist || customAppSettings.sharedInstance.isGrowaveReviewsIntegration {
                return "https://api.growave.io/api/"
            }
            else if customAppSettings.sharedInstance.isSimplyOTPEnabled {
                return "https://omqkhavcch.execute-api.ap-south-1.amazonaws.com/simplyotplogin/v5/"
            }
            else {
                return ""
            }
        }
    
    
    static let shared = IntegrationsNetworking()
    
    private init() {}
    
    @discardableResult
    func send<T: Requestables>(_ request: T, closure: @escaping (RequestsResult<T.Response, Error>) -> Void) -> URLSessionDataTask? {
        
        let urlRequest = request.buildURLRequest()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, rawResponse, error) in
            
            // If the dataTask error is occured.
            if let error = error {
                closure(.failed(ResponseErrors.unexpectedResponse(error)))
                return
            }
            
            let statusCode = (rawResponse as? HTTPURLResponse)?.statusCode ?? -1
            
            // Decodable must have data length at least.
            guard let data = data else {
                closure(.failed(ResponseErrors.unexpectedResponse("Error: The API response is empty.")))
                return
            }
            
            let isValidStatusCode = (200...299) ~= statusCode
            
            if isValidStatusCode && request.isNoContent {
                closure(.success(true as! T.Response))
                return
            }
            
//            if !isValidStatusCode {
//                closure(.failed(ResponseError.unacceptableStatusCode(statusCode)))
//                return
//            }
            
            // Decoding the response from `data` and handle DecodingError if occured.
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.Response.self, from: data)
                closure(.success(result))
                
            } catch DecodingError.keyNotFound(let codingKey, let context) {
                closure(.failed(DecodingError.keyNotFound(codingKey, context)))
            } catch DecodingError.typeMismatch(let type, let context) {
                closure(.failed(DecodingError.typeMismatch(type, context)))
            } catch DecodingError.valueNotFound(let type, let context) {
                closure(.failed(DecodingError.valueNotFound(type, context)))
            } catch DecodingError.dataCorrupted(let context) {
                closure(.failed(DecodingError.dataCorrupted(context)))
            } catch {
                closure(.failed(ResponseErrors.unexpectedResponse(data)))
            }
        }
        task.resume()
        return task
    }
}
