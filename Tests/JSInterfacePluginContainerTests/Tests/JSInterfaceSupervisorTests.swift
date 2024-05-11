import Foundation
import WebKit
import XCTest

@testable import JSInterfacePluginContainer

final class JSInterfaceSupervisorTests: XCTestCase {
    func testLoadingPlugin() {
        // Given
        let plugin1 = MockOpenPopupJSPlugin()
        let plugin2 = MockClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        // When
        supervisor.loadPlugin(plugin1)
        supervisor.loadPlugin(plugin2)

        // Then
        XCTAssertEqual(supervisor.loadedPlugins.count, 2)
    }

    func testLoadingPluginArray() {
        // Given
        let plugin1 = MockOpenPopupJSPlugin()
        let plugin2 = MockClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        // When
        supervisor.loadPlugin(contentsOf: [plugin1, plugin2])

        // Then
        XCTAssertEqual(supervisor.loadedPlugins.count, 2)
    }

    func testResolvingPlugin() {
        // Given
        let plugin1 = MockOpenPopupJSPlugin()
        let plugin2 = MockClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        let msg: [String: Any] = [
            "action": "openPopup",
            "uuid": "uuid",
            "body": [
                "title": "Hello",
                "desc": "World"
            ]
        ]

        // When
        supervisor.loadPlugin(contentsOf: [plugin1, plugin2])

        // Then
        let expectation = XCTestExpectation(description: "Plugin resolves asynchronously.")

        plugin1.set { info, _ in
            XCTAssertEqual(info.title, "Hello")
            XCTAssertEqual(info.desc, "World")
            expectation.fulfill()
        }

        plugin2.set { _, _ in
            XCTFail("Do not resolve this plugin")
            expectation.fulfill()
        }
        supervisor.resolve(plugin1.action,
                           message: msg,
                           with: WKWebView())

        wait(for: [expectation], timeout: 1)
    }
}
