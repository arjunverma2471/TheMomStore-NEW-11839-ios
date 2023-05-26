//
//  Results.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 20/01/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation

public enum RequestsResult<T, E> {
    case success(T)
    case failed(E)
    
    var isSuccess: Bool {
        if case .success(_) = self {
            return true
        }
        return false
    }
    
    var isFailed: Bool {
        if case .failed(_) = self {
            return true
        }
        return false
    }
}
