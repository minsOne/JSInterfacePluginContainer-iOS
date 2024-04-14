import Foundation

#if DEBUG
public extension [JSInterfacePlugin] {
    @discardableResult
    func update<T: JSInterfacePlugin>(_ type: T.Type, closure: (T) -> Void) -> Self {
        var plugins = self
        let plugin = plugins.first(where: { $0 is T }) as? T
        guard let plugin else { return self }

        closure(plugin)
        plugins.replace(plugin)

        return plugins
    }

    mutating func replace(_ newPlugin: JSInterfacePlugin) {
        removeAll(where: { $0.action == newPlugin.action })
        append(newPlugin)
    }

    mutating func replace(contentsOf newPlugins: [JSInterfacePlugin]) {
        let actions = newPlugins.map(\.action)
        removeAll(where: {
            let action = $0.action
            if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
                return actions.contains([action])
            } else {
                return actions.contains(where: { $0 == action })
            }
        })
        append(contentsOf: newPlugins)
    }

    func replacing(_ newPlugin: JSInterfacePlugin) -> Self {
        var list = self
        list.replace(newPlugin)
        return list
    }

    func replacing(contentsOf newPlugins: [JSInterfacePlugin]) -> Self {
        var list = self
        list.replace(contentsOf: newPlugins)
        return list
    }
}
#endif
