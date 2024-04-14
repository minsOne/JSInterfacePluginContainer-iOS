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

        guard loadedPlugins[action] == nil else {
            assertionFailure("\(action) Action is existed. Please check Plugin \(plugin)")
            return
        }
        loadedPlugins.updateValue(plugin, forKey: action)
    }

    func loadPlugin(contentsOf newElements: [JSInterfacePlugin]) {
        newElements.forEach { loadPlugin($0) }
    }
}

public extension JSInterfaceSupervisor {
    func resolve(_ action: String, message: [String: String], with webView: WKWebView) {
        guard let plugin = loadedPlugins[action] else {
            assertionFailure("\(action) Action is not loaded. Please check plugin")
            return
        }

        plugin.callAsAction(message, with: webView)
    }
}
