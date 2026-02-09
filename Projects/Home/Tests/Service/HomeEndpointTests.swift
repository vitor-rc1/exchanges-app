//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import NetworkingInterfaces
@testable import Home

@Suite
struct HomeEndpointTests {
    @Test("GIVEN fetchItems endpoint WHEN accessing path THEN returns correct path with parameters")
    func testFetchItemsPath() throws {
        let endpoint = HomeEndpoint.fetchItems(page: 1, limit: 10)

        #expect(endpoint.path == "/v1/exchange/map?start=1&limit=10")
    }

    @Test("GIVEN fetchDetail endpoint WHEN accessing path THEN returns correct path with comma-separated IDs")
    func testFetchDetailPath() throws {
        let ids = ["1", "2", "3"]

        let endpoint = HomeEndpoint.fetchDetail(ids: ids)

        #expect(endpoint.path == "/v1/exchange/info?id=1,2,3")
    }

    @Test("GIVEN fetchItems endpoint WHEN accessing method THEN returns GET method")
    func testFetchItemsMethod() throws {
        let endpoint = HomeEndpoint.fetchItems(page: 1, limit: 20)

        let method = endpoint.method

        #expect(method == .get)
    }

    @Test("GIVEN fetchDetail endpoint WHEN accessing method THEN returns GET method")
    func testFetchDetailMethod() throws {
        let endpoint = HomeEndpoint.fetchDetail(ids: ["1"])

        let method = endpoint.method

        #expect(method == .get)
    }

    @Test("GIVEN any endpoint WHEN accessing headers THEN contains API key header")
    func testEndpointHeaders() throws {
        let endpoint = HomeEndpoint.fetchItems(page: 1, limit: 20)

        let headers = endpoint.headers

        #expect(headers?["X-CMC_PRO_API_KEY"] != nil)
    }
}
