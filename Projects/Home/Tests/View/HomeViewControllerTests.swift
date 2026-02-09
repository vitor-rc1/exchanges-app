//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import UIKit
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

    @Test("GIVEN viewController WHEN tableView numberOfRows is called THEN returns viewModel numberOfItems")
    func testTableViewNumberOfRows() throws {
        let (sut, viewModelSpy) = makeSut()
        viewModelSpy.numberOfItems = 5
        sut.loadView()
        sut.viewDidLoad()

        let numberOfRows = sut.tableView(UITableView(), numberOfRowsInSection: 0)

        #expect(numberOfRows == 5)
    }

    @Test("GIVEN viewController WHEN tableView cellForRow is called THEN returns configured cell")
    func testTableViewCellForRow() throws {
        let (sut, viewModelSpy) = makeSut()
        let exchange = Exchange(
            id: 1,
            name: "Binance",
            logo: "logo.url",
            makerFee: 0.001,
            takerFee: 0.002,
            dateLaunched: "2017-07-14"
        )
        viewModelSpy.itemsToReturn = [exchange]
        viewModelSpy.numberOfItems = 1

        sut.loadView()
        sut.viewDidLoad()

        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        let cell = sut.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))

        #expect(viewModelSpy.calledMethods.contains(.item))
        #expect(cell.textLabel?.text == nil || cell.contentConfiguration != nil)
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
