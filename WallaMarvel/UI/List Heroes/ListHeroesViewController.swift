import UIKit

final class ListHeroesViewController: UIViewController {
    
    // MARK: - Properties
    
    var mainView: ListHeroesView { return view as! ListHeroesView }
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

// MARK: - UITableViewDelegate

extension ListHeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let heroes = adapter?.heroes, indexPath.row < heroes.count else { return }
        let selectedHero = heroes[indexPath.row]
        navigateToDetail(character: selectedHero)
    }
}
