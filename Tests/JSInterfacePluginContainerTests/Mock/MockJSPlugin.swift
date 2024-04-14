import Foundation
import JSInterfacePluginContainer
import WebKit

class OpenPopupJSPlugin: JSInterfacePlugin {
    var action: String {
        "openPopup"
    }

    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        closure?(webView)
    }

    func set(_ closure: @escaping (WKWebView) -> Void) {
        self.closure = closure
    }

    var closure: ((WKWebView) -> Void)?
}

class ClosePopupJSPlugin: JSInterfacePlugin {
    var action: String {
        "closePopup"
    }
    
    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        closure?(webView)
    }
    
    func set(_ closure: @escaping (WKWebView) -> Void) {
        self.closure = closure
    }
    
    var closure: ((WKWebView) -> Void)?
}
