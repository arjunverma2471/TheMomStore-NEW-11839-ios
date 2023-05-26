//
//  KangarooRewardsRequest.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
struct KangarooRewardsToken {
    static let grant_type = "password"
    static let client_id = "10125981"
    static let client_secret = "4DzOeYTmTqOVfU3ENqHAGmoyckGGdgILQ5JiZSSb"
    static let username = "sachinsingla@magenative.com"
    static let password = "123@SachinSingla"
    static let scope = "admin"
    static let application_key = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImJ1c2luZXNzSWQiOiIyOTk3IiwiYnJhbmNoSWQiOiI1MzAwIiwiY29hbGl0aW9uIjoiMCIsImNvbmdsb21lcmF0ZSI6IjAifX0.48x0u-seeiSHHkPWyu11iw9f3R0824RyU0FvNIMJO8w"
}


struct KangarooCreateCustomer: Codable {
    let data: KangarooCreateCustomerData?
}

struct KangarooCreateCustomerData: Codable {
    let id, email: String?
    let phone: String?
    let firstName, lastName, qrcode: String?
    let gender, birthDate: String?
    let language: String?
    let countryCode, profilePhoto: String?
    let createdAt, updatedAt: String?
    let enabled, emailVerified, phoneVerified: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, email, phone
        case firstName = "first_name"
        case lastName = "last_name"
        case qrcode, gender
        case birthDate = "birth_date"
        case language
        case countryCode = "country_code"
        case profilePhoto = "profile_photo"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case enabled
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
    }
}
final class KangarooCreateCustomerRequest: Requestables {
    
    typealias Response =  KangarooCreateCustomer
    
    var path: String {
        return "customers"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "email", value: email)
        body.appendingQueryParameter(key: "first_name", value: first_name)
        body.appendingQueryParameter(key: "last_name", value: last_name)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let email: String
    
    private let first_name: String
    
    private let last_name: String
    
    private let token: String
    
    init(email: String, first_name: String, last_name: String, token: String){
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.token = token
    }
}

struct KanagrooCustomer: Codable {
    let data: [KanagrooCustomerData]?
}


struct KanagrooCustomerData: Codable {
    let id, email: String?
    let phone: String?
    let firstName, lastName: String?
    let gender, birthDate, language: String?
    let countryCode, profilePhoto: String?
    let enabled: Bool?
    let balance: KangarooBalance?
    
    enum CodingKeys: String, CodingKey {
        case id, email, phone
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case birthDate = "birth_date"
        case language
        case countryCode = "country_code"
        case profilePhoto = "profile_photo"
        case enabled, balance
    }
}

// MARK: - Balance
struct KangarooBalance: Codable {
    let points, giftcard: Int?
}

final class KangarooCustomerRequest: Requestables {
    
    typealias Response =  KanagrooCustomer
    
    var path: String {
        return "customers"
    }
    
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "email", value: "eq%7C\(email)")
        params.appendingQueryParameter(key: "include", value: "balance")
        return params as! [String: String]
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    private let email: String
    
    private let token: String
    
    init(email: String, token: String){
        self.email = email
        self.token = token
    }
}

struct KangarooCustomerHistory: Codable {
    var data: [KangarooCustomerHistoryData]?
    var links: Links?
    var meta: Meta?
}

struct Links: Codable {
    let first: String?
    let last: String?
    let prev: String?
    let next: String?
}

// MARK: - Meta
struct Meta: Codable {
    let currentPage, from: Int?
    let path: String?
    let perPage, to: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from, path
        case perPage = "per_page"
        case to
    }
}

struct KangarooCustomerHistoryData: Codable {
    let id: Int?
    let amount: Double?
    let points: Int?
    let name: String?
    let transactionType: Int?
    let createdAt, updatedAt: String?
    let ecomCoupon: EcomCoupon?

    enum CodingKeys: String, CodingKey {
        case id, amount, points, name
        case transactionType = "transaction_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ecomCoupon = "ecom_coupon"
    }
}
class KangarooCustomerHistoryRequest: Requestables {
    
    typealias Response =  KangarooCustomerHistory
    
    var path: String {
        return "customers/\(user_id)/transactions"
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "include", value: "ecom_coupon")
        params.appendingQueryParameter(key: "per_page", value: "15")
        params.appendingQueryParameter(key: "page", value: "\(pageNumber)")
        return params as! [String: String]
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    private let user_id: String
    
    
    private let token: String
    
