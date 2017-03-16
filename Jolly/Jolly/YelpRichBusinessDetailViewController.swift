//
//  YelpRichBusinessDetailViewController.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/15/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cosmos
import Kingfisher

class YelpRichBusinessDetailViewController: UIViewController {

    @IBOutlet weak var businessImageView: UIImageView!
  
    @IBOutlet weak var businessName: UILabel!
    
    @IBOutlet weak var businessStarCosmos: CosmosView!
    
    @IBOutlet weak var businessPriceDollar: UILabel!
    
    var yelpBusinessViewModel: YelpBusinessViewModel!
    var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        businessStarCosmos.isHidden = true
        rxSetup()
   }
    
    func rxSetup() {
        yelpBusinessViewModel
            .rx_fetchDetails
            .asObservable()
            .subscribe(onNext: { [weak self] (yrb) in
                self?.populateData(yrb: yrb)
            }).addDisposableTo(bag)
    }
    
    func populateData(yrb : YelpRichBusinessDetail){
        self.title = yrb.name
        businessImageView.kf.setImage(with: URL(string: yrb.imageUrl))
        businessName.text = yrb.name
        businessStarCosmos.isHidden = false
        businessStarCosmos.rating = yrb.rating
        businessPriceDollar.text = yrb.price
    }
    
}
