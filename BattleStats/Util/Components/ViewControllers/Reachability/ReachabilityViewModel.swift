import Foundation
import UIKit

struct ReachabilityViewModel {
    let attributedText: NSAttributedString = {
        
        let string = NSLocalizedString("alert.title.noConnection", comment: "")
        //let attributes = []
        return NSAttributedString(string: string, attributes: nil)
    }()
}
