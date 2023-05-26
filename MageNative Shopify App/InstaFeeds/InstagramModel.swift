//
//  InstagramModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 07/06/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation

//MARK:- Instagram Feed
struct Feed: Codable {
    var data: [InstagramMedia]
   // var paging : PagingData
}


struct PagingData: Codable {
    var cursors: CursorData
   // var next: String
}

struct CursorData: Codable {
    var before: String
    var after: String
}

struct InstagramMedia: Codable {
      var id: String
    //  var media_type: MediaType
      var media_url: String
    var username: String
     // var timestamp: String //"2017-08-31T18:10:00+0000"
      var permalink : String
    var caption: String?
}

//enum MediaType: String,Codable {
//    case IMAGE
//    case VIDEO
//    case CAROUSEL_ALBUM
//}
