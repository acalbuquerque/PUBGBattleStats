import Foundation
import Reachability

protocol ReachableInterface {
    var isInternetAvailable: Bool { get }
    
    func presentReachabilityAlert(fromViewController: UIViewController,
                                  transitioningDelegate: ReachabilityTransitioningDelegate,
                                  completion: (() -> Void)?)
}

class Reachable: ReachableInterface {
    static let shared = Reachable()
    var isInternetAvailable: Bool = true
    private var reachability: Reachability
    
    private init() {
        reachability =  Reachability(hostname: "google.com")!
        reachability.whenReachable = { status in
            self.isInternetAvailable = true
        }
        reachability.whenUnreachable = { status in
            self.isInternetAvailable = false
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