    private let pageNumber: Int
    
    init(user_id: String, pageNumber: Int, token: String){
        self.user_id = user_id
        self.token = token
        self.pageNumber = pageNumber
    }
}

struct KangarooUpdateCustomer: Codable {
    let data: KangarooUpdateCustomerData?
}

// MARK: - DataClass
struct KangarooUpdateCustomerData: Codable {
    let id, email, phone, firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, phone
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

class KangarooCustomerUpdateRequest: Requestables {
    
    typealias Response =  KangarooUpdateCustomer
    
    var path: String {
        return "customers/\(user_id)"
    }
    
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "email", value: email)
        body.appendingQueryParameter(key: "first_name", value: first_name)
        body.appendingQueryParameter(key: "last_name", value: last_name)
        body.appendingQueryParameter(key: "birth_date", value: birth_date)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .put
    }
    
    private let email: String
    
    private let first_name: String
    
    private let last_name: String
    
    private let birth_date: String
    
    private let user_id: String
    
    private let token: String
    
    init(email: String, first_name: String, last_name: String, user_id: String, birth_date: String, token: String){
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.token = token
        self.user_id = user_id
        self.birth_date = birth_date
    }
}

struct KangarooCustomerRewards: Codable {
    var data: [KangarooCustomerRewardsData]?
    var links: Links?
    var meta: Meta?
}

// MARK: - Datum
struct KangarooCustomerRewardsData: Codable {
    let id, points: Int?
    let expiresAt, publishAt: String?
    let isPublished, couponConvertible: Bool?
    let discountValue, multipFactor, realValue, minPurchase: Int?
    let maxPurchase: Int?
    let appsOnly, couponAutoGet: Bool?
    let offerFrequencyID: Int?
    let peakFrom, peakTo, type: String?
    let typeID, targetedOfferFlag, priority: Int?
    let title, description: String?
    let neverExpiresFlag: Bool?
    let termsConditions, link: String?
    let images: [KangarooCustomerRewardsImage]?
    let offerLanguages: [OfferLanguage]?
    let coupon: Coupon?
    
