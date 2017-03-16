//
//  YelpRichBusinessDetail.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/9/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import ObjectMapper

class YelpRichBusinessDetail: Mappable {
    var name: String!
    var id: String!
    var imageUrl: String!
    var isClaimed: Bool!
    var isClosed: Bool!
    var price: String!
    var rating: Double!
    var reviewCount: Int!
    var phone: String!
    var categories: YelpBusinessCategory!
    
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        imageUrl <- map["photos.0.2"]
        isClaimed <- map["is_claimed"]
        isClosed <- map["is_closed"]
        price <- map["price"]
        rating <- map["rating"]
        reviewCount <- map["review_count"]
        phone <- map["phone"]
        categories <- map["categories.0"]
     }
}
