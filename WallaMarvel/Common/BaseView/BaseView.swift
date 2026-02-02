import SwiftUI

enum ViewState {
    case none
    case loading
    case success
    case empty
    case failure
}

struct BaseView<Content: View>: View {
    @ObservedObject var viewModel: BaseViewModel

    let content: () -> Content
    var loadingView: AnyView?
    var emptyView: AnyView?
    var errorView: AnyView?
    var noneView: AnyView?

    var body: some View {
        Group {
            switch viewModel.state {
            case .none:
                noneView
            case .loading:
                loadingView
            case .success:
                content()
            case .empty:
                emptyView
            case .failure:
                errorView
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: viewModel.state)
    }
}
