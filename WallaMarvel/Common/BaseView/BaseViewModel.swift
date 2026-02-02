import Foundation

class BaseViewModel: ObservableObject {
    // MARK: - Properties

    @Published var state: ViewState = .none
}
