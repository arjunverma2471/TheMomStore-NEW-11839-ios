//
//  ShipwayApiConstant.swift
//  MageNative Shopify App
//
//  Created by Manohar Singh Rawat on 07/07/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
class ShipwayApiConstant{
    private init(){}
    static let shared = ShipwayApiConstant()
    func getShipwayTrackingApi(orderId: String)->URL{
        return URL(string: "https://\(Client.shopUrl)/apps/shipway_track?order_tracking=\(orderId)")!
    }
}
