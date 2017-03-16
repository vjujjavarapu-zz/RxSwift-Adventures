//
//  YelpBusinessCoordinate.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/9/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import ObjectMapper

class YelpBusinessCoordinate: Mappable {
    
    var latitude: Double!
    var longitude: Double!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}
