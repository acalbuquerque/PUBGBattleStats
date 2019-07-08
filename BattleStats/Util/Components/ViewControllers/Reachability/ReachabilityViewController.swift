import UIKit

class ReachabilityViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var label: UILabel!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ReachabilityViewModel()
        topView.backgroundColor = UIColor.orange//viewModel.backgroundColor
        label.attributedText = viewModel.attributedText
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] (timer: Timer) in
            timer.invalidate()
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @IBAction func tapGestureAction(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension Reachable {
    
    func presentReachabilityAlert(fromViewController: UIViewController,
                                  transitioningDelegate: ReachabilityTransitioningDelegate,
                                  completion: (() -> Void)?) {
        
        fromViewController.definesPresentationContext = true
        let viewController = ReachabilityViewController()
        viewController.transitioningDelegate = transitioningDelegate
        viewController.modalPresentationStyle = .overCurrentContext
        fromViewController.present(viewController, animated: true, completion: completion)
    }
}

class ReachabilityTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ReachabilityPresentingAnimatedTransitioning()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ReachabilityDismissingAnimatedTransitioning()
    }
}

class ReachabilityPresentingAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let inTransitionDuration: TimeInterval = 0.5
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        let container = transitionContext.containerView
        
        container.addSubview(toViewController.view)
        
        guard let toView = toViewController.view else { return }
        
        let size = container.bounds.size
        
        toView.frame = CGRect(origin: CGPoint(x: 0, y: -size.height),
                              size: size)
        
        Animation.animate(duration: inTransitionDuration, animationBlock: {
            toView.frame = CGRect(origin: CGPoint.zero, size: size)
        }) { (position: UIViewAnimatingPosition) in
            transitionContext.completeTransition(position == .end)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return inTransitionDuration
    }
}

class ReachabilityDismissingAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    let outTransitionDuration: TimeInterval = 0.25
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let toViewController = transitionContext.viewController(forKey: .from) else { return }
        let container = transitionContext.containerView
        
        container.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        guard let toView = toViewController.view else { return }
        let size = toView.bounds.size
        
        toView.frame = CGRect(origin: CGPoint.zero,
                              size: size)
        
        Animation.animate(duration: outTransitionDuration, animationBlock: {
            toView.frame = CGRect(origin: CGPoint(x: 0, y: -size.height), size: size)
        }) { (position: UIViewAnimatingPosition) in
            transitionContext.completeTransition(position == .end)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return outTransitionDuration
    }
}
