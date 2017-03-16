//
//  ViewController.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/8/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher



class ViewController: UIViewController {
    
    static let startLoadingOffset: CGFloat = 20.0
    static func isNearTheBottomEdge(_ contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var businessesTableView: UITableView!
    var reachedBottom = false
    let bag = DisposeBag()
    var yelpBusinessViewModel: YelpBusinessViewModel!
    
    var rx_searchBarText: Observable<String> {
        return searchBar.rx.text
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0.characters.count > 0 }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    var loadNextPage : Observable<Bool> {
        
            return businessesTableView.rx.contentOffset
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMap { offset -> Observable<Bool> in
                if ViewController.isNearTheBottomEdge(offset, self.businessesTableView){
                    return Observable.just(true)
                }else{
                    return Observable.just(false)
                }
        }
 }
    
    var rx_reachedBottom = Variable(false)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Jolly"
        self.searchBar.placeholder = "Type any character or a word for a business"
       var ys = YelpSetup()
        ys.authenticateYelp(with: ys.clientId, and: ys.clientSecret) {[unowned self] (accessToken) in
            self.yelpBusinessViewModel = YelpBusinessViewModel(withTermObservable: self.rx_searchBarText, withNextPageObservable: self.loadNextPage)
            self.yelpBusinessViewModel.accessToken = accessToken
            self.rxSetup()
        }
       
    }
    
    func rxSetup() {
        
        yelpBusinessViewModel
            .rx_yelprichbusinessdetails
            .drive(businessesTableView.rx.items) { (tv, i, yelpBusiness) in
                let cell = tv.dequeueReusableCell(withIdentifier: "ybCell", for: IndexPath(row: i, section: 0)) as! YBCell
                cell.ybName?.text = yelpBusiness.name
                cell.ybImage?.kf.setImage(with: URL(string: yelpBusiness.imageUrl))
                
                return cell
            }
            .addDisposableTo(bag)
        

        
        businessesTableView.rx
        .modelSelected(YelpBusiness.self)
            .bindTo(yelpBusinessViewModel.selectedBusiness)
            .addDisposableTo(bag)
        
        
        businessesTableView
                .rx
                .modelSelected(YelpBusiness.self)
                .subscribe(onNext: {[weak self] (yb) in
                 self?.performSegue(withIdentifier: "showRichBusiness", sender: self)
                                if let selectedRowIndexPath = self?.businessesTableView.indexPathForSelectedRow {
                                    self?.businessesTableView.deselectRow(at: selectedRowIndexPath, animated: true)
                                }
        }).addDisposableTo(bag)
        
        
        
 }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRichBusiness"{
            guard let destination = segue.destination as? YelpRichBusinessDetailViewController else { return }
            print(destination)
            guard let sender = sender as? ViewController else { return }
            destination.yelpBusinessViewModel = sender.yelpBusinessViewModel
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

