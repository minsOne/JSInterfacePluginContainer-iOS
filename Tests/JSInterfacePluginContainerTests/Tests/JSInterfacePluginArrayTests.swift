import Foundation
import XCTest

@testable import JSInterfacePluginContainer

final class JSInterfacePluginArrayReplaceTests: XCTestCase {
    var plugins: [JSInterfacePlugin] = []

    override func setUp() {
        super.setUp()
        plugins = JSInterfacePluginScanner.plugins.map { $0.init() }
    }

    func testReplacingOnePlugin() {
        // Given
        let newPlugin = MockOpenPopupJSPlugin()

        // When
        plugins = plugins.replacing(newPlugin)

        // Then
        XCTAssertEqual(plugins.count, 2)
    }

    func testReplacingMultiplePlugins() {
        // Given
        let newPlugin1 = MockClosePopupJSPlugin()
        let newPlugin2 = MockOpenPopupJSPlugin()

        // When
        plugins = plugins.replacing(contentsOf: [newPlugin1, newPlugin2])

        // Then
        XCTAssertEqual(plugins.count, 2)
    }
}

final class JSInterfacePluginArrayAppendTests: XCTestCase {
    var plugins: [JSInterfacePlugin] = []

    func testAppendOnePlugin() {
        // Given
        let newPlugin = MockClosePopupJSPlugin()

        // When
        plugins.replace(newPlugin)

        // Then
        XCTAssertEqual(plugins.count, 1)
    }

    func testAppendMultiplePlugins() {
        // Given
        let newPlugin1 = MockClosePopupJSPlugin()
        let newPlugin2 = MockOpenPopupJSPlugin()

        // When
        plugins = plugins.replacing(contentsOf: [newPlugin1, newPlugin2])

        // Then
        XCTAssertEqual(plugins.count, 2)
    }
}

final class JSInterfacePluginArrayUpdateTests: XCTestCase {
    func testUpdatingPlugin() {
        // Given
        var plugins = JSInterfacePluginScanner.plugins.map { $0.init() }
        let supervisor = JSInterfaceSupervisor()
        let newPlugin = MockClosePopupJSPlugin()

        let msg: [String: Any] = [
            "action": "closePopup",
            "uuid": "uuid",
            "body": "Message"
        ]

        // When
        let expectation = XCTestExpectation(description: "Plugin resolves asynchronously.")

        plugins = plugins
            .set(MockOpenPopupJSPlugin.self) { plugin in
                plugin.set { _, _ in
                    XCTFail("Do not resolve this plugin")
                    expectation.fulfill()
                }
            }
            .set(MockClosePopupJSPlugin.self) { plugin in
                plugin.set { msg, _ in
                    XCTAssertEqual(msg, "Message")
                    expectation.fulfill()
                }
            }

        supervisor.loadPlugin(contentsOf: plugins)

        // Then
        supervisor.resolve(newPlugin.action, message: msg, with: .init())

        wait(for: [expectation], timeout: 1)
    }
}
