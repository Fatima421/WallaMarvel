import Foundation

struct PaginationState {
    var currentPage: Int = 1
    var canLoadMore: Bool = false

    var nextPage: Int {
        canLoadMore ? currentPage + 1 : currentPage
    }

    mutating func reset() {
        currentPage = 1
        canLoadMore = false
    }
}
