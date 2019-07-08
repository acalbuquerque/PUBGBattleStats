import UIKit

class CommunityNewsBuilder {
    static func build(tabBarController: UITabBarController) -> UIViewController {
        let view = CommunityNewsView()
        let interactor = CommunityNewsInteractor()
        let router = CommunityNewsRouter(tabBarController: tabBarController)
        let presenter = CommunityNewsPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        return view
    }
}
