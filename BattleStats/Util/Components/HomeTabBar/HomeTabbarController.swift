import UIKit

class HomeTabBarController: UITabBarController {
    
    init(communityRouterDelegate: CommunityNewsRouterInterface) {

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         * News
         */
        let newsViewController = CommunityNewsBuilder.build(tabBarController: self)
        let newsTabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0) // TODO: change to custom icon
        newsViewController.tabBarItem = newsTabBarItem
        let newsNavigationController = UINavigationController(rootViewController: newsViewController)
        /*
         * Search
         */
        let shardsModesViewController = SearchPlayerBuilder.build(tabBarController: self)
        let shardsModeTabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0) // TODO: change to custom icon
        shardsModesViewController.tabBarItem = shardsModeTabBarItem
        let shardsModeNavigationController = UINavigationController(rootViewController: shardsModesViewController)
        
        viewControllers = [newsNavigationController,shardsModeNavigationController]
    }
}

