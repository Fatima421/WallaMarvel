import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectHero(at index: Int)
    func numberOfHeroes() -> Int
    func hero(at index: Int) -> CharacterDataModel
}

protocol ListHeroesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showHeroes()
    func showError(message: String)
    func setTitle(_ title: String)
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    weak var view: ListHeroesViewProtocol?
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    private var heroes: [CharacterDataModel] = []
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func viewDidLoad() {
        view?.setTitle("List of Heroes")
        view?.showLoading()
        loadHeroes()
    }
    
    func didSelectHero(at index: Int) {
        // TODO: Navigate to detail
        print("Selected hero: \(heroes[index].name)")
    }
    
    func numberOfHeroes() -> Int {
        return heroes.count
    }
    
    func hero(at index: Int) -> CharacterDataModel {
        return heroes[index]
    }
    
    // MARK: - Private Methods
    
    private func loadHeroes() {
        getHeroesUseCase.execute { [weak self] characterDataContainer in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.heroes = characterDataContainer.characters
                self.view?.hideLoading()
                
                if self.heroes.isEmpty {
                    self.view?.showError(message: "No heroes found")
                } else {
                    self.view?.showHeroes()
                }
            }
        }
    }
}