    init(id: Int? = nil,
         points: Int? = nil,
         expiresAt: String? = nil,
         publishAt: String? = nil,
         isPublished: Bool? = nil,
         couponConvertible: Bool? = nil,
         discountValue: Int? = nil,
         multipFactor: Int? = nil,
         realValue: Int? = nil,
         minPurchase: Int? = nil,
         maxPurchase: Int? = nil,
         appsOnly: Bool? = nil,
         couponAutoGet: Bool? = nil,
         offerFrequencyID: Int? = nil,
         peakFrom: String? = nil,
         peakTo: String? = nil,
         type: String? = nil,
         typeID: Int? = nil,
         targetedOfferFlag: Int? = nil,
         priority: Int? = nil,
         title: String? = nil,
         description: String? = nil,
         neverExpiresFlag: Bool? = nil,
         termsConditions: String? = nil,
         link: String? = nil,
         images: [KangarooCustomerRewardsImage]? = nil,
         offerLanguages: [OfferLanguage]? = nil,
         coupon: Coupon? = nil) {
        
        self.id = id
        self.points = points
        self.expiresAt = expiresAt
        self.publishAt = publishAt
        self.isPublished = isPublished
        self.couponConvertible = couponConvertible
        self.discountValue = discountValue
        self.multipFactor = multipFactor
        self.realValue = realValue
        self.minPurchase = minPurchase
        self.maxPurchase = maxPurchase
        self.appsOnly = appsOnly
        self.couponAutoGet = couponAutoGet
        self.offerFrequencyID = offerFrequencyID
        self.peakFrom = peakFrom
        self.peakTo = peakTo
        self.type = type
        self.typeID = typeID
        self.targetedOfferFlag = targetedOfferFlag
        self.priority = priority
        self.title = title
        self.description = description
        self.neverExpiresFlag = neverExpiresFlag
        self.termsConditions = termsConditions
        self.link = link
        self.images = images
        self.offerLanguages = offerLanguages
        self.coupon = coupon
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decodeIfPresent(Int.self, forKey: .id)
        points = try? container.decodeIfPresent(Int.self, forKey: .points)
        expiresAt = try? container.decodeIfPresent(String.self, forKey: .expiresAt)
        publishAt = try? container.decodeIfPresent(String.self, forKey: .publishAt)
        isPublished = try? container.decodeIfPresent(Bool.self, forKey: .isPublished)
        couponConvertible = try? container.decodeIfPresent(Bool.self, forKey: .couponConvertible)
        discountValue = try? container.decodeIfPresent(Int.self, forKey: .discountValue)
        multipFactor = try? container.decodeIfPresent(Int.self, forKey: .multipFactor)
        realValue = try? container.decodeIfPresent(Int.self, forKey: .realValue)
        minPurchase = try? container.decodeIfPresent(Int.self, forKey: .minPurchase)
        maxPurchase = try? container.decodeIfPresent(Int.self, forKey: .maxPurchase)
        appsOnly = try? container.decodeIfPresent(Bool.self, forKey: .appsOnly)
        couponAutoGet = try? container.decodeIfPresent(Bool.self, forKey: .couponAutoGet)
        offerFrequencyID = try? container.decodeIfPresent(Int.self, forKey: .offerFrequencyID)
        peakFrom = try? container.decodeIfPresent(String.self, forKey: .peakFrom)
        peakTo = try? container.decodeIfPresent(String.self, forKey: .peakTo)
        type = try? container.decodeIfPresent(String.self, forKey: .type)
        typeID = try? container.decodeIfPresent(Int.self, forKey: .typeID)
        targetedOfferFlag = try? container.decodeIfPresent(Int.self, forKey: .targetedOfferFlag)
        priority = try? container.decodeIfPresent(Int.self, forKey: .priority)
        title = try? container.decodeIfPresent(String.self, forKey: .title)
        description = try? container.decodeIfPresent(String.self, forKey: .description)
        neverExpiresFlag = try? container.decodeIfPresent(Bool.self, forKey: .neverExpiresFlag)
        termsConditions = try? container.decodeIfPresent(String.self, forKey: .termsConditions)
        link = try? container.decodeIfPresent(String.self, forKey: .link)
        images = try? container.decodeIfPresent([KangarooCustomerRewardsImage].self, forKey: .images)
        offerLanguages = try? container.decodeIfPresent([OfferLanguage].self, forKey: .offerLanguages)
        if let coupon = try? container.decodeIfPresent(Coupon.self, forKey: .coupon) {
            self.coupon = coupon
        } else {
            self.coupon = nil
        }
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id, points
        case expiresAt = "expires_at"
        case publishAt = "publish_at"
        case isPublished = "is_published"
        case couponConvertible = "coupon_convertible"
        case discountValue = "discount_value"
        case multipFactor = "multip_factor"
        case realValue = "real_value"
        case minPurchase = "min_purchase"
        case maxPurchase = "max_purchase"
        case appsOnly = "apps_only"
        case couponAutoGet = "coupon_auto_get"
        case offerFrequencyID = "offer_frequency_id"
        case peakFrom = "peak_from"
        case peakTo = "peak_to"
        case type
        case typeID = "type_id"
        case targetedOfferFlag = "targeted_offer_flag"
        case priority, title, description
        case neverExpiresFlag = "never_expires_flag"
        case termsConditions = "terms_conditions"
        case link, images
        case offerLanguages = "offer_languages"
        case coupon
    }
    
}

// MARK: - Coupon
struct Coupon: Codable {
    let id: Int?
    let qrcode: String?
    let couponLocked, couponRedeemed: Bool?
    let couponTypeID: Int?
    let expiresAt, couponClaimedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, qrcode
        case couponLocked = "coupon_locked"
        case couponRedeemed = "coupon_redeemed"
        case couponTypeID = "coupon_type_id"
        case expiresAt = "expires_at"
        case couponClaimedAt = "coupon_claimed_at"
    }
}

// MARK: - Image
struct KangarooCustomerRewardsImage: Codable {
    let large, medium, thumbnail: String?
    let imageDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case large, medium, thumbnail
        case imageDefault = "default"
    }
}

// MARK: - OfferLanguage
struct OfferLanguage: Codable {
    let id, languageID: Int?
    let offerTitle, offerLink, offerDescription, offerTermsConditions: String?
    let language: Language?

