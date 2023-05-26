//
//  ImageViewModel.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation


final class ProductMediaViewModel: ViewModel {
  
  typealias ModelType = MobileBuySDK.Storefront.MediaEdge
  
  let model:    ModelType?
  let cursor:   String
  var arUrl: String
  var embeddedUrlExternalVideo : String
  var videoUrl : String
  var type:MobileBuySDK.Storefront.MediaContentType
  var imageUrl: String
  var videoPreviewImage:String
  var arPreviewImage:String
  
  // ----------------------------------
  //  MARK: - Init -
  //
  required init(from model: ModelType) {
    self.model    = model
    self.cursor   = model.cursor
    self.arUrl = ""
    self.embeddedUrlExternalVideo = ""
    self.videoUrl = ""
    self.imageUrl = ""
    self.videoPreviewImage = ""
    self.arPreviewImage = ""
    self.type = model.node.mediaContentType
    
    if(model.node.mediaContentType == .model3d){
      if let node = model.node as? MobileBuySDK.Storefront.Model3d{
        self.arPreviewImage = node.previewImage?.url.description ?? ""
        let sources = node.sources
        for index in sources{
          if(index.format == "usdz"){
            self.arUrl = index.url
          }
        }
      }
    }
    
      if(model.node.mediaContentType == .externalVideo){
      if let node = model.node as? MobileBuySDK.Storefront.ExternalVideo {
          self.embeddedUrlExternalVideo = node.originUrl.description
      }
    }
    
    if(model.node.mediaContentType == .video){
      if let node = model.node as? MobileBuySDK.Storefront.Video{
        self.videoUrl = node.sources[0].url
       self.videoPreviewImage = node.previewImage?.url.description ?? ""
      }
    }
    
    if(model.node.mediaContentType == .image){
      if let node = model.node as? MobileBuySDK.Storefront.MediaImage {
        self.imageUrl = node.image?.url.description ?? ""
      }
    }
  }
}

extension MobileBuySDK.Storefront.MediaEdge: ViewModeling {
  typealias ViewModelType = ProductMediaViewModel
}
