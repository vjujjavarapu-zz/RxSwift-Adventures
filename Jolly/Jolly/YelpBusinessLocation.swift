//
//  YelpBusinessLocation.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/9/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import ObjectMapper

class YelpBusinessLocation: Mappable {
    
    var address1: String!
    var address2: String?
    var address3: String?
    var city: String!
    var state: String!
    var zipCode: String!
    var country: String!
    var crossStreets: String!
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        address1 <- map["address1"]
        address2 <- map["address2"]
        address3 <- map["address3"]
        city <- map["city"]
        state <- map["state"]
        zipCode <- map["zip_code"]
        country <- map["country"]
        crossStreets <- map["cross_streets"]
    }
}
