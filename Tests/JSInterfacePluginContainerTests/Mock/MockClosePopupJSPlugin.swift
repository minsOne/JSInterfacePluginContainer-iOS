import Foundation
import JSInterfacePluginContainer
import WebKit

class MockClosePopupJSPlugin: JSInterfacePlugin {
    let action = "closePopup"

    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        guard
            let result = Parser(message)
        else { return }

        closure?(result.msg, webView)
    }

    func set(_ closure: @escaping (String, WKWebView) -> Void) {
        self.closure = closure
    }

    private var closure: ((String, WKWebView) -> Void)?
}

private struct Parser {
    let msg: String

    init?(_ dictonary: [String: Any]) {
        guard
            let msg = dictonary["body"] as? String
        else { return nil }

        self.msg = msg
    }
}
