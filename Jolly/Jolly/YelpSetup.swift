//
//  YelpSetup.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/8/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public struct YelpSetup {
    
    let clientId: String
    let clientSecret: String
    //var accessToken: String = ""
    var accessToken: String = ""
    
    init() {
        clientId = "TJ2-D9C19DVSiJhl6UVR3w"
        clientSecret = "XTRFb3rERzJuOCzza2X5OwhOocrhosDRHemzzxtzzyCDylvGESORnKqfC2Hyqv1B"
    }
}

extension YelpSetup : YelpAuthentication {
    mutating func authenticateYelp(with clientID: String, and secret: String, completion: @escaping (String) -> ()){
        let parameters: Parameters =
            [
                "grant_type" : "client_credentials",
                "client_id" : clientId,
                "client_secret": clientSecret
            ]
        
        Alamofire.request("https://api.yelp.com/oauth2/token", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(data)
                    let json = JSON(data)
                    guard let token = json["access_token"].string else {return}
                    completion(token)
                }
                
                
            case .failure(let error):
                print(error)
                completion("")
            }
        }
    }
}
