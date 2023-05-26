//
//  GrowaveViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 07/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveReviewsViewModel: NSObject {
    var allReview = [GrowaveAllReviewsData]()
    let tokenHandler = GrowaveTokenHandler()
    var productRatingCount = "N/A"
    var productRating = ""
    
    func fetchAllReviews(product_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            if let safeToken = token {
                let request = AllReviewsRequest(product_id: product_id, token: safeToken)
                IntegrationsNetworking.shared.send(request) {[weak self] result in
                    switch result {
                    case .success(let result):
                        if let reviews = result.data {
                            self?.allReview = reviews
                        }
                        completion(.success(true))
                        
                    case .failed(let error):
                        let err = (String (describing: error))
                        print("DEBUG: All reviews error \(err)")
                        completion(.failed(err))
                    }
                }
            }
            
        }
    }
    
    func growaveProductScoreRequest(product_ids: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            if let safeToken = token {
                let request = GrowaveProductScoreRequest(product_id: product_ids, token: safeToken)
                IntegrationsNetworking.shared.send(request) {[weak self] result in
                    switch result {
                    case .success(let result):
                        if let rating = result.data?.first?.averageRate, let count = result.data?.first?.reviewsCount {
                            self?.productRatingCount = count
                            self?.productRating = rating
                        }
                        completion(.success(true))
                    case .failed(let error):
                        let err = (String (describing: error))
                        print("DEBUG: All reviews error \(err)")
                        completion(.failed(err))
                    }
                }
            }
        }
    }
    
    func growavePostReview(email: String, name: String, product_id: String, title: String, body: String, rate: Int, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            if let safeToken = token {
                let request = GrowaveProductReviewRequest(email: email, name: name, product_id: product_id, review_body: body, title: title, rate: rate, token: safeToken)
                IntegrationsNetworking.shared.send(request) {[weak self] result in
                    switch result {
                    case .success(let result):
                        if let message = result.message {
                            if message == "OK" {
                                completion(.success(true))
                            }
                        }
                        
                        
                    case .failed(let error):
                        let err = (String (describing: error))
                        print("DEBUG: All reviews error \(err)")
                        completion(.failed(err))
                    }
                }
            }
        }
    }
    
}
