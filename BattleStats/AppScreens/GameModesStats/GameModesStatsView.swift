import UIKit

protocol GameModesStatsViewInterface: BaseViewControllerInterface {
    var presenter: GameModesStatsPresenterInterface? { get set }
    var viewModels: [GameModeTableViewCell.ViewModel] { get }
    func configure(viewModels: [GameModeTableViewCell.ViewModel])
}

private struct Cells {
    static let gameModeCellName = String(describing: GameModeTableViewCell.self)
}

class GameModesStatsView: BaseViewController, GameModesStatsViewInterface {

    var viewModels: [GameModeTableViewCell.ViewModel] = []
    var presenter: GameModesStatsPresenterInterface?
    @IBOutlet var tableView: UITableView!
    
    private var dataSource = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = ColorPalette.Gray50.color
        self.setupNavigationLayout()
    }
    
    func setupNavigationLayout(){
        self.navigationItem.title = presenter?.playerName
    }
    
    func configure(viewModels: [GameModeTableViewCell.ViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
    func registerCell(){
        
        let nibGames = UINib(nibName: Cells.gameModeCellName, bundle: nil)
        tableView.register(nibGames, forCellReuseIdentifier: Cells.gameModeCellName)
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension GameModesStatsView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.gameModeCellName, for: indexPath) as! GameModeTableViewCell
        cell.selectionStyle = .none
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
}
