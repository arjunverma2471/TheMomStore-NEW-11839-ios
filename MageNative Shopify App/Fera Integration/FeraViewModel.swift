//
//  FeraViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 14/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class FeraViewModel: NSObject {
    var reviewsList = [FeraProductReviewsData]()
    var productRatingCount = 0.0
    var productRating = 0.0
    func createFeraCustomer(customerId: String, email: String, name: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        let request = FeraCreateCustomerRequest(external_id: customerId, email: email, name: name)
        IntegrationsNetworking.shared.send(request) { response in
            switch response {
            case .success(let result):
                completion(.success(true))
            case .failed(let err):
                let err = (String (describing: err))
                completion(.failed(err))                                                                                                                                                                 
            }
        }
    }
    
    
    func feraProductScoreRequest(product_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        let request = FeraRatingRequest(productId: product_id)
        IntegrationsNetworking.shared.send(request) {[weak self] result in
            switch result {
            case .success(let result):
                if let count = result.count, let average = result.average {
                    self?.productRating  = average
                    self?.productRatingCount = count
                    
                }
                completion(.success(true))
            case .failed(let error):
                let err = (String (describing: error))
                print("DEBUG: feraProductScoreRequest error \(err)")
                completion(.failed(err))
            }
        }
    }
    
    func fetchFeraProductReviews(product_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        let request = FeraProductReviewsRequest(productId: product_id)
        IntegrationsNetworking.shared.send(request) {[weak self] result in
            switch result {
            case .success(let result):
                if let reviews = result.data {
                    self?.reviewsList = reviews
                }
                completion(.success(true))
            case .failed(let error):
                let err = (String (describing: error))
                print("DEBUG: feraProductScoreRequest error \(err)")
                completion(.failed(err))
            }
        }
    }
    
    func feraPostReviewRequest(name: String, email: String, rating: String, heading: String, reviewBody: String, external_product_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        let request = FeraPostReviewRequest(name: name, email: email, rating: rating, heading: heading, reviewBody: reviewBody, external_product_id: external_product_id)
        IntegrationsNetworking.shared.send(request) {[weak self] result in
            switch result {
            case .success(let result):
                print(result)
                if let _ = result.id {
                    self?.reviewsList = [FeraProductReviewsData]()
                    completion(.success(true))
                }
                else {
                    completion(.failed("You have already posted a review for this product."))
                }
            case .failed(let error):
                let err = (String (describing: error))
                print("DEBUG: feraPostReviewRequest error \(err)")
                completion(.failed(err))                     
            }
        }
    }
}
