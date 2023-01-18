import Foundation

public enum TreeNodeType: Hashable {
    case file
    case dir
}

public class TreeNode: Hashable, Equatable {
    
    public var name: String
    public var nodes: Set<TreeNode>
    public var type: TreeNodeType
    public var value: Int

    public var debugDescription: String {
        "\(type) \(name) \(value) \(nodes.map { $0.debugDescription })"
    }

    public init(
        name: String,
        nodes: Set<TreeNode> = Set<TreeNode>(),
        type: TreeNodeType,
        value: Int = 0
    ) {
        self.name = name
        self.nodes = nodes
        self.type = type
        self.value = value
    }

    // MARK: - Equatable

    public static func ==(lhs: TreeNode, rhs: TreeNode) -> Bool {
        lhs.name == rhs.name
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

}
