//
//  SimpleOTPViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 31/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit

class SimplyOTPViewModel: NSObject {
    var recieved_otp_id = ""
    var verifyOTP: VerifyOTPData?
    func sendOTPRequest(phoneNumber: String, shop_name: String, action: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        let request = SendOTPRequest(phoneNumber: "+91\(phoneNumber)", action: action)
        IntegrationsNetworking.shared.send(request) {[weak self] result in
            switch result {
            case .success(let result):
                if let results = result.data?.otpID {
                    self?.recieved_otp_id = results
                    UserDefaults.standard.setValue(results, forKey: "simplyOTPID")
                    completion(.success(true))
                }
                
            case .failed(let error):
                let err = (String (describing: error))
                print(err)
                completion(.failed(err))
            }
        }
    }
    
    func verifyOTPRequest(phoneNumber: String, shop_name: String, otp: String, otp_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        let request = VerifyOTPRequest(phoneNumber: phoneNumber, otp: otp, otp_id: otp_id)
        IntegrationsNetworking.shared.send(request) {[weak self] result in
            switch result {
            case .success(let result):
                if let resultData = result.data {
                    self?.verifyOTP = resultData
                    completion(.success(true))
                }
                else {
                    if let message = result.message {
                        completion(.failed(message))
                    }
                }
                
            case .failed(let error):
                let err = (String (describing: error))
                print(err)
                completion(.failed(err))
            }
        }
    }
    
    func updateAccountDetails(firstName: String, lastName: String, email: String, phoneNumber: String, otp_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        let request = UpdateEmailReqest(first_name: firstName, last_name: lastName, email: email, otp_id: otp_id, phone_no: phoneNumber)
        IntegrationsNetworking.shared.send(request) {[weak self] result in
            switch result {
            case .success(let result):
                if let url = result.data?.redirectURL {
                    if url != "" {
                        completion(.success(true))
                    }
                }
            case .failed(let error):
                let err = (String (describing: error))
                print(err)
                completion(.failed(err))
            }
        }
    }
    
    
}
