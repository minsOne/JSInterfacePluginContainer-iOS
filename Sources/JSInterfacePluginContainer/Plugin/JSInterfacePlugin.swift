import Foundation
import WebKit

/// Protocol defining a JavaScript interface plugin.
public protocol JSInterfacePluginType: AnyObject {
    var action: String { get }
    func callAsAction(_ message: [String: Any], with: WKWebView)
}

/// Base class for JavaScript interface plugins.
/// DO NOT USE THIS CODE DIRECTLY
open class JSInterfacePluginBaseType {
    public required init() {}
}

public typealias JSInterfacePlugin = JSInterfacePluginBaseType & JSInterfacePluginType
