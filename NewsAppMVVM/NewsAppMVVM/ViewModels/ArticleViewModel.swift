import Foundation
import RxSwift
import RxCocoa


struct ArticleListViewModel {
    let articlesVM: [ArticleViewModel]
}

struct ArticleViewModel {
    let article: Article
    
    init(_ article: Article) {
        self.article = article
    }
}

extension ArticleListViewModel {
    init(_ articles: [Article]) {
        self.articlesVM = articles.compactMap(ArticleViewModel.init)
    }
    
    func articleAt(_ index: Int) -> ArticleViewModel {
        return self.articlesVM[index]
    }
}

extension ArticleViewModel {
    var title: Observable<String> {
        return Observable<String>.just(article.title)
    }
    
    var description: Observable<String> {
        return Observable<String>.just(article.title.description)
    }
}
