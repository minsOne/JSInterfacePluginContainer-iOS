import Foundation
import XCTest

@testable import JSInterfacePluginContainer

final class JSInterfacePluginScannerTests: XCTestCase {
    func testScanPlugin() {
        let pluginTypes = JSInterfacePluginScanner().plugins
        let plugins = pluginTypes.map { $0.init() }
        XCTAssertEqual(plugins.count, 1)

        let hasUniqueActions = Dictionary(grouping: plugins, by: \.action)
            .lazy
            .filter { $1.count > 1 }
            .isEmpty

        XCTAssertTrue(hasUniqueActions)
    }
}
