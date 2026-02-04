import Foundation
import UIKit

final class ListHeroesAdapter: NSObject {
    private enum Constants {
        static let rowHeight: CGFloat = 120
    }
    
    var heroes: [CharacterDataModel] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var onHeroSelected: ((CharacterDataModel) -> Void)?
    
    private let tableView: UITableView
    
    init(tableView: UITableView, heroes: [CharacterDataModel] = []) {
        self.tableView = tableView
        self.heroes = heroes
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension ListHeroesAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListHeroesTableViewCell", for: indexPath) as? ListHeroesTableViewCell else {
            return UITableViewCell()
        }
        
        let model = heroes[indexPath.row]
        cell.configure(model: model)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ListHeroesAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < heroes.count else { return }
        let selectedHero = heroes[indexPath.row]
        onHeroSelected?(selectedHero)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}
