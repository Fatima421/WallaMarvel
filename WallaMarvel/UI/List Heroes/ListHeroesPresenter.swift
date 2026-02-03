import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    func loadHeroes()
}

protocol ListHeroesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showHeroes(_ heroes: [CharacterDataModel])
    func showError(message: String)
    func navigateToDetail(character: CharacterDataModel)
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    weak var view: ListHeroesViewProtocol?
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func loadHeroes() {
        view?.showLoading()
        getHeroesUseCase.execute { [weak self] characterDataContainer in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let heroes = characterDataContainer.characters
                self.view?.hideLoading()
                
                if heroes.isEmpty {
                    self.view?.showError(message: "No heroes found")
                } else {
                    self.view?.showHeroes(heroes)
                }
            }
        }
    }
}
