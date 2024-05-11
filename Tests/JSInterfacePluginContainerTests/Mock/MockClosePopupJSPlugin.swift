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

    private struct Parser {
       let msg: String

        init?(_ dictonary: [String: Any]) {
            guard
                let msg = dictonary["body"] as? String
            else { return nil }

            self.msg = msg
        }
    }
}

class LoadingJSPlugin: JSInterfacePluggable {
    struct Info {
        let uuid: String
        let isShow: Bool
    }

    let action = "loading"

    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        guard
            let result = Parser(message)
        else { return }

        closure?(result.info, webView)
    }

    func set(_ closure: @escaping (Info, WKWebView) -> Void) {
        self.closure = closure
    }

    private var closure: ((Info, WKWebView) -> Void)?
}

private extension LoadingJSPlugin {
    struct Parser {
        let info: Info

        init?(_ dictonary: [String: Any]) {
            guard
                let uuid = dictonary["uuid"] as? String,
                let body = dictonary["body"] as? [String: Any],
                let isShow = body["isShow"] as? Bool
            else { return nil }

            info = .init(uuid: uuid, isShow: isShow)
        }
    }
}

class PaymentJSPlugin: JSInterfacePluggable {
    struct Info {
        let uuid: String
        let paymentAmount: Int
        let paymentTransactionId: String
        let paymentId: String
        let paymentGoodsName: String
    }

    let action = "payment"

    func callAsAction(_ message: [String: Any], with webView: WKWebView) {
        guard
            let result = Parser(message)
        else { return }

        closure?(result.info, webView)
    }

    func set(_ closure: @escaping (Info, WKWebView) -> Void) {
        self.closure = closure
    }

    private var closure: ((Info, WKWebView) -> Void)?
}

private extension PaymentJSPlugin {
    struct Parser {
        let info: Info

        init?(_ dictonary: [String: Any]) {
            guard
                let uuid = dictonary["uuid"] as? String,
                let body = dictonary["body"] as? [String: Any],
                let paymentAmount = body["paymentAmount"] as? Int,
                let paymentTransactionId = body["paymentTransactionId"] as? String,
                let paymentId = body["paymentId"] as? String,
                let paymentGoodsName = body["paymentGoodsName"] as? String
            else { return nil }

            info = .init(
                uuid: uuid,
                paymentAmount: paymentAmount,
                paymentTransactionId: paymentTransactionId,
                paymentId: paymentId,
                paymentGoodsName: paymentGoodsName
            )
        }
    }
}
