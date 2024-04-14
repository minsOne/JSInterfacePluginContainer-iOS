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
        let newPlugin = OpenPopupJSPlugin()

        // When
        plugins = plugins.replacing(newPlugin)

        // Then
        XCTAssertEqual(plugins.count, 2)
        XCTAssertEqual(plugins.last?.action, newPlugin.action)
        XCTAssertNotNil(plugins.last as? OpenPopupJSPlugin)
    }

    func testReplacingMultiplePlugins() {
        // Given
        let newPlugin1 = ClosePopupJSPlugin()
        let newPlugin2 = OpenPopupJSPlugin()

        // When
        plugins = plugins.replacing(contentsOf: [newPlugin1, newPlugin2])

        // Then
        XCTAssertEqual(plugins.count, 2)
        XCTAssertNotNil(plugins.last as? OpenPopupJSPlugin)
        XCTAssertNotNil(plugins.first as? ClosePopupJSPlugin)
    }
}

final class JSInterfacePluginArrayAppendTests: XCTestCase {
    var plugins: [JSInterfacePlugin] = []

    func testAppendOnePlugin() {
        // Given
        let newPlugin = ClosePopupJSPlugin()

        // When
        plugins.replace(newPlugin)

        // Then
        XCTAssertEqual(plugins.count, 1)
    }

    func testAppendMultiplePlugins() {
        // Given
        let newPlugin1 = ClosePopupJSPlugin()
        let newPlugin2 = OpenPopupJSPlugin()

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
        let newPlugin = OpenPopupJSPlugin()

        // When
        let expectation = XCTestExpectation(description: "Plugin resolves asynchronously.")

        plugins = plugins
            .update(OpenPopupJSPlugin.self) { plugin in
                plugin.set { _ in expectation.fulfill() }
            }
            .update(ClosePopupJSPlugin.self) { plugin in
                plugin.set { _ in
                    XCTFail("Do not resolve this plugin")
                    expectation.fulfill()
                }
            }

        supervisor.loadPlugin(contentsOf: plugins)

        // Then
        supervisor.resolve(newPlugin.action, message: [:], with: .init())

        wait(for: [expectation], timeout: 1)
    }
}
