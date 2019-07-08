import Foundation

protocol CommunityNewsPresenterInterface: class {
    
    var interactor: CommunityNewsInteractorInterface { get }
    var router: CommunityNewsRouterInterface { get }
    var view: CommunityNewsViewInterface { get }
    
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func goToNews(index: Int)
}

class CommunityNewsPresenter {

    unowned let view: CommunityNewsViewInterface
    private let reachable: ReachableInterface
    let router: CommunityNewsRouterInterface
    var interactor: CommunityNewsInteractorInterface
    var news = [News]()
    
    init(view: CommunityNewsViewInterface,
         interactor: CommunityNewsInteractorInterface,
         router: CommunityNewsRouterInterface,
         reachable: ReachableInterface = Reachable.shared) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.reachable = reachable
    }
}

extension CommunityNewsPresenter: CommunityNewsPresenterInterface{
    func viewDidAppear(_ animated: Bool) {
        
        if !reachable.isInternetAvailable {
            router.presentReachabilityAlert(completion: nil)
            return
        }
        
        router.showHUD()
        
        interactor.getNews { (result) in
            switch result {
            case . success(let news):
                self.news = news
                let viewModels = news.map({ (data) -> NewsTableViewCell.ViewModel in
                    if let subtitle = data.subtitle {
                        return NewsTableViewCell.ViewModel.init(title: data.title, subtitle: subtitle, imgUrlStr: data.imageURL)
                    }
                    return NewsTableViewCell.ViewModel.init(title: data.title, subtitle: data.type, imgUrlStr: data.imageURL)
                })
                self.view.configure(viewModels: viewModels)
                
            case .failure(_):
                break
            }
            self.router.dismissHUD(animated: true)
        }
    }
    
    func viewWillDisappear(_ animated: Bool) {
        self.router.dismissHUD(animated: animated)
    }
    
    func goToNews(index: Int) {
        router.goToNews(fromViewInterface: view, news: news[index])
    }
}
