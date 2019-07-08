import Foundation
import UIKit

// Contains all fonts
struct Fonts {
    fileprivate static let scale: CGFloat = 2
    
}

extension Fonts {
    static func font(family: Fonts.family, size: Fonts.size) -> UIFont {
        
        guard let customFont = UIFont(name: family.name, size: size.inPoints) else {
            fatalError(String(format: "Failed to load the %@ font and size %f .", family.name, size.inPoints))
        }
        return customFont
    }
    
    enum size {
        /// - 36pt
        /// - 72px
        case title1
        
        /// - 28pt
        /// - 56px
        case title2
        
        /// - 24pt
        /// - 48px
        case pNormal
        
        /// - 22pt
        /// - 44px
        case pNormal44
        
        /// - 18pt
        /// - 36px
        case pSmall
        
        /// - 17pt
        /// - 34px
        case pSmall34
        
        /// - 16pt
        /// - 32px
        case pSmall32
        
        /// - 15pt
        /// - 30px
        case pSmall30
        
        /// - 14pt
        /// - 28px
        case psSmall
        
        /// - 13pt
        /// - 26px
        case pxSmall
        
        /// - 12pt
        /// - 24px
        case pxSmall24
        
        /// - 11pt
        /// - 22px
        case pxxSmall
        
        /// - 10pt
        /// - 20px
        case pTiny
        
        var inPoints: CGFloat {
            
            switch self {
            case .title1:
                return 72 / Fonts.scale
            case .title2:
                return 56 / Fonts.scale
            case .pNormal:
                return 48 / Fonts.scale
            case .pNormal44:
                return 44 / Fonts.scale
            case .pSmall:
                return 36 / Fonts.scale
            case .pSmall34:
                return 34 / Fonts.scale
            case .pSmall32:
                return 32 / Fonts.scale
            case .pSmall30:
                return 30 / Fonts.scale
            case .psSmall:
                return 28 / Fonts.scale
            case .pxSmall:
                return 26 / Fonts.scale
            case .pxSmall24:
                return 24 / Fonts.scale
            case .pxxSmall:
                return 22 / Fonts.scale
            case .pTiny:
                return 20 / Fonts.scale
            }
        }
    }
    
    enum family {
        case RobotoBlack
        case RobotoBlackItalic
        case RobotoBold
        case RobotoBoldItalic
        case RobotoItalic
        case RobotoLight
        case RobotoLightItalic
        case RobotoMedium
        case RobotoMediumItalic
        case RobotoRegular
        case RobotoThin
        case RobotoThinItalic
        
        var name: String {
            switch self {
            case .RobotoBlack:
                return "Roboto-Black"
            case .RobotoBlackItalic:
                return "Roboto-BlackItalic"
            case .RobotoBold:
                return "Roboto-Bold"
            case .RobotoBoldItalic:
                return "Roboto-BoldItalic"
            case .RobotoItalic:
                return "Roboto-Italic"
            case .RobotoLight:
                return "Roboto-Light"
            case .RobotoLightItalic:
                return "Roboto-LightItalic"
            case .RobotoMedium:
                return "Roboto-Medium"
            case .RobotoMediumItalic:
                return "Roboto-MediumItalic"
            case .RobotoRegular:
                return "Roboto-Regular"
            case .RobotoThin:
                return "Roboto-Thin"
            case .RobotoThinItalic:
                return "Roboto-ThinItalic"
            }
        }
    }
}

