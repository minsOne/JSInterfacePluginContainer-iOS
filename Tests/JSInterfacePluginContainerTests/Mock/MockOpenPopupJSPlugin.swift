import Foundation
import JSInterfacePluginContainer
import WebKit

class MockOpenPopupJSPlugin: JSInterfacePlugin {
    struct PopupInfo {
        let title: String
        let desc: String
    }
    
    let action = "openPopup"
    
    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        guard
            let result = Parser(message)
        else { return }
        
        let info = PopupInfo(title: result.title, desc: result.desc)
        closure?(info, webView)
    }
    
    func set(_ closure: @escaping (PopupInfo, WKWebView) -> Void) {
        self.closure = closure
    }
    
    private var closure: ((PopupInfo, WKWebView) -> Void)?
}

private struct Parser {
    let title: String
    let desc: String
        
    init?(_ dictonary: [String: Any]) {
        guard
            let body = dictonary["body"] as? [String: Any],
            let title = body["title"] as? String,
            let desc = body["desc"] as? String
        else { return nil }
            
        self.title = title
        self.desc = desc
    }
}
