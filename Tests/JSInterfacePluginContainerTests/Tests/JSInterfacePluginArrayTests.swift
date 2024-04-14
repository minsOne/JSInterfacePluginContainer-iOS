import Foundation
import XCTest

@testable import JSInterfacePluginContainer

final class JSInterfacePluginArrayTests: XCTestCase {
    func testReplaceOnePlugin() {
        // Given
        var plugins = JSInterfacePluginScanner
            .plugins
            .map { $0.init() }
        let newPlugin = OpenPopupJSPlugin()

        XCTAssertEqual(plugins.count, 2)

        // When
        plugins = plugins.replacing(newPlugin)

        // Then
        XCTAssertEqual(plugins.count, 2)
        XCTAssertEqual(plugins.last?.action, newPlugin.action)

        let plugin = plugins.last as? OpenPopupJSPlugin
        XCTAssertNotNil(plugin)
    }

    func testReplaceMultiplePlugin() {
        // Given
        let newPlugin1 = OpenPopupJSPlugin()
        let newPlugin2 = ClosePopupJSPlugin()
        var plugins = JSInterfacePluginScanner
            .plugins
            .map { $0.init() }

        XCTAssertEqual(plugins.count, 2)

        // When
        plugins = plugins.replacing(contentsOf: [newPlugin1, newPlugin2])

        // Then
        XCTAssertEqual(plugins.count, 2)

        do {
            let plugin = plugins.popLast() as? ClosePopupJSPlugin
            XCTAssertNotNil(plugin)
            XCTAssertEqual(plugin?.action, newPlugin2.action)
        }

        do {
            let plugin = plugins.popLast() as? OpenPopupJSPlugin
            XCTAssertNotNil(plugin)
            XCTAssertEqual(plugin?.action, newPlugin1.action)
        }
    }

    func testUpdatePlugin() {
        // Given
        let supervisor = JSInterfaceSupervisor()
        let newPlugin = OpenPopupJSPlugin()
        var plugins = JSInterfacePluginScanner
            .plugins
            .map { $0.init() }

        XCTAssertEqual(plugins.count, 2)

        // When
        let expectation = XCTestExpectation(description: "Plugin resolve asynchronously.")

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
        supervisor.resolve(newPlugin.action,
                           message: [:],
                           with: .init())

        wait(for: [expectation], timeout: 1)
    }
}
