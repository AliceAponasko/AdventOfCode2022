import Foundation

public enum NodeType: Hashable {
    case file
    case dir
}

public class Node: Hashable, Equatable {
    public var name: String
    public var nodes: Set<Node>
    public var type: NodeType
    public var value: Int

    public var debugDescription: String { "\(type) \(name) \(value) \(nodes.map { $0.debugDescription })" }
    public var hashValue: Int { name.hashValue }

    public init(
        name: String,
        nodes: Set<Node> = Set<Node>(),
        type: NodeType,
        value: Int = 0
    ) {
        self.name = name
        self.nodes = nodes
        self.type = type
        self.value = value
    }

    public static func ==(lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name
    }

}
