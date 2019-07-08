import Foundation
import UIKit

struct Animation {
    
    enum Curve {
        case primary
        case secondly
        
        var controlPoints: (point1: CGPoint, point2: CGPoint) {
            switch self {
            case .primary:
                return (CGPoint(x: 0.65, y: 0), CGPoint(x: 0.25, y: 1))
            case .secondly:
                return (CGPoint.zero, CGPoint(x: 0.06, y: 1))
            }
        }
    }
    
    static func animate(withCurve curve: Curve = .primary,
                        duration: TimeInterval = 1,
                        delay: TimeInterval = 0,
                        animationBlock: @escaping () -> Void,
                        completionBlock: ((UIViewAnimatingPosition) -> Void)? = nil) {
        
        let animator = UIViewPropertyAnimator(duration: duration,
                                              controlPoint1: curve.controlPoints.point1,
                                              controlPoint2: curve.controlPoints.point2,
                                              animations: animationBlock)
        animator.startAnimation(afterDelay: delay)
        if let completion = completionBlock {
            animator.addCompletion(completion)
        }
    }
    
    static func shake(view: UIView) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
}

func animationOptionsFromCurve(curve: UIViewAnimationCurve) -> UIViewAnimationOptions {
    
    let options: UIViewAnimationOptions
    switch curve {
    case .easeIn:
        options = .curveEaseIn
    case .easeInOut:
        options = .curveEaseInOut
    case .easeOut:
        options = .curveEaseOut
    default:
        options = .curveLinear
    }
    return options
}

