import UIKit
import Eureka

protocol SearchPlayerViewInterface: BaseViewControllerInterface {
    var presenter: SearchPlayerPresenterInterface? { get set }
    func setupForm(with seasons:[SeasonViewModel.ViewModel])
}

class SearchPlayerView: FormViewController, SearchPlayerViewInterface {
    
    var presenter: SearchPlayerPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = ColorPalette.Gray50.color
        self.setupNavigationLayout()
    }
    
    func setupNavigationLayout(){
        self.navigationItem.title = "searchForm.navBar.title".localized
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.hidesBackButton = true
    }
    
    func showHudAnimated(_ animated: Bool) {
    }
    
    func dismissHudAnimated(_ animated: Bool) {
    }
    
    func showError(title: String?, message: String?) {
        let alertError = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "alert.ok".localized, style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in }
        alertError.addAction(okAction)
        self.present(alertError, animated: true, completion: nil)
    }
}


extension SearchPlayerView {
    
    func setupForm(with seasons:[SeasonViewModel.ViewModel]){
    
        form +++ Section("searchForm.form.section.title".localized)
            // Player Name field
            <<< TextRow("playerNameField"){ row in
                row.title = "searchForm.playerName.label".localized
                row.placeholder = "searchForm.playerName.placeholder".localized
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChangeAfterBlurred
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .cellSetup { cell, row in
                    cell.textField.autocapitalizationType = .none
                    cell.textField.autocorrectionType = .no
                }
        
            <<< ActionSheetRow<String>("seasonField") {
                $0.title = "searchForm.season.label".localized
                //$0.selectorTitle = "searchForm.AvailableSeasons.label".localized
                
                let items = seasons.compactMap({ (data) -> String in
                    return data.newTitle
                })
    
                $0.options = items
                $0.value = items.last    // initially selected
            }
            
        +++ Section("")
            // Calc Button
            <<< ButtonRow("getButtonTag"){
                $0.title = "searchForm.button.title".localized
                $0.disabled = Condition.function(
                    form.allRows.compactMap { $0.tag }, // All row tags
                    { !$0.validate().isEmpty }) // Form has no validation errors
                $0.evaluateDisabled()
            }
            .onCellSelection({ (cell, row) in
                if self.form.validate().isEmpty {
                    let formDict = self.form.values() as [String : AnyObject]
                    self.presenter?.showStats(with: formDict["playerNameField"] as! String,
                                              season: formDict["seasonField"] as! String)

                }
            }).cellSetup { cell, row in
                row.cell.tintColor = ColorPalette.white.color
                cell.height = ({return 60})
            }
            .cellUpdate { cell, row in
                if self.form.validate().isEmpty {
                    cell.backgroundColor = ColorPalette.coral.color
                }
                else {
                    cell.backgroundColor = ColorPalette.Gray200.color
                }
            }
    }
}