    enum CodingKeys: String, CodingKey {
        case id
        case languageID = "language_id"
        case offerTitle = "offer_title"
        case offerLink = "offer_link"
        case offerDescription = "offer_description"
        case offerTermsConditions = "offer_terms_conditions"
        case language
    }
}

// MARK: - Language
struct Language: Codable {
    let id: Int?
    let abbreviation, name: String?
}


final class KangarooCustomerRewardsRequest: Requestables {
    
    typealias Response =  KangarooCustomerRewards
    
    var path: String {
        return "customers/\(user_id)/targeted-offers"
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "include", value: "coupon")
        params.appendingQueryParameter(key: "branch.id", value: "eq|\(branchId)")
        return params as! [String: String]
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    private let user_id: String
    
    
    private let token: String
    
    private let branchId: String
    
    init(user_id: String, token: String, branchId: String){
        self.user_id = user_id
        self.token = token
        self.branchId = branchId
    }
}


final class KangarooCustomerOffersRequest: Requestables {
    
    typealias Response =  KangarooCustomerRewards
    
    var path: String {
        return "customers/\(user_id)/rewards"
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "include", value: "coupon")
        params.appendingQueryParameter(key: "branch.id", value: "eq|\(branchId)")
        return params as! [String: String]
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    private let user_id: String
    
    
    private let token: String
    
    private let branchId: String
    
    init(user_id: String, token: String, branchId: String){
        self.user_id = user_id
        self.token = token
        self.branchId = branchId
    }
}

struct KangarooTiers: Codable {
    let data: [KangarooTiersData]?
    var links: Links?
    var meta: Meta?
}

// MARK: - Datum
struct KangarooTiersData: Codable {
    let id: Int?
    let tiersSequence: [String]?
    let tiersRelation: Int?
    let isCombined: Bool?
    let resetType, resetPeriodMonth, basePreviousPeriod: Int?
    let enabled: Bool?
    let defaultTierIcon: String?
    let tierLevels: [KangarooTiersLevel]?
    let resetByCustomerRegistrationMonth: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case tiersSequence = "tiers_sequence"
        case tiersRelation = "tiers_relation"
        case isCombined = "is_combined"
        case resetType = "reset_type"
        case resetPeriodMonth = "reset_period_month"
        case basePreviousPeriod = "base_previous_period"
        case enabled
        case defaultTierIcon = "default_tier_icon"
        case tierLevels = "tier_levels"
        case resetByCustomerRegistrationMonth = "reset_by_customer_registration_month"
    }
}

// MARK: - TierLevel
struct KangarooTiersLevel: Codable {
    let id: Int?
    let name, description: String?
    let reachSpend, reachVisits, reachPoints: Int?
    let icon: String?
    let languages: [LanguageElement]?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case reachSpend = "reach_spend"
        case reachVisits = "reach_visits"
        case reachPoints = "reach_points"
        case icon, languages
    }
}

// MARK: - LanguageElement
struct LanguageElement: Codable {
    let languageID: Int?
    let name, description: String?
    let language: LanguageLanguage?

    enum CodingKeys: String, CodingKey {
        case languageID = "language_id"
        case name, description, language
    }
}

struct LanguageLanguage: Codable {
    let id: Int?
    let abbreviation, name: String?
}

final class KangarooTiersRequest: Requestables {
    
    typealias Response =  KangarooTiers
    
    var path: String {
        return "tiers"
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "relationships", value: "tier_levels")
        return params as! [String: String]
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    
    private let token: String
    
    init(token: String){
        self.token = token
    }
}



final class KangarooReferRequest: Requestables {
    
    typealias Response =  KangarooTiers
    
    var path: String {
        return "referral-programs"
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    
    private let token: String
    
    init(token: String){
        self.token = token
    }
}

struct KangarooCustomerConsent: Codable {
    let data: KangarooCustomerConsentData?
}

// MARK: - DataClass
struct KangarooCustomerConsentData: Codable {
    let id: Int?
    let allowSMS, allowEmail, allowPush: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case allowSMS = "allow_sms"
        case allowEmail = "allow_email"
        case allowPush = "allow_push"
    }
}

struct KangarooGetCustomerConsent : Codable {
    let data : [KangarooGetCustomerConsentData]?
    let links : KangarooGetCustomerLinkData?
    let meta : KangarooGetCustomerMetaData?
    
}
struct KangarooGetCustomerLinkData: Codable {
    let first: String?
    let last, prev, next: String?
}

