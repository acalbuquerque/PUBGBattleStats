import UIKit

class SearchPlayerBuilder {
    static func build(tabBarController: UITabBarController) -> UIViewController {
        let view = SearchPlayerView()
        let interactor = SearchPlayerInteractor()
        let router = SearchPlayerRouter(tabBarController: tabBarController)
        let presenter = SearchPlayerPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        return view
    }
}
