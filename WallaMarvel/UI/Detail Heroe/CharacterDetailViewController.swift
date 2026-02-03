import UIKit
import SwiftUI

final class CharacterDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let character: CharacterDataModel
    private var hostingController: UIHostingController<CharacterDetailView>?
    
    // MARK: - Initializer
    
    init(character: CharacterDataModel) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = character.name
        navigationItem.largeTitleDisplayMode = .never
        setupSwiftUIView()
    }
    
    // MARK: - Setup
    
    private func setupSwiftUIView() {
        let swiftUIView = CharacterDetailView(character: character)
        
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        self.hostingController = hostingController
    }
}
