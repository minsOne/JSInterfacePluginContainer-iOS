//
//  ViewController.swift
//  JSInterfacePluginContainerExample
//
//  Created by minsOne on 6/1/24.
//

import JSInterfacePluginContainer
import UIKit
import WebKit

class ViewController: UIViewController {
    private let supervisor = JSInterfaceSupervisor()
    private let messageHandler = "actionHandler"
    var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPlugins()
        initWebView()
    }
}

extension ViewController: WKScriptMessageHandler {
    // WKScriptMessageHandler 프로토콜 메서드 구현
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard
            message.name == messageHandler,
            let messageBody = message.body as? [String: Any],
            let action = messageBody["action"] as? String,
            let webView
        else { return }
        
        supervisor.resolve(action, message: messageBody, with: webView)
    }
}

private extension ViewController {
    func initPlugins() {
        let loadingPlugin = LoadingJSPlugin()
        let paymentPlugin = PaymentJSPlugin()
        loadingPlugin.set { info, _ in
            print("LoadingPlugin :", info)
        }
        paymentPlugin.set { info, _ in
            print("PaymentJSPlugin :", info)
        }
        
        supervisor.loadPlugin(contentsOf: [loadingPlugin, paymentPlugin])
    }

    func initWebView() {
        // WKUserContentController 인스턴스 생성
        let userContentController = WKUserContentController()
        userContentController.add(self, name: messageHandler) // 메시지 핸들러 등록
        
        // WKWebView에 WKUserContentController 설정
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        // WKWebView 인스턴스 생성
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        self.webView = webView
        
        // WKWebView를 뷰에 추가
        view.addSubview(webView)
        
        // HTML 파일 로드
        _ = Bundle.main.path(forResource: "index", ofType: "html")
            .map { URL(fileURLWithPath: $0) }
            .map { webView.loadFileURL($0, allowingReadAccessTo: $0) }
    }
}