struct KangarooGetCustomerMetaData: Codable {
    let path: String?
    let currentPage, from, perPage, to : Int?
    
    enum CodingKeys: String, CodingKey {
        case path
        case currentPage = "current_page"
        case from
        case perPage = "per_page"
        case to
    }
}


struct KangarooGetCustomerConsentData: Codable {
    let id: Int?
    let allowSMS, allowEmail, allowPush: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case allowSMS = "allow_sms"
        case allowEmail = "allow_email"
        case allowPush = "allow_push"
    }
}

final class KangarooCustomerConsentRequest: Requestables {
    
    typealias Response =  KangarooCustomerConsent
    
    var path: String {
        return "customers/\(user_id)/consents"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "allow_sms", value: allow_sms)
        body.appendingQueryParameter(key: "allow_email", value: allow_email)
        body.appendingQueryParameter(key: "allow_push", value: false)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let allow_sms: Bool
    
    private let allow_email: Bool
    
    private let user_id: String
    
    private let token: String
    
    init(allow_sms: Bool, allow_email: Bool, user_id: String, token: String){
        self.allow_sms = allow_sms
        self.allow_email = allow_email
        self.token = token
        self.user_id = user_id
    }
}

final class KangarooCustomerGetConsentRequest: Requestables {

    
    /*
     {
         "data": [
             {
                 "id": 10346701,
                 "allow_sms": true,
                 "allow_email": true,
                 "allow_push": false
             }
         ],
         "links": {
             "first": "http://api.kangaroorewards.com/customers/11edb1b03c613aedb83b42010a800057/consents?page=1",
             "last": null,
             "prev": null,
             "next": null
         },
         "meta": {
             "current_page": 1,
             "from": 1,
             "path": "http://api.kangaroorewards.com/customers/11edb1b03c613aedb83b42010a800057/consents",
             "per_page": 15,
             "to": 1
         }
     }
     */
    typealias Response =  KangarooGetCustomerConsent
    
    var path: String {
        return "customers/\(user_id)/consents"
    }
    
  /*  var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "allow_sms", value: allow_sms)
        body.appendingQueryParameter(key: "allow_email", value: allow_email)
        body.appendingQueryParameter(key: "allow_push", value: false)
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    } */
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
  /*  private let allow_sms: Bool
    
    private let allow_email: Bool  */
    
    private let user_id: String
    
    private let token: String
    
    init( user_id: String, token: String){  //allow_sms: Bool, allow_email: Bool,
      /*  self.allow_sms = allow_sms
        self.allow_email = allow_email  */
        self.token = token
        self.user_id = user_id
    }
}

struct KangarooBranches: Codable {
    let data: [KangarooBranchesData]?
}

// MARK: - Datum
struct KangarooBranchesData: Codable {
    let id, name: String?
    let webSite: String?
    let phone: KangarooPhone?
    let address: KangarooAddress?
    let virtualBranchFlag: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case webSite = "web_site"
        case phone
        case address
        case virtualBranchFlag = "virtual_branch_flag"
    }
}

// MARK: - Address
struct KangarooAddress: Codable {
    let formatted, street, city, region: String?
    let country: String?
    let lat, long: Int?
}


// MARK: - Phone
struct KangarooPhone: Codable {
    let number, countryCode, nationalFormat, intlFormat: String?
    
    enum CodingKeys: String, CodingKey {
        case number
        case countryCode = "country_code"
        case nationalFormat = "national_format"
        case intlFormat = "intl_format"
    }
}
final class KangarooBranchesRequest: Requestables {
    
    typealias Response =  KangarooBranches
    
    var path: String {
        return "branches"
    }
    
    var queryParameters: [String : Any] {
        var params: [String: Any] = [:]
        params.appendingQueryParameter(key: "include", value: "virtual_branch")
        return params as! [String: String]
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .get
    }
    
    
    private let token: String
    
    init(token: String){
        self.token = token
    }
}







struct KangarooOfferRedeem: Codable {
    let data: KangarooOfferRedeemData?
}

