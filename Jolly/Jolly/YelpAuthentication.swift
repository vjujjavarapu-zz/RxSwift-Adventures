//
//  YelpAuthentication.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/8/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import Foundation


protocol YelpAuthentication {
    mutating func authenticateYelp(with clientID: String, and secret: String, completion:@escaping (String) -> ())
}
