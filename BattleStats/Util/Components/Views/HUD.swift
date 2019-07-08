import Foundation
import JGProgressHUD

class HUD: JGProgressHUD {
    convenience init(style: Style) {
        self.init(style: JGProgressHUDStyle(rawValue: style.rawValue) ?? .dark)
    }
    
    enum Style: UInt {
        case extraLight
        case light
        case darkGray
    }
}
