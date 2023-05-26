//
//  KangarooRewardsViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class KangarooRewardsViewModel: NSObject {
    var userPoint: Int = 0
    var kangarooProfle: KanagrooCustomerData?
    var customerHistory: KangarooCustomerHistory?
    var customerRewards: KangarooCustomerRewards?
    var customerOffers: KangarooCustomerRewards?
    var coupon: KangarooOfferRedeemData?
    var customerConsent : KangarooGetCustomerConsentData?
    var tiers = [KangarooTiersData]()
    var pointsCoupon: KangarooPayWithPointsData?
    func generateTokenKangaroo(completion: @escaping (String?) -> Void){
        let params = ["grant_type": KangarooRewardsToken.grant_type,
                      "client_id": KangarooRewardsToken.client_id,
                      "client_secret": KangarooRewardsToken.client_secret,
                      "username": KangarooRewardsToken.username,
                      "password": KangarooRewardsToken.password,
                      "scope": KangarooRewardsToken.scope,
                      "application_key": KangarooRewardsToken.application_key
        ]
        
        NetworkHandler.shared.sendRequestUpdated(api: "https://api.kangaroorewards.com/oauth/token", type: .POST, params: params) { (result) in
            switch result{
            case .success(let data):
                do{
                    let json = try JSON(data: data)
                    print("kangarooGenerateToken==",json)
                    completion(json["access_token"].stringValue)
                }catch let error {
                    print(error)
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
        
    }
    
    func createKangarooCustomer(email: String, first_name: String, last_name: String, allow_sms: Bool, allow_email: Bool, completion: @escaping (RequestsResult<String, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let safeToken = token else {return}
            let request = KangarooCreateCustomerRequest(email: email, first_name: first_name, last_name: last_name, token: safeToken)
            IntegrationsNetworking.shared.send(request) { response in
                switch response {
                case .success(let result):
                    if let userID = result.data?.id {
                        UserDefaults.standard.setValue(userID, forKey: "kangarooUserId")
                        self.kangarooCustomerConsents(userId: userID, allow_sms: allow_sms, allow_email: allow_email, token: safeToken)
                        completion(.success(userID))
                    }
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func fetchKangarooCustomer(email: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let safeToken = token else {return}
            let request = KangarooCustomerRequest(email: email, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    print("kangaroo user",result)
                    if let userID = result.data?.first?.id {
                        if let customer = result.data?.first {
                            self?.kangarooProfle = customer
                        }
                        if let points = result.data?.first?.balance?.points {
                            self?.userPoint = points
                        }
                        //                        print("The kangaroo userId is \(userID)")
                        UserDefaults.standard.setValue(userID, forKey: "kangarooUserId")
                        completion(.success(true))
                    }
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    
    func fetchCustomerConsent(completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let safeToken = token else {return}
            if let userId = UserDefaults.standard.value(forKey: "kangarooUserId") as? String {
                let request = KangarooCustomerGetConsentRequest(user_id: userId, token: safeToken)
                IntegrationsNetworking.shared.send(request) {[weak self] response in
                    switch response {
                    case .success(let result):
                        print("kangaroo user",result)
                        if let data = result.data?.first {
                            self?.customerConsent = data
                        }
                        completion(.success(true))
                    case .failed(let err):
                        let err = (String (describing: err))
                        completion(.failed(err))
                    }
                }
            }
        }
    }
    
    
    func fetchKangarooCustomerHistory(pageNumber: Int, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token else {return}
            let request = KangarooCustomerHistoryRequest(user_id: user_id, pageNumber: pageNumber, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if pageNumber == 1 {
                        self?.customerHistory = result
                    }
                    else {
                        self?.customerHistory?.links = result.links
                        self?.customerHistory?.meta = result.meta
                        self?.customerHistory?.data?.append(contentsOf: result.data ?? [KangarooCustomerHistoryData]())
                        
                    }
                    completion(.success(true))
                    
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func updateKangarooAccountDetails(firstName: String, lastName: String, email: String, dob: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token else {return}
            let request = KangarooCustomerUpdateRequest(email: email, first_name: firstName, last_name: lastName, user_id: user_id, birth_date: dob, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let data = result.data {
                        completion(.success(true))
                    }
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func fetchKangarooCustomerRewards(pageNumber: Int, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token, let branchId = UserDefaults.standard.value(forKey: "kangaroo_branch_id") as? String else {return}
            let request = KangarooCustomerRewardsRequest(user_id: user_id, token: safeToken, branchId: branchId)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if pageNumber == 1 {
                        self?.customerRewards = result
                    }
                    else {
                        self?.customerRewards?.meta = result.meta
                        self?.customerRewards?.links = result.links
                        self?.customerRewards?.data?.append(contentsOf: result.data ?? [KangarooCustomerRewardsData]())
                    }
                    completion(.success(true))
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func fetchKangarooCustomerOffers(pageNumber: Int, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token, let branchId = UserDefaults.standard.value(forKey: "kangaroo_branch_id") as? String else {return}
            let request = KangarooCustomerOffersRequest(user_id: user_id, token: safeToken, branchId: branchId)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if pageNumber == 1 {
                        self?.customerOffers = result
                    }
                    else {
                        self?.customerOffers?.meta = result.meta
                        self?.customerOffers?.links = result.links
                        self?.customerOffers?.data?.append(contentsOf: result.data ?? [KangarooCustomerRewardsData]())
                    }
                    
                    completion(.success(true))
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func fetchKangarooTiers(completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let safeToken = token else {return}
            let request = KangarooTiersRequest(token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let tiers = result.data {
                        self?.tiers = tiers
                        completion(.success(true))
                    }
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func kangarooCustomerConsents(userId: String, allow_sms: Bool, allow_email: Bool, token: String="")  {
        generateTokenKangaroo { token in
            guard let safeToken = token else {return}
            let request = KangarooCustomerConsentRequest(allow_sms: allow_sms, allow_email: allow_email, user_id: userId, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let resData = result.data {
                        print("Successfully sent consent")
                    }
                    
                case .failed(let err):
                    let err = (String (describing: err))
                    print("Kangaroo \(err)")
                }
            }
        }
    }
    
    func fetchKangarooBranches(completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let safeToken = token else {return}
            let request = KangarooBranchesRequest(token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let branches = result.data {
                        for branch in branches {
                            if branch.virtualBranchFlag == true {
                                let id = branch.id ?? ""
                                UserDefaults.standard.set(id, forKey: "kangaroo_branch_id")
                                completion(.success(true))
                            }
                        }
                    }
                    
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    
    func kangarooRewardCouponRedeem(offer_id: String, coupon_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token, let branch_id = UserDefaults.standard.value(forKey: "kangaroo_branch_id") as? String else {return}
            let request = KangarooRewardCouponRedeemRequest(offer_id: offer_id, coupon_id: coupon_id, customer_id: user_id, branch_id: branch_id, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let couponData = result.data {
                        self?.coupon = couponData
                        completion(.success(true))
                    }
                    
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    
    
    
    func kangarooOfferCouponRedeem(catalog_item_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token, let branch_id = UserDefaults.standard.value(forKey: "kangaroo_branch_id") as? String else {return}
            let request = KangarooOfferCouponRedeemRequest(catalog_item_id: catalog_item_id, customer_id: user_id, branch_id: branch_id, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let couponData = result.data {
                        self?.coupon = couponData
                        completion(.success(true))
                    }
                    
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func kangarooPayWithPoints(amount: String, subtotal: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token, let branch_id = UserDefaults.standard.value(forKey: "kangaroo_branch_id") as? String else {return}
            let request = KangarooPayWithPointsRequest(amount: amount, subtotal: subtotal, customer_id: user_id, branch_id: branch_id, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let couponData = result.data {
                        self?.pointsCoupon = couponData
                        completion(.success(true))
                    }
                    else {
                        completion(.failed("You dont have enough points to use it."))
                    }
                    
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func deleteCoupon(coupon_code: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token, let branch_id = UserDefaults.standard.value(forKey: "kangaroo_branch_id") as? String else {return}
            let request = KangarooCancelCouponRequest(code: coupon_code, customer_id: user_id, branch_id: branch_id, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    self?.customerHistory = nil
                    completion(.success(true))
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    
    func multiplyCustomerPoints(points: Int, reward_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        generateTokenKangaroo { token in
            guard let user_id = UserDefaults.standard.value(forKey: "kangarooUserId") as? String , let safeToken = token, let branch_id = UserDefaults.standard.value(forKey: "kangaroo_branch_id") as? String else {return}
            let request = KangarooMultiplyPointsRequest(points: points, customer_id: user_id, reward_id: reward_id, branch_id: branch_id, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let data = result.data {
                        self?.userPoint = data.points ?? 0
                    }
                    completion(.success(true))
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    
}
