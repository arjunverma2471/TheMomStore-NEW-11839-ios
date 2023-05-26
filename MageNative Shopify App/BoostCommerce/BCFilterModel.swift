//
//  BCFilterModel.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 28/12/22.
//  Copyright © 2022 MageNative. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BCFilterModel{
    var total_product : Int
    var products : [BCFilterProductModel]
    var total_page : Int
    var event_type : String
    var from_cache : Bool
    var total_collection : Int
    var filterOptions : [FilterOptions]
    init(json:JSON){
        total_product = json["total_product"].intValue
        products = json["products"].arrayValue.map{BCFilterProductModel(json: $0)}
        total_page = json["total_page"].intValue
        event_type = json["event_type"].stringValue
        from_cache = json["from_cache"].boolValue
        total_collection = json["total_collection"].intValue
        filterOptions = json["filter"]["options"].arrayValue.map{FilterOptions(json: $0)}
    }
}
//MARK: FilterProducts
struct BCFilterProductModel{
    var id : Int?
    init(json:JSON){
        id = json["id"].intValue
    }
}

//MARK: FILTER OPTIONS
struct FilterOptions{
    var valueType : String
    var displayAllValuesInUppercaseForm : Bool
    var removeTextFilterValues : String
    var position : Int
  //  "excludedValues":[ ],
    //var tooltip : null,
    var filterOptionId : String
    var status : String
    var swatchStyle : String
    var values : [OptionItemValues]
    var priceRange : PriceRange
    var displayType : String
    var label : String
    //var replaceTextFilterValues :null,
    var isCollapseMobile : Bool
    var showMoreType : String
    var selectType : String
    var sortManualValues : Bool
    var isCollapsePC : Bool
    var showSearchBoxFilterPC : Bool
        // "manualValues":[OptionItemValues]
    var showSearchBoxFilterMobile : Bool
    var sortType : String
    var filterType : String
    init(json:JSON){
        valueType = json["valueType"].stringValue
        displayAllValuesInUppercaseForm = json["displayAllValuesInUppercaseForm"].boolValue
        removeTextFilterValues = json["removeTextFilterValues"].stringValue
        position = json["position"].intValue
        filterOptionId = json["filterOptionId"].stringValue
        status = json["status"].stringValue
        swatchStyle = json["swatchStyle"].stringValue
        values = json["values"].arrayValue.map{ OptionItemValues(json: $0)}
        priceRange = PriceRange(json:json["values"])
        displayType = json["displayType"].stringValue
        label = json["label"].stringValue
        isCollapseMobile = json["isCollapseMobile"].boolValue
        showMoreType = json["showMoreType"].stringValue
        selectType = json["selectType"].stringValue
        sortManualValues = json["sortManualValues"].boolValue
        isCollapsePC = json["isCollapsePC"].boolValue
        showSearchBoxFilterPC = json["showSearchBoxFilterPC"].boolValue
        showSearchBoxFilterMobile = json["showSearchBoxFilterMobile"].boolValue
        sortType = json["sortType"].stringValue
        filterType = json["filterType"].stringValue
    }
}
struct OptionItemValues{
    var key : String
    var label : String
    var handle : String
    var tags : Int
    var doc_count : Int
    init(json:JSON){
        key = json["key"].stringValue
        label = json["label"].stringValue
        handle = json["handle"].stringValue
        tags = json["tags"].intValue
        doc_count = json["doc_count"].intValue
        
    }
}


struct PriceRange{
    var max: Double
    var min: Double
    init(json:JSON){
        max = json["max"].doubleValue
        min = json["min"].doubleValue
    }
}
struct SelectedFilterModel{
    var isSelected: Bool
    var selectedIndex: Int
    var selectedFilter: FilterOptions
    
//    init(json:JSON){
//        isSelected = json["isSelected"].boolValue
//        selectedIndex = json["selectedIndex"].intValue
//        selectedFilter = FilterOptions(json: json)
//    }
}
