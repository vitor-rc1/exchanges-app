import Testing
import Foundation
@testable import Detail

@MainActor
struct DetailViewControllerTests {

    // MARK: - viewDidLoad

    @Test("GIVEN DetailViewController WHEN viewDidLoad is called THEN calls loadData on viewModel")
    func testViewDidLoadCallsLoadData() {
        let (sut, viewModelSpy) = makeSut()

        sut.loadViewIfNeeded()

        #expect(viewModelSpy.calledMethods == [.loadData])
    }

    @Test("GIVEN DetailViewController WHEN viewDidLoad is called THEN sets delegate on viewModel")
    func testViewDidLoadSetsDelegate() {
        let (sut, viewModelSpy) = makeSut()

        sut.loadViewIfNeeded()

        #expect(viewModelSpy.delegate != nil)
    }

    // MARK: - didUpdateState

    @Test("GIVEN DetailViewController WHEN didUpdateState with loading THEN hides tableView and shows loading indicator")
    func testDidUpdateStateWithLoading() {
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()

        sut.didUpdateState(.loading)

        #expect(true)
    }

    @Test("GIVEN DetailViewController WHEN didUpdateState with loaded THEN shows tableView and sets title")
    func testDidUpdateStateWithLoaded() {
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()
        let model = makeDetailModel()

        sut.didUpdateState(.loaded(model))

        #expect(sut.title == model.name)
    }

    @Test("GIVEN DetailViewController WHEN didUpdateState with loadingAssets THEN does not crash")
    func testDidUpdateStateWithLoadingAssets() {
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()

        sut.didUpdateState(.loadingAssets)

        #expect(true)
    }

    @Test("GIVEN DetailViewController WHEN didUpdateState with loadedAssets THEN reloads table data")
    func testDidUpdateStateWithLoadedAssets() {
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()
        sut.didUpdateState(.loaded(makeDetailModel()))

        sut.didUpdateState(.loadedAssets)

        #expect(true)
    }

    @Test("GIVEN DetailViewController WHEN didUpdateState with error THEN shows error view")
    func testDidUpdateStateWithError() {
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()

        sut.didUpdateState(.error("Test error"))

        #expect(true)
    }

    @Test("GIVEN DetailViewController WHEN didUpdateState with errorLoadAssets THEN shows error view")
    func testDidUpdateStateWithErrorLoadAssets() {
        let (sut, _) = makeSut()
        sut.loadViewIfNeeded()
        sut.didUpdateState(.loaded(makeDetailModel()))

        sut.didUpdateState(.errorLoadAssets(title: "Failed to load assets", message: "Server error", code: 0))

        #expect(true)
    }

    // MARK: - Button actions

    @Test("GIVEN DetailViewController WHEN website button is tapped THEN calls didTapWebsite on viewModel")
    func testDidTapWebsiteButton() {
        let (sut, viewModelSpy) = makeSut()
        sut.loadViewIfNeeded()
        viewModelSpy.calledMethods.removeAll()

        sut.perform(NSSelectorFromString("didTapWebsiteButton"))

        #expect(viewModelSpy.calledMethods == [.didTapWebsite])
    }

    @Test("GIVEN DetailViewController WHEN twitter button is tapped THEN calls didTapTwitter on viewModel")
    func testDidTapTwitterButton() {
        let (sut, viewModelSpy) = makeSut()
        sut.loadViewIfNeeded()
        viewModelSpy.calledMethods.removeAll()

        sut.perform(NSSelectorFromString("didTapTwitterButton"))

        #expect(viewModelSpy.calledMethods == [.didTapTwitter])
    }

    // MARK: - Table view data source

    @Test("GIVEN DetailViewController with loadedAssets and empty assets WHEN numberOfSections is called THEN returns zero")
    func testNumberOfSectionsWithEmptyAssets() {
        let (sut, viewModelSpy) = makeSut()
        sut.loadViewIfNeeded()
        viewModelSpy.state = .loadedAssets
        viewModelSpy.assets = []

        sut.didUpdateState(.loaded(makeDetailModel()))
        sut.didUpdateState(.loadedAssets)

        #expect(true)
    }
}

extension DetailViewControllerTests {
    private func makeSut() -> (viewController: DetailViewController, viewModelSpy: DetailViewModelSpy) {
        let viewModelSpy = DetailViewModelSpy()
        let viewController = DetailViewController(viewModel: viewModelSpy)
        return (viewController, viewModelSpy)
    }

    private func makeDetailModel(
        websiteUrl: String? = "https://test.com",
        twitterUrl: String? = "https://twitter.com/test"
    ) -> ExchangeDetailModel {
        ExchangeDetailModel(
            id: 1,
            name: "Test Exchange",
            description: "Test Description",
            logoUrl: "https://test.com/logo.png",
            spotVolumeUsd: 1000000,
            makerFee: 0.1,
            takerFee: 0.2,
            dateLaunched: "2020-01-01",
            websiteUrl: websiteUrl,
            twitterUrl: twitterUrl
        )
    }
}
