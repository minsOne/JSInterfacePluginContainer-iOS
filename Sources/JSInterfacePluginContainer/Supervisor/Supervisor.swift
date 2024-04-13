//
//  Supervisor.swift
//
//
//  Created by minsOne on 4/13/24.
//

import Foundation
import WebKit

public class JSInterfaceSupervisor {
    var loadedPlugins = [String: JSInterfacePlugin]()

    public init() {}
}

public extension JSInterfaceSupervisor {
    func loadPlugin(_ plugin: JSInterfacePlugin) {
        let action = plugin.action
        if let _ = loadedPlugins[action] {
            assertionFailure("\(action) Action is existed. Please check Plugin \(plugin)")
        }
        loadedPlugins.updateValue(plugin, forKey: action)
    }

    func register(contentsOf newElements: [JSInterfacePlugin]) {
        newElements.forEach { loadPlugin($0) }
    }
}

public extension JSInterfaceSupervisor {
    func resolve(_ action: String, request: [String: String], with webView: WKWebView) {
        guard
            let plugin = loadedPlugins[action]
        else {
            assertionFailure("\(action) Action is Not Loaded. Please check action - \(action)")
            return
        }

        plugin.callAsAction(request, with: webView)
    }
}
