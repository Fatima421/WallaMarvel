import UIKit

final class ListHeroesViewController: UIViewController {

    // MARK: - Properties
    
    var mainView: ListHeroesView {
        guard let listView = view as? ListHeroesView else {
            fatalError("View is not of type ListHeroesView")
        }
        return listView
    }
    var presenter: ListHeroesPresenterProtocol?
    private var adapter: ListHeroesAdapter?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = ListHeroesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List of Heroes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        setupTableView()
        presenter?.loadHeroes()
    }
    
    // MARK: - Setup
    
    private func setupTableView() {
        adapter = ListHeroesAdapter(tableView: mainView.heroesTableView)
        adapter?.onHeroSelected = { [weak self] character in
            self?.presenter?.didSelectHero(character)
        }
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
    
    func showHeroes(_ heroes: [CharacterDataModel]) {
        adapter?.heroes = heroes
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToDetail(character: CharacterDataModel) {
        let detailViewController = CharacterDetailViewController(character: character)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
