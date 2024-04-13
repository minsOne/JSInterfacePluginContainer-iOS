import Foundation
import JSInterfacePluginContainer
import WebKit

class OpenPopupJSPlugin: JSInterfacePlugin {
    var action: String {
        "openPopup"
    }

    func callAsAction(_ request: [String: String], with webView: WKWebView) {
        closure?(webView)
    }

    func set(_ closure: @escaping (WKWebView) -> Void) {
        self.closure = closure
    }

    var closure: ((WKWebView) -> Void)?
}
