import UIKit

protocol CommunityNewsViewInterface: BaseViewControllerInterface {
    var presenter: CommunityNewsPresenterInterface? { get set }
    var viewModels: [NewsTableViewCell.ViewModel] { get }
    func configure(viewModels: [NewsTableViewCell.ViewModel])
}

private struct Cells {
    static let newsCellName = String(describing: NewsTableViewCell.self)
}

class CommunityNewsView: BaseViewController, CommunityNewsViewInterface {
    
    var viewModels: [NewsTableViewCell.ViewModel] = []
    var presenter: CommunityNewsPresenterInterface?
    @IBOutlet var tableView: UITableView!
    
    private var dataSource = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = ColorPalette.Gray50.color
        self.setupNavigationLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidAppear(animated)
        registerCell()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.viewWillDisappear(animated)
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func configure(viewModels: [NewsTableViewCell.ViewModel]) {
        self.viewModels = viewModels
        tableView.reloadData()
    }
    
    func setupNavigationLayout(){
        self.navigationItem.title = "news.navbar.title".localized
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.hidesBackButton = true
    }
    
    func registerCell(){
        
        let nibGames = UINib(nibName: Cells.newsCellName, bundle: nil)
        tableView.register(nibGames, forCellReuseIdentifier: Cells.newsCellName)
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension CommunityNewsView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.newsCellName, for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
}

extension CommunityNewsView: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.goToNews(index: indexPath.row)
    }
}
