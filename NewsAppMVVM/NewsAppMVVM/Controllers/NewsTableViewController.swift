//
//  NewsTableViewController.swift
//  NewsAppMVVM
//
//  Created by Mohammad Azam on 3/13/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NewsTableViewController: UITableViewController {
    let disposeBag = DisposeBag()
    private var articleListVM: ArticleListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        populateNews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM == nil ? 0: self.articleListVM.articlesVM.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtcileTableViewCell", for: indexPath) as? ArticleTableViewCell else {
            fatalError("ArtcileTableViewCell is not found")
        }
        
        let article = self.articleListVM.articleAt(indexPath.row)
        
        article.title.asDriver(onErrorJustReturn: "")
            .drive(cell.title.rx.text)
            .disposed(by: disposeBag)
        article.description.asDriver(onErrorJustReturn: "")
            .drive(cell.desc.rx.text)
            .disposed(by: disposeBag)
        
        return cell
    }
    
    private func populateNews() {
        let resource = Resource<ArticleResponse>(url: URL(string: "https://newsapi.org/v2/everything?q=apple&from=2022-06-26&to=2022-06-26&sortBy=popularity&apiKey=56c9ef3908f540898aa5af0fdecb99ff")!)
        
        URLRequest.load(resource: resource)
            .subscribe(onNext: { articleResponse in
                let articles =  articleResponse.articles
                self.articleListVM = ArticleListViewModel(articles)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
    }
    
}
