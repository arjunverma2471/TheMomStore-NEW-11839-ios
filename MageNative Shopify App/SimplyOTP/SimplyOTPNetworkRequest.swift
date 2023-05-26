//
//  SimplyOTPRequest.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 31/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

struct SendOTP: Codable {
    let status: Int?
    let message: String?
    let data: SendOTPData?
}

struct SendOTPData: Codable {
    let otpID: String?
    let otpLength: Int?
    
    enum CodingKeys: String, CodingKey {
        case otpID = "otpId"
        case otpLength
    }
}

final class SendOTPRequest: Requestables{
    
    typealias Response =  SendOTP
    
    var path: String {
        return "otp"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "username", value: phoneNumber)
        body.appendingQueryParameter(key: "type", value: "phone")
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "shop_name", value: Client.shopUrl)
        header.appendingQueryParameter(key: "action", value: action)
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let phoneNumber: String
    
    private let action: String
    
    init(phoneNumber: String, action: String){
        self.phoneNumber = phoneNumber
        self.action = action
    }
}




struct VerifyOTP: Codable {
    let status: Int?
    let message: String?
    let data: VerifyOTPData?
}

struct VerifyOTPData: Codable {
    let username: String?
    let email, phone: String?
    let redirectURL: String?
    let emailRequired: Bool?
    let firstName, lastName, multipassURL: String?
    
    enum CodingKeys: String, CodingKey {
        case username, email, phone
        case redirectURL = "redirect_url"
        case emailRequired = "email_required"
        case firstName, lastName
        case multipassURL = "multipass_url"
    }
}

final class VerifyOTPRequest: Requestables {
    
    typealias Response =  VerifyOTP
    
    var path: String {
        return "otp"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "username", value: phoneNumber)
        body.appendingQueryParameter(key: "type", value: "phone")
        body.appendingQueryParameter(key: "otp", value: otp)
        body.appendingQueryParameter(key: "otp_id", value: otp_id)
        body.appendingQueryParameter(key: "checkout_url", value: "")
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "shop_name", value: Client.shopUrl)
        header.appendingQueryParameter(key: "action", value: "verifyOTP")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        print("The header is \(header)")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let phoneNumber: String
    
    private let otp: String
    
    private let otp_id: String
    
    init(phoneNumber: String,
         otp: String,
         otp_id: String){
        self.phoneNumber = phoneNumber
        self.otp = otp
        self.otp_id = otp_id
    }
}

struct UpdateEmail: Codable {
    let status: Int?
    let message: String?
    let data: UpdateEmailData?
}

// MARK: - DataClass
struct UpdateEmailData: Codable {
    let redirectURL: String?
    let multipassURL: String?

    enum CodingKeys: String, CodingKey {
        case redirectURL = "redirect_url"
        case multipassURL = "multipass_url"
    }
}

final class UpdateEmailReqest: Requestables {
    
    typealias Response =  UpdateEmail
    
    var path: String {
        return "otp"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        
        body.appendingQueryParameter(key: "first_name", value: first_name)
        body.appendingQueryParameter(key: "last_name", value: last_name)
        body.appendingQueryParameter(key: "email", value: email)
        body.appendingQueryParameter(key: "otp_id", value: otp_id)
        body.appendingQueryParameter(key: "phone_no", value: phone_no)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "shop_name", value: Client.shopUrl)
        header.appendingQueryParameter(key: "action", value: "updateEmail")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let first_name: String
    
    private let last_name: String
    
    private let email: String
    
    private let otp_id: String
    
    private let phone_no: String
    
    init(first_name: String,
         last_name: String,
         email: String,
         otp_id: String,
         phone_no: String){
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.otp_id = otp_id
        self.phone_no = phone_no


    }
}
