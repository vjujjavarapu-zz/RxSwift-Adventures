//
//  YelpBusinessCategory.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/9/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import ObjectMapper

class YelpBusinessCategory: Mappable {
    
    var alias: String!
    var title: String!
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        alias <- map["alias"]
        title <- map["title"]
    }
}

