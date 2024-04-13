import Foundation
import ObjectiveC.runtime

#if DEBUG
public struct JSInterfacePluginScanner {
    init() {}
    var classPtrInfo: (classesPtr: UnsafeMutablePointer<AnyClass>, numberOfClasses: Int)? {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        guard numberOfClasses > 0 else {
            return nil
        }

        let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses)
        let autoreleasingClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
        let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses))
        assert(numberOfClasses == count)

        return (classesPtr, numberOfClasses)
    }

    var plugins: [JSInterfacePlugin.Type] {
        guard let (classesPtr, numberOfClasses) = classPtrInfo else {
            return []
        }
        defer { classesPtr.deallocate() }

        let start = Date()
        let (firstIndex, lastIndex) = (0, numberOfClasses)
        var (plugins, ptrIndex) = ([JSInterfacePlugin.Type](), [Int]())
        let superCls = JSInterfacePluginBaseType.self

        // MARK: Case 1 - class_getSuperclass

        for i in firstIndex ..< lastIndex {
            let cls: AnyClass = classesPtr[i]
            if class_getSuperclass(cls) == superCls,
               case let kcls as any JSInterfacePlugin.Type = cls
            {
                ptrIndex.append(i)
                plugins.append(kcls)
            }
        }

        print("""
        ┌───── \(Self.self) \(#function) ──────
        │ Duration : \((Date().timeIntervalSince(start) * 1000).rounded())ms
        │ numberOfClasses : \(numberOfClasses)
        │ JSInterfacePlugin classPtr Index : \(ptrIndex)
        │ JSInterfacePlugin List :
        │  - \(plugins)
        └────────────────────────────────────────────────
        """)
        return plugins
    }
}
#endif
