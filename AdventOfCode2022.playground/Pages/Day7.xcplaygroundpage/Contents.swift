import Foundation

extension Day7 {

    struct Constant {
        static let cdIn = "$ cd "
        static let cdOut = "$ cd .."
        static let ls = "$ ls"
        static let dir = "dir "
    }

    static func part1() -> Int {
        let root = TreeNode(name: "/", type: .dir)
        parseTree(Array(Day7.data.components(separatedBy: .newlines).dropFirst()), root)
        return sumAtMost100000(root)
    }

    static func part2() -> Int {
        let root = TreeNode(name: "/", type: .dir)
        parseTree(Array(Day7.data.components(separatedBy: .newlines).dropFirst()), root)
        return freeUpSpace(root, 30000000 - (70000000 - root.value), root.value)
    }

    private static func parseTree(_ c: [String], _ node: TreeNode) -> ([String], TreeNode) {
        var currentNode = node
        var commands = c

        while !commands.isEmpty {
            let command = commands.first!
            commands.removeFirst()

            if command.starts(with: "$ ls") {
                continue
            } else if command.starts(with: "dir ") {
                currentNode.nodes.insert(
                    TreeNode(
                        name: command.components(separatedBy: .whitespaces).last!,
                        type: .dir,
                        value: 0
                    )
                )
            } else if let intRange = command.rangeOfCharacter(from: CharacterSet.decimalDigits),
                      intRange.lowerBound != intRange.upperBound,
                      intRange.lowerBound == command.startIndex {
                let newNode = TreeNode(
                    name: command.components(separatedBy: .whitespaces).last!,
                    type: .file,
                    value: Int(command.components(separatedBy: .whitespaces).first!)!
                )
                currentNode.nodes.insert(newNode)
                currentNode.value += newNode.value
            } else if command.starts(with: "$ cd ") {
                let name = command.components(separatedBy: .whitespaces).last!
                if name == ".." {
                    return (commands, currentNode)
                } else {
                    let foundNode = currentNode.nodes.filter { $0.name == name }.first!
                    currentNode.value -= foundNode.value
                    let (remainingCommands, updatedNode) = parseTree(commands, foundNode)
                    commands = remainingCommands
                    currentNode.nodes.insert(updatedNode)
                    currentNode.value += updatedNode.value
                }
            } else {
                fatalError("Unknown command.")
            }
        }

        return ([], currentNode)
    }

    private static func sumAtMost100000(_ node: TreeNode) -> Int {
        var result = 0
        switch node.type {
        case .file:
            return 0
        case .dir:
            for currentNode in node.nodes {
                result += sumAtMost100000(currentNode)
            }
            result += node.value < 100000 ? node.value : 0
        }
        return result
    }

    private static func freeUpSpace(
        _ node: TreeNode,
        _ neededSpace: Int,
        _ currentMin: Int
    ) -> Int {
        var result = currentMin
        switch node.type {
        case .file:
            return currentMin
        case .dir:
            result = (node.value > neededSpace && node.value < currentMin)
                ? node.value
                : currentMin
            for currentNode in node.nodes {
                result = min(result, freeUpSpace(currentNode, neededSpace, currentMin))
            }
        }

        return result
    }

}

print(Day7.part1())
print(Day7.part2())
