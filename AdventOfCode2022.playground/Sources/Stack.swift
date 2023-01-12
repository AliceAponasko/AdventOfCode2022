import Foundation

public class Stack {

    public var description: String { items.description }
    public var isEmpty: Bool { items.isEmpty }
    public var last: String { items.last! }
    public var size: Int { items.count }

    private var items = [String]()

    public init(_ items: [String] = []) {
        self.items = items
    }

    public func push(_ item: String) {
        items.append(item)
    }

    public func push(_ moreItems: [String]) {
        items.append(contentsOf: moreItems)
    }

    public func pop() -> String {
        items.removeLast()
    }

    public func pop(_ k: Int) -> [String] {
        let result = items.suffix(k)
        items.removeLast(k)
        return Array(result)
    }

}
