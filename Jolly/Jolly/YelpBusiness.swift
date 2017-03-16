//
//  YelpBusiness.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/16/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import ObjectMapper

class YelpBusiness: Mappable {
    var name: String!
    var id: String!
    var imageUrl: String!


    required init?(map: Map) { }

    func mapping(map: Map) {
    name <- map["name"]
    id <- map["id"]
    imageUrl <- map["image_url"]
    }

}
