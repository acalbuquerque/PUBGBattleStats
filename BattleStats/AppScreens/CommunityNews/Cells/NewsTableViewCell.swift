import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    
    var viewModel: ViewModel? {
        didSet {
            if let viewModel = viewModel {
                self.contentView.backgroundColor = ColorPalette.Gray50.color
                
                title.attributedText = viewModel.attributedTitle
                title.accessibilityIdentifier = viewModel.attributedTitle.string
                subtitle.attributedText = viewModel.attributedSubtitle
                subtitle.accessibilityIdentifier = viewModel.attributedSubtitle.string
                
                if let imgUrl = URL(string: viewModel.imgUrlStr) {
                    let resource = ImageResource(downloadURL: imgUrl)
                    imgNews.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "imagePlaceholder"))
                }
            }
        }
    }
}

extension  NewsTableViewCell {
    struct ViewModel {
        let attributedTitle: NSAttributedString
        let attributedSubtitle: NSAttributedString
        let imgUrlStr: String
        
        init(title: String, subtitle: String, imgUrlStr: String) {
            
            let attributesTitle = [NSAttributedStringKey.foregroundColor : ColorPalette.black.color,
                                   NSAttributedStringKey.font : Fonts.font(family: .RobotoBold, size: .pSmall30)]
            self.attributedTitle = NSAttributedString(string: title, attributes: attributesTitle)
            
            let attributesSubtitle = [NSAttributedStringKey.foregroundColor : ColorPalette.Gray200.color,
                                      NSAttributedStringKey.font : Fonts.font(family: .RobotoRegular, size: .pxSmall)]
            self.attributedSubtitle = NSAttributedString(string: subtitle, attributes: attributesSubtitle)
            
            self.imgUrlStr = imgUrlStr
        }
    }
}
