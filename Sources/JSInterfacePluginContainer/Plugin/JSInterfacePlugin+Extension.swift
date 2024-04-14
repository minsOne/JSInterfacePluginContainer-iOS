import Foundation

#if DEBUG
public extension [JSInterfacePlugin] {
    /// Updates a plugin of a specific type within the array.
    /// - Parameters:
    ///   - type: The type of plugin to update.
    ///   - closure: A closure that modifies the plugin.
    /// - Returns: The updated array of plugins.
    @discardableResult
    func update<T: JSInterfacePlugin>(_ type: T.Type, closure: (T) -> Void) -> Self {
        guard
            let index = firstIndex(where: { $0 is T })
        else { return self }

        var plugins = self
        if let plugin = plugins[index] as? T {
            closure(plugin)
            plugins[index] = plugin
        }

        return plugins
    }

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
