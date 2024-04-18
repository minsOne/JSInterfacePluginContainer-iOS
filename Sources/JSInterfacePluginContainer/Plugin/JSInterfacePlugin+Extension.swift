import Foundation

public extension [JSInterfacePlugin] {
    /// set a plugin of a specific type within the array.
    /// - Parameters:
    ///   - type: The type of plugin to update.
    ///   - closure: A closure that modifies the plugin.
    /// - Returns: The updated array of plugins.
    @discardableResult
    func set<T: JSInterfacePlugin>(_ type: T.Type, closure: (T) -> Void) -> Self {
        guard
            let index = firstIndex(where: { $0 is T }),
            let plugin = self[index] as? T
        else { return self }

        closure(plugin)
        var plugins = self
        plugins[index] = plugin

        return plugins
    }
}

#if DEBUG
public extension [JSInterfacePlugin] {
    /// Replaces an existing plugin with a new one.
    mutating func replace(_ newPlugin: JSInterfacePlugin) {
        if let index = firstIndex(where: { $0.action == newPlugin.action }) {
            self[index] = newPlugin
        } else {
            append(newPlugin)
        }
    }

    /// Replaces existing plugins with a new collection.
    mutating func replace(contentsOf newPlugins: [JSInterfacePlugin]) {
        newPlugins.forEach { replace($0) }
    }

    /// Returns a new array replacing a plugin.
    func replacing(_ newPlugin: JSInterfacePlugin) -> Self {
        var list = self
        list.replace(newPlugin)
        return list
    }

    /// Returns a new array replacing multiple plugins.
    func replacing(contentsOf newPlugins: [JSInterfacePlugin]) -> Self {
        var list = self
        list.replace(contentsOf: newPlugins)
        return list
    }
}
#endif