// MARK: - DataClass
struct KangarooOfferRedeemData: Codable {
    let id, amount, points: Int?
    let name: String?
    let transactionType: Int?
    let createdAt, updatedAt: String?
    let ecomCoupon: EcomCoupon?
    let offers: [OfferElement]?
    let coupon: Coupon?
    let customer: KanagrooCustomerData?

    enum CodingKeys: String, CodingKey {
        case id, amount, points, name
        case transactionType = "transaction_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ecomCoupon = "ecom_coupon"
        case offers, coupon, customer
    }
}


// MARK: - CouponOffer
struct CouponOffer: Codable {
    let id, points: Int?
    let expiresAt, publishAt: String?
    let couponConvertible: Bool?
    let discountValue, multipFactor, realValue, minPurchase: Int?
    let maxPurchase: Int?
    let appsOnly, couponAutoGet: Bool?
    let offerFrequencyID: Int?
    let type: String?
    let typeID, targetedOfferFlag, priority: Int?
    let title, description: String?
    let neverExpiresFlag: Bool?
    let termsConditions, link: String?
    let images: [KangarooCustomerRewardsImage]?
    let offerLanguages: [OfferLanguage]?

    enum CodingKeys: String, CodingKey {
        case id, points
        case expiresAt = "expires_at"
        case publishAt = "publish_at"
        case couponConvertible = "coupon_convertible"
        case discountValue = "discount_value"
        case multipFactor = "multip_factor"
        case realValue = "real_value"
        case minPurchase = "min_purchase"
        case maxPurchase = "max_purchase"
        case appsOnly = "apps_only"
        case couponAutoGet = "coupon_auto_get"
        case offerFrequencyID = "offer_frequency_id"
        case type
        case typeID = "type_id"
        case targetedOfferFlag = "targeted_offer_flag"
        case priority, title, description
        case neverExpiresFlag = "never_expires_flag"
        case termsConditions = "terms_conditions"
        case link, images
        case offerLanguages = "offer_languages"
    }
}

// MARK: - EcomCoupon
struct EcomCoupon: Codable {
    let code: String?
    let expiresAt: String?
    let status: Int?
    let statusDescription: String?

    enum CodingKeys: String, CodingKey {
        case code
        case expiresAt = "expires_at"
        case status
        case statusDescription = "status_description"
    }
}

// MARK: - OfferElement
struct OfferElement: Codable {
    let id, points: Int?
    let expiresAt: String?
    let discountValue, multipFactor, realValue: Int?
    let type, title, description: String?
    let images: [KangarooCustomerRewardsImage]?

    enum CodingKeys: String, CodingKey {
        case id, points
        case expiresAt = "expires_at"
        case discountValue = "discount_value"
        case multipFactor = "multip_factor"
        case realValue = "real_value"
        case type, title, description, images
    }
}


final class KangarooRewardCouponRedeemRequest: Requestables {
    
    typealias Response =  KangarooOfferRedeem
    
    var path: String {
        return "transactions"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "intent", value: "claim_ecom_coupon")
        body.appendingQueryParameter(key: "offer", value: ["id": offer_id])
        body.appendingQueryParameter(key: "coupon", value: ["id": coupon_id])
        body.appendingQueryParameter(key: "customer", value: ["id": customer_id])
        body.appendingQueryParameter(key: "branch", value: ["id": branch_id])
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let offer_id: String
    
    private let coupon_id: String
    
    private let customer_id: String
    
    private let branch_id: String
    
    private let token: String
    
    init(offer_id: String, coupon_id: String, customer_id: String, branch_id: String, token: String){
        self.offer_id = offer_id
        self.coupon_id = coupon_id
        self.customer_id = customer_id
        self.branch_id = branch_id
        self.token = token
    }
}




final class KangarooOfferCouponRedeemRequest: Requestables {
    
    typealias Response =  KangarooOfferRedeem
    
    var path: String {
        return "transactions"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "intent", value: "redeem_ecom_coupon")
        body.appendingQueryParameter(key: "catalog_item", value: ["id": catalog_item_id])
        body.appendingQueryParameter(key: "customer", value: ["id": customer_id])
        body.appendingQueryParameter(key: "branch", value: ["id": branch_id])
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let catalog_item_id: String
    
    private let customer_id: String
    
    private let branch_id: String
    
    private let token: String
    
    init(catalog_item_id: String, customer_id: String, branch_id: String, token: String){
        self.catalog_item_id = catalog_item_id
        self.customer_id = customer_id
        self.branch_id = branch_id
        self.token = token
    }
}


