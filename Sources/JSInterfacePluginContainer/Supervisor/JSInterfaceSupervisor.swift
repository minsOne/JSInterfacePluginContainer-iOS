import Foundation
import WebKit

/// Supervisor class responsible for loading and managing JS plugins.
public class JSInterfaceSupervisor {
    var loadedPlugins = [String: JSInterfacePlugin]()

    public init() {}
}

public extension JSInterfaceSupervisor {
    /// Loads a single plugin into the supervisor.
    func loadPlugin(_ plugin: JSInterfacePlugin) {
        let action = plugin.action

        if loadedPlugins[action] == nil {
            loadedPlugins[action] = plugin
        } else {
            assertionFailure("\(action) action already exists. Please check the plugin.")
        }
    }

    /// Loads multiple plugins into the supervisor.
    func loadPlugin(contentsOf newElements: [JSInterfacePlugin]) {
        newElements.forEach { loadPlugin($0) }
    }
}

public extension JSInterfaceSupervisor {
    /// Resolves an action and calls the corresponding plugin with a message and web view.
    func resolve(_ action: String, message: [String: String], with webView: WKWebView) {
        if let plugin = loadedPlugins[action],
           plugin.action == action {
            plugin.callAsAction(message, with: webView)
        } else {
            assertionFailure("Failed to resolve \(action): Action is not loaded. Please ensure the plugin is correctly loaded.")
        }
    }
}
