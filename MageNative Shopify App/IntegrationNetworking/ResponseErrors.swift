//
//  ResponseErrors.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

public enum ResponseErrors: Error {
    case unacceptableStatusCode(Int)
    case unexpectedResponse(Any)
}
