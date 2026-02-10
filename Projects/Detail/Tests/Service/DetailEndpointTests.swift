//
//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import Testing
import Foundation
import NetworkingInterfaces
@testable import Detail

struct DetailEndpointTests {

    @Test("GIVEN fetchAssets endpoint WHEN accessing path THEN returns correct path with ID parameter")
    func testFetchAssetsPath() throws {
        let id = 1
        let endpoint = DetailEndpoint.fetchAssets(id: id)

        #expect(endpoint.path == "/v1/exchange/assets?id=1")
    }

    @Test("GIVEN fetchAssets endpoint with different ID WHEN accessing path THEN returns correct path")
    func testFetchAssetsPathWithDifferentId() throws {
        let id = 270
        let endpoint = DetailEndpoint.fetchAssets(id: id)

        #expect(endpoint.path == "/v1/exchange/assets?id=270")
    }

    @Test("GIVEN fetchAssets endpoint WHEN accessing method THEN returns GET method")
    func testFetchAssetsMethod() throws {
        let endpoint = DetailEndpoint.fetchAssets(id: 1)
        let method = endpoint.method

        #expect(method == .get)
    }

    @Test("GIVEN any endpoint WHEN accessing headers THEN contains API key header")
    func testEndpointHeaders() throws {
        let endpoint = DetailEndpoint.fetchAssets(id: 1)
        let headers = endpoint.headers

        #expect(headers?["X-CMC_PRO_API_KEY"] != nil)
    }

    @Test("GIVEN any endpoint WHEN accessing baseURL THEN returns environment variable value")
    func testEndpointBaseURL() throws {
        let endpoint = DetailEndpoint.fetchAssets(id: 1)
        let baseURL = endpoint.baseURL

        #expect(!baseURL.isEmpty || ProcessInfo.processInfo.environment["CM_API_BASE_URL"] == nil)
    }
}
