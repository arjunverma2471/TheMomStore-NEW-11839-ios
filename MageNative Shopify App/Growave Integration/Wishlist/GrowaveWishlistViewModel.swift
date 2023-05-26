//
//  GrowaveWishlistViewModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 23/02/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import Foundation
class GrowaveWishlistViewModel: NSObject {
    
    var boards = [GrowaveBoardListData]()
    let tokenHandler = GrowaveTokenHandler()
    var wishlistItems = [GraphQL.ID]()
    
    
    func fetchBoards(completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            guard let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String, let safeToken = token else {return}
            let request = GrowaveBoardListRequest(user_id: userID, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let boards = result.data {
                        self?.boards = boards
                        completion(.success(true))
                    }
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func createBoard(title: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            guard let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String, let safeToken = token else {return}
            let request = GrowaveCreateBoardRequest(user_id: userID, token: safeToken, title: title)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    completion(.success(true))
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func deleteBoard(boardId: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            guard let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String, let safeToken = token else {return}
            let request = GrowaveDeleteBoardRequest(user_id: userID, board_id: boardId, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    completion(.success(true))
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func modifyBoard(boardId: String, title: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            guard let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String, let safeToken = token else {return}
            let request = GrowaveModifyBoardRequest(user_id: userID, token: safeToken, title: title, board_id: boardId)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    completion(.success(true))
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    
    func addToWishlist(productId: String, boardId: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            guard let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String, let safeToken = token else {return}
            let request = GrowaveAddWishlistRequest(user_id: userID, token: safeToken, product_id: productId, board_id: boardId)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    completion(.success(true))
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func fetchWishlistItems(boardId: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            guard let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String, let safeToken = token else {return}
            let request = GrowaveWishlistRequest(user_id: userID, token: safeToken, board_id: boardId)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let items = result.data {
                        if items.count > 0 {
                            self?.wishlistItems = [GraphQL.ID]()
                            items.forEach { item in
                                if let safeItem = item.productID {
                                    let id = "gid://shopify/Product/\(safeItem)"
                                    let graphId = GraphQL.ID(rawValue: id)
                                    self?.wishlistItems.append(graphId)
                                }
                            }
                            completion(.success(true))
                        }
                    }
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func deleteGrowaveItem(product_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            guard let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String, let safeToken = token else {return}
            let request = DeleteGrowaveWishlistRequest(user_id: userID, token: safeToken, product_id: product_id)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let status = result.status {
                        if status == 200 {
                            completion(.success(true))
                        }
                    }
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
    
    func moveProductToBoard(product_id: String, current_board_id: String, destination_board_id: String, completion: @escaping (RequestsResult<Bool, String>) -> ()) {
        tokenHandler.generateTokenGrowave { token in
            guard let userID = UserDefaults.standard.value(forKey: "growaveUserId") as? String, let safeToken = token else {return}
            let request = GrowaveMoveItem(user_id: userID, product_id: product_id, current_board_id: current_board_id, destination_board_id: destination_board_id, token: safeToken)
            IntegrationsNetworking.shared.send(request) {[weak self] response in
                switch response {
                case .success(let result):
                    if let status = result.status {
                        if status == 200 {
                            completion(.success(true))
                        }
                    }
                case .failed(let err):
                    let err = (String (describing: err))
                    completion(.failed(err))
                }
            }
        }
    }
}
