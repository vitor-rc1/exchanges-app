import Foundation
@testable import Detail

@MainActor
final class DetailViewModelSpy: DetailViewModelProtocol {
    // MARK: - Properties

    weak var delegate: DetailViewModelDelegate?
    var assets: [Asset] = []
    var state: DetailViewState = .loading

    public enum Method {
        case loadData
        case didTapRetry
        case didTapWebsite
        case didTapTwitter
    }

    public var calledMethods: [Method] = []

    // MARK: - Methods

    func loadData() {
        calledMethods.append(.loadData)
    }

    func didTapRetry() {
        calledMethods.append(.didTapRetry)
    }

    func didTapWebsite() {
        calledMethods.append(.didTapWebsite)
    }

    func didTapTwitter() {
        calledMethods.append(.didTapTwitter)
    }
}
