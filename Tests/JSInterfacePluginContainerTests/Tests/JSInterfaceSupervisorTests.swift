import Foundation
import WebKit
import XCTest

@testable import JSInterfacePluginContainer

final class JSInterfaceSupervisorTests: XCTestCase {
    func testLoadPlugin() {
        let plugin1 = OpenPopupJSPlugin()
        let plugin2 = ClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        supervisor.loadPlugin(plugin1)
        supervisor.loadPlugin(plugin2)

        XCTAssertEqual(supervisor.loadedPlugins.count,
                       2)
    }

    func testLoadPluginArray() {
        let plugin1 = OpenPopupJSPlugin()
        let plugin2 = ClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        supervisor.loadPlugin(contentsOf: [plugin1, plugin2])

        XCTAssertEqual(supervisor.loadedPlugins.count,
                       2)
    }

    func testResolvePlugin() {
        let plugin1 = OpenPopupJSPlugin()
        let plugin2 = ClosePopupJSPlugin()
        let supervisor = JSInterfaceSupervisor()

        supervisor.loadPlugin(contentsOf: [plugin1, plugin2])

        let expectation = XCTestExpectation(description: "Plugin resolve asynchronously.")
        
        plugin1.set { _ in
            expectation.fulfill()
        }
        
        plugin2.set { _ in
            XCTFail("Do not resolve this plugin")
            expectation.fulfill()
        }
        supervisor.resolve(plugin1.action,
                           message: [:],
                           with: .init())
        
        wait(for: [expectation], timeout: 1)

    }
}
