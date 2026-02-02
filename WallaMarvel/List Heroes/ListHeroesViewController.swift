import UIKit

final class ListHeroesViewController: UIViewController {
    
    // MARK: - Properties
    
    var mainView: ListHeroesView { return view as! ListHeroesView }
    var presenter: ListHeroesPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = ListHeroesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        mainView.heroesTableView.dataSource = self
        mainView.heroesTableView.delegate = self
    }
}

// MARK: - ListHeroesViewProtocol

extension ListHeroesViewController: ListHeroesViewProtocol {
    func showLoading() {
        mainView.loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        mainView.loadingIndicator.stopAnimating()
    }
    
    func showHeroes() {
        mainView.heroesTableView.reloadData()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func setTitle(_ title: String) {
        self.title = title
    }
}

// MARK: - UITableViewDataSource

extension ListHeroesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfHeroes() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListHeroesTableViewCell", for: indexPath) as! ListHeroesTableViewCell
        
        if let hero = presenter?.hero(at: indexPath.row) {
            cell.configure(model: hero)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListHeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectHero(at: indexPath.row)
    }
}
