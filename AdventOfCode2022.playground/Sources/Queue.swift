import Foundation

public class Queue {

    public var isEmpty: Bool { items.isEmpty }
    public var isUnique: Bool { Set(items).count == items.count }
    public var size: Int { items.count }
    
    private var items = [String]()
    private let maxSize: Int?

    public init(_ items: [String] = [], maxSize: Int? = nil) {
        if let maxSize = maxSize {
            self.items = items.suffix(maxSize)
        } else {
            self.items = items
        }

        self.maxSize = maxSize
    }

    public func enqueue(_ item: String) {
        items.append(item)

        if let maxSize = maxSize, items.count > maxSize {
            dequeue()
        }
    }

    @discardableResult
    public func dequeue() -> String {
        items.removeFirst()
    }
}
