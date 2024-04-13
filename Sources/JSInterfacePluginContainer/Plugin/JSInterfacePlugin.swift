import Foundation
import WebKit

public protocol JSInterfacePluginType: AnyObject {
    var action: String { get }
    func callAsAction(_ request: [String: String], with: WKWebView)
}

/// DO NOT USE THIS CODE DIRECTLY
open class JSInterfacePluginBaseType {
    public required init() {}
}

public typealias JSInterfacePlugin = JSInterfacePluginBaseType & JSInterfacePluginType
