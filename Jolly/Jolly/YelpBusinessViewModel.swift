//
//  YelpBusinessViewModel.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/8/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import RxCocoa
import ObjectMapper
import Alamofire
import SwiftyJSON


struct YelpBusinessViewModel {
    
    lazy var rx_yelprichbusinessdetails : Driver<[YelpBusiness]> = self.fetchYelpBusinesses()
    lazy var rx_fetchDetails : Driver<YelpRichBusinessDetail> = self.fetchAllDetails()
    fileprivate var term: Observable<String>
    fileprivate var loadNextPage: Observable<Bool>
    var accessToken: String = ""
    var selectedBusiness: Variable<YelpBusiness?> = Variable(nil)
    var reachedBottom = Variable(false)
    fileprivate var currentBusinessSelected: Observable<YelpBusiness?>
    
    var bag = DisposeBag()
    init(withTermObservable termObservable: Observable<String>, withNextPageObservable nextpageObservable: Observable<Bool>) {
        self.term = termObservable
        self.loadNextPage = nextpageObservable
        self.currentBusinessSelected = self.selectedBusiness.asObservable()
    }
  
    fileprivate func fetchAllDetails() -> Driver<YelpRichBusinessDetail> {
       return currentBusinessSelected
            .subscribeOn(MainScheduler.instance) // Make sure we are on MainScheduler
            .do(onNext: { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest{ (yb) -> Observable<(HTTPURLResponse, Any)> in
               let urlString =   "https://api.yelp.com/v3/businesses/\(yb!.id!)"
                return RxAlamofire
                    .requestJSON(.get,urlString, encoding: URLEncoding.default, headers: ["Authorization" : "Bearer \(self.accessToken)"])
                    .debug()
                    .catchError { error in
                        return Observable.never()
                }
        }.map { (response, json) -> YelpRichBusinessDetail in // again back to .background, map objects
                let json = json as! [String: Any]
                if let yelpbusinesses = Mapper<YelpRichBusinessDetail>().map(JSON: json) {
                    return yelpbusinesses
                } else {
                    return YelpRichBusinessDetail(JSON: [:])!
                    
                }
        }
        .observeOn(MainScheduler.instance) // switch to MainScheduler, UI updates
        .do(onNext: { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }).asDriver(onErrorJustReturn: YelpRichBusinessDetail(JSON: [:])!)
    }
    
    
    
  
    fileprivate func fetchYelpBusinesses() -> Driver<[YelpBusiness]> {
        // work in progress - loadnextpage for pagination and add next set of data to the driver!
//        let obs = Observable.zip(term,loadNextPage){
//            return ($0,$1)
//        }
//        
        return term
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { text in
                return RxAlamofire
                    .requestJSON(.get, "https://api.yelp.com/v3/businesses/search", parameters: ["term": text, "location" : "New York", "limit" : 50], encoding: URLEncoding.default, headers: ["Authorization" : "Bearer \(self.accessToken)"])
                    .debug()
                    .catchError { error in
                        return Observable.never()
                }
            }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response, json) -> [YelpBusiness] in
                let json = json as! [String: Any]
                
                if let yelpbusinesses = Mapper<YelpBusiness>().mapArray(JSONObject: json["businesses"]) {
                    return yelpbusinesses
                } else {
                    return []
                }
            }
            .observeOn(MainScheduler.instance)
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: [])
    }

      

}
