import UIKit

class GameModeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gmTitle: UILabel!
    @IBOutlet weak var longestKill: UILabel!
    @IBOutlet weak var kills: UILabel!
    @IBOutlet weak var assists: UILabel!
    @IBOutlet weak var dbnos: UILabel!
    @IBOutlet weak var rounds: UILabel!
    @IBOutlet weak var top10: UILabel!
    @IBOutlet weak var wins: UILabel!
    @IBOutlet weak var losses: UILabel!
    
    var viewModel: ViewModel? {
        didSet {
            if let viewModel = viewModel {
                self.contentView.backgroundColor = ColorPalette.Gray50.color
                
                gmTitle.attributedText = viewModel.attributedGMTitle
                gmTitle.accessibilityIdentifier = viewModel.attributedGMTitle.string
                
                longestKill.attributedText = viewModel.attributedLongestKills
                longestKill.accessibilityIdentifier = viewModel.attributedLongestKills.string
                
                kills.attributedText = viewModel.attributedKills
                kills.accessibilityIdentifier = viewModel.attributedKills.string
                
                assists.attributedText = viewModel.attributedAssists
                assists.accessibilityIdentifier = viewModel.attributedAssists.string
                
                dbnos.attributedText = viewModel.attributedDbnos
                dbnos.accessibilityIdentifier = viewModel.attributedDbnos.string
                
                rounds.attributedText = viewModel.attributedRounds
                rounds.accessibilityIdentifier = viewModel.attributedRounds.string
                
                top10.attributedText = viewModel.attributedTop10
                top10.accessibilityIdentifier = viewModel.attributedTop10.string
                
                wins.attributedText = viewModel.attributedWins
                wins.accessibilityIdentifier = viewModel.attributedWins.string
                
                losses.attributedText = viewModel.attributedLosses
                losses.accessibilityIdentifier = viewModel.attributedLosses.string
            }
        }
    }
}

extension  GameModeTableViewCell {
    struct ViewModel {
        let attributedGMTitle: NSAttributedString
        let attributedLongestKills: NSAttributedString
        let attributedKills: NSAttributedString
        let attributedAssists: NSAttributedString
        let attributedDbnos: NSAttributedString
        let attributedRounds: NSAttributedString
        let attributedTop10: NSAttributedString
        let attributedWins: NSAttributedString
        let attributedLosses: NSAttributedString

        init(gmTitle: String,
             longestKill: Float,
             kills: Int,
             assists: Int,
             dbnos: Int,
             rounds: Int,
             top10: Int,
             wins: Int,
             losses: Int) {
            
            let labelLongestKill = String(format: "Longest Kill: %.2f meters", longestKill)
            let labelKills = String(format: "Kills: %i", kills)
            let labelAssists = String(format: "Assists: %i", assists)
            let labelDBNOs = String(format: "dBNOs: %i", dbnos)
            let labelRounds = String(format: "Rounds: %i", rounds)
            let labelTop10 = String(format: "Top10: %i", top10)
            let labelWins = String(format: "Wins: %i", wins)
            let labelLosses = String(format: "Losses: %i", losses)
            
            let attributesGMTitle = [NSAttributedStringKey.foregroundColor : ColorPalette.black.color,
                                   NSAttributedStringKey.font : Fonts.font(family: .RobotoBold, size: .pSmall30)]
            self.attributedGMTitle = NSAttributedString(string: gmTitle, attributes: attributesGMTitle)
            
            let attributesOthers = [NSAttributedStringKey.foregroundColor : ColorPalette.Gray300.color,
                                      NSAttributedStringKey.font : Fonts.font(family: .RobotoRegular, size: .pxSmall)]

            self.attributedLongestKills = NSAttributedString(string: labelLongestKill, attributes: attributesOthers)
            self.attributedKills = NSAttributedString(string: labelKills, attributes: attributesOthers)
            self.attributedAssists = NSAttributedString(string: labelAssists, attributes: attributesOthers)
            self.attributedDbnos = NSAttributedString(string: labelDBNOs, attributes: attributesOthers)
            self.attributedRounds = NSAttributedString(string: labelRounds, attributes: attributesOthers)
            self.attributedTop10 = NSAttributedString(string: labelTop10, attributes: attributesOthers)
            self.attributedWins = NSAttributedString(string: labelWins, attributes: attributesOthers)
            self.attributedLosses = NSAttributedString(string: labelLosses, attributes: attributesOthers)
        }
    }
}
