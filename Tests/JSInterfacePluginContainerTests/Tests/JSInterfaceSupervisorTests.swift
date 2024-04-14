import Foundation
import WebKit
import XCTest

@testable import JSInterfacePluginContainer

final class JSInterfaceSupervisorTests: XCTestCase {
    func testLoadingPlugin() {
        let plugin1 = OpenPopupJSPlugin()
        let plugin2 = ClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        supervisor.loadPlugin(plugin1)
        supervisor.loadPlugin(plugin2)

        XCTAssertEqual(supervisor.loadedPlugins.count, 2)
    }

    func testLoadingPluginArray() {
        let plugin1 = OpenPopupJSPlugin()
        let plugin2 = ClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        supervisor.loadPlugin(contentsOf: [plugin1, plugin2])

        XCTAssertEqual(supervisor.loadedPlugins.count, 2)
    }

    func testResolvingPlugin() {
        let plugin1 = OpenPopupJSPlugin()
        let plugin2 = ClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        supervisor.loadPlugin(contentsOf: [plugin1, plugin2])

        let expectation = XCTestExpectation(description: "Plugin resolves asynchronously.")

        plugin1.set { _ in
            expectation.fulfill()
        }

        plugin2.set { _ in
            XCTFail("Do not resolve this plugin")
            expectation.fulfill()
        }
        supervisor.resolve(plugin1.action, message: [:], with: WKWebView())

        wait(for: [expectation], timeout: 1)
    }
}
