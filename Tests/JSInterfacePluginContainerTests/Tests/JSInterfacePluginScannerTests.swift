import Foundation
import XCTest

@testable import JSInterfacePluginContainer

final class JSInterfacePluginScannerTests: XCTestCase {
    func testScanningPlugins() {
        let plugins = JSInterfacePluginScanner.plugins.map { $0.init() }
        XCTAssertEqual(plugins.count, 2)

        let hasUniqueActions = Dictionary(grouping: plugins, by: \.action)
            .lazy
            .filter { $1.count > 1 }
            .isEmpty

        XCTAssertTrue(hasUniqueActions)
    }
}
