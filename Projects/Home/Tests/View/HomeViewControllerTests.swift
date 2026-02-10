//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import HomeInterfaces
import Testing
import UIKit
import DesignSystem

@testable import Home

@MainActor
@Suite
struct HomeViewControllerTests {
    @Test("GIVEN viewController WHEN viewDidLoad is called THEN sets up view and calls loadData")
    func testViewDidLoad() throws {
        let (sut, viewModelSpy) = makeSut()

        sut.loadView()
        sut.viewDidLoad()

        #expect(sut.title == "Exchanges")
        #expect(viewModelSpy.calledMethods.contains(.loadData))
        #expect(viewModelSpy.delegate != nil)
    }

    @Test("GIVEN viewController in loading state WHEN tableView numberOfRows is called THEN returns 3")
    func testTableViewNumberOfRowsLoading() throws {
        let (sut, viewModelSpy) = makeSut()
        viewModelSpy.state = .loading
        sut.loadView()
        sut.viewDidLoad()

        let numberOfRows = sut.tableView(UITableView(), numberOfRowsInSection: 0)

        #expect(numberOfRows == 3)
    }

    @Test("GIVEN viewController in loaded state WHEN tableView numberOfRows is called THEN returns viewModel numberOfItems")
    func testTableViewNumberOfRowsLoaded() throws {
        let (sut, viewModelSpy) = makeSut()
        viewModelSpy.state = .loaded
        viewModelSpy.numberOfItems = 5
        sut.loadView()
        sut.viewDidLoad()

        let numberOfRows = sut.tableView(UITableView(), numberOfRowsInSection: 0)

        #expect(numberOfRows == 5)
    }

    @Test("GIVEN viewController in loading state WHEN tableView cellForRow is called THEN returns InfoCell in loading state")
    func testTableViewCellForRowLoading() throws {
        let (sut, viewModelSpy) = makeSut()
        viewModelSpy.state = .loading
        sut.loadView()
        sut.viewDidLoad()

        let tableView = UITableView()
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)

        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        #expect(cell is InfoCell)
    }

    @Test("GIVEN viewController in loaded state WHEN tableView cellForRow is called THEN returns configured InfoCell")
    func testTableViewCellForRowLoaded() throws {
        let (sut, viewModelSpy) = makeSut()
        let exchange = Exchange(
            id: 1,
            name: "Binance",
            logo: "logo.url",
            makerFee: 0.001,
            takerFee: 0.002,
            dateLaunched: "2017-07-14"
        )
        viewModelSpy.state = .loaded
        viewModelSpy.itemsToReturn = [exchange]
        viewModelSpy.numberOfItems = 1

        sut.loadView()
        sut.viewDidLoad()

        let tableView = UITableView()
        tableView.register(InfoCell.self, forCellReuseIdentifier: InfoCell.identifier)

        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        #expect(cell is InfoCell)
        #expect(viewModelSpy.calledMethods.contains(.item))
        #expect(viewModelSpy.calledMethods.contains(.formatPrice))
        #expect(viewModelSpy.calledMethods.contains(.formatDate))
    }

    @Test("GIVEN viewController WHEN tableView didSelectRow is called THEN calls viewModel didSelectRow")
    func testTableViewDidSelectRow() throws {
        let (sut, viewModelSpy) = makeSut()
        sut.loadView()
        sut.viewDidLoad()

        let tableView = UITableView()

        sut.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))

        #expect(viewModelSpy.calledMethods.contains(.didSelectRow))
    }
}

extension HomeViewControllerTests {
    typealias SutAndDoubles = (
        sut: HomeViewController,
        viewModelSpy: HomeViewModelSpy
    )

    func makeSut() -> SutAndDoubles {
        let viewModelSpy = HomeViewModelSpy()
        let sut = HomeViewController(viewModel: viewModelSpy)
        return (sut, viewModelSpy)
    }
}
