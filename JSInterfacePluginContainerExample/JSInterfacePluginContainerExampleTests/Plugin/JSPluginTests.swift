//
//  JSInterfacePluginContainerExampleTests.swift
//  JSInterfacePluginContainerExampleTests
//
//  Created by minsOne on 6/2/24.
//

import XCTest

@testable import JSInterfacePluginContainer
@testable import JSInterfacePluginContainerExample

final class JSPluginTests: XCTestCase {
    func testLoadingJSPluginParser() {
        // Given
        let plugin = LoadingJSPlugin()
        let msg: [String: Any] = [
            "action": "loading",
            "uuid": "uuid",
            "body": ["isShow": true]
        ]

        // When
        let expectation = XCTestExpectation(description: "Plugin resolves asynchronously.")
        plugin.set { _, _ in
            expectation.fulfill()
        }

        // Then
        plugin.callAsAction(msg, with: .init())

        wait(for: [expectation], timeout: 1)
    }

    func testPaymentJSPluginParser() {
        // Given
        let plugin = PaymentJSPlugin()
        let msg: [String: Any] = [
            "action": "payment",
            "uuid": "uuid",
            "body": [
                "paymentAmount": 123456,
                "paymentTransactionId": "123123",
                "paymentId": "202405100941223344",
                "paymentGoodsName": "교촌치킨"
            ]
        ]

        // When
        let expectation = XCTestExpectation(description: "Plugin resolves asynchronously.")
        plugin.set { _, _ in
            expectation.fulfill()
        }

        // Then
        plugin.callAsAction(msg, with: .init())

        wait(for: [expectation], timeout: 1)
    }

    func testScanPlugin() {
        let plugins = JSInterfacePluginScanner.plugins.map { $0.init() }
        XCTAssertEqual(plugins.count, 2)
    }
}