struct KangarooPayWithPoints: Codable {
    let data: KangarooPayWithPointsData?
}

// MARK: - DataClass
struct KangarooPayWithPointsData: Codable {
    let id, amount, points: Int?
    let name: String?
    let transactionType: Int?
    let createdAt, updatedAt: String?
    let ecomCoupon: EcomCoupon?
    let customer: KanagrooCustomerData?

    enum CodingKeys: String, CodingKey {
        case id, amount, points, name
        case transactionType = "transaction_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ecomCoupon = "ecom_coupon"
        case customer
    }
}



final class KangarooPayWithPointsRequest: Requestables {
    
    typealias Response =  KangarooPayWithPoints
    
    var path: String {
        return "transactions"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "intent", value: "redeem_ecom_coupon")
        body.appendingQueryParameter(key: "amount", value: amount)
        body.appendingQueryParameter(key: "subtotal", value: subtotal)
        body.appendingQueryParameter(key: "customer", value: ["id": customer_id])
        body.appendingQueryParameter(key: "branch", value: ["id": branch_id])
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let amount: String
    
    private let subtotal: String
    
    private let customer_id: String
    
    private let branch_id: String
    
    private let token: String
    
    init(amount: String, subtotal: String, customer_id: String, branch_id: String, token: String){
        self.amount = amount
        self.subtotal = subtotal
        self.customer_id = customer_id
        self.branch_id = branch_id
        self.token = token
    }
}


struct KangarooCancelCoupon: Codable {
    let data: KangarooCancelCouponData?
}

// MARK: - DataClass
struct KangarooCancelCouponData: Codable {
    let id, points: Int?
    let amount: CGFloat?
    let name: String?
    let transactionType: Int?
    let createdAt, updatedAt: String?
    let customer: KanagrooCustomerData?

    enum CodingKeys: String, CodingKey {
        case id, points, name
        case amount
        case transactionType = "transaction_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case customer
    }
}



final class KangarooCancelCouponRequest: Requestables {
    
    typealias Response =  KangarooCancelCoupon
    
    var path: String {
        return "transactions"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "intent", value: "cancel_ecom_coupon")
        body.appendingQueryParameter(key: "code", value: code)
        body.appendingQueryParameter(key: "customer", value: ["id": customer_id])
        body.appendingQueryParameter(key: "branch", value: ["id": branch_id])
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let code: String
    
    private let customer_id: String
    
    private let branch_id: String
    
    private let token: String
    
    init(code: String, customer_id: String, branch_id: String, token: String){
        self.code = code
        self.customer_id = customer_id
        self.branch_id = branch_id
        self.token = token
    }
}



final class KangarooMultiplyPointsRequest: Requestables {
    
    typealias Response =  KangarooCancelCoupon
    
    var path: String {
        return "transactions"
    }
    
    var httpBody: Data? {
        var body: [String: Any] = [:]
        body.appendingQueryParameter(key: "intent", value: "adjust_points_balance")
        body.appendingQueryParameter(key: "points", value: points)
        body.appendingQueryParameter(key: "reward", value: ["id": reward_id])
        body.appendingQueryParameter(key: "customer", value: ["id": customer_id])
        body.appendingQueryParameter(key: "branch", value: ["id": branch_id])
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
        return jsonData
    }
    
    var headerField: [String: String] {
        var header: [String: Any] = [:]
        header.appendingQueryParameter(key: "Authorization", value: "Bearer \(token)")
        header.appendingQueryParameter(key: "Content-Type", value: "application/json")
        header.appendingQueryParameter(key: "X-Application-Key", value: KangarooRewardsToken.application_key)
        header.appendingQueryParameter(key: "Accept", value: "application/vnd.kangaroorewards.api.v1+json;")
        return header as! [String : String]
    }
    
    var httpMethod: HTTPsMethods {
        return .post
    }
    
    private let points: Int
    
    private let reward_id: String
    
    private let customer_id: String
    
    private let branch_id: String
    
    private let token: String
    
    init(points: Int, customer_id: String, reward_id: String, branch_id: String, token: String){
        self.points = points
        self.reward_id = reward_id
        self.customer_id = customer_id
        self.branch_id = branch_id
        self.token = token
    }
}
