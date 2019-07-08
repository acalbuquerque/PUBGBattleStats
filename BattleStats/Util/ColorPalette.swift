import UIKit

enum ColorPalette: String {
    case white, whiteSmoke
    case black
    case grayChateau
    case coral
    case Gray50, Gray100, Gray150, Gray200, Gray300
}

extension ColorPalette {
    var color: UIColor {
        switch self {
            case .white:
                return UIColor(withHexColor: "FAFAFA")!
            case .whiteSmoke:
                return UIColor(withHexColor: "ECEEF6")!
            
            case .Gray50:                       return UIColor(withHexColor: "F3F5FD")!
            case .Gray100:                      return UIColor(withHexColor: "ECEEF6")!
            case .Gray150:                      return UIColor(withHexColor: "DEE0E8")!
            case .Gray200:                      return UIColor(withHexColor: "BBBDC5")!
            case .Gray300:                      return UIColor(withHexColor: "73757D")!
            
            case .coral:
                return UIColor(withHexColor: "ffbc00")!
            case .grayChateau:
                return UIColor(red: 163, green: 164, blue: 168, alpha: 1.0)
            case .black:
                return UIColor(red: 61.0 / 255.0, green: 57.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0)
        }
    }
}
