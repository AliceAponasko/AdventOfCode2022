import Foundation

extension Day5 {

    enum CrateMover {
        case old
        case new
    }

    static func rearrange(with crateMover: CrateMover) -> String {
        let stacks = parseStacks(Day5.data.components(separatedBy: "\n\n")[0])

        Day5.data
            .components(separatedBy: "\n\n")[1]
            .components(separatedBy: .newlines)
            .forEach {
                var words = $0.components(separatedBy: .whitespaces)

                switch crateMover {
                case .old:
                    [Int](0..<Int(words[1])!).forEach { _ in
                        stacks[Int(words[5])! - 1].push(
                            stacks[Int(words[3])! - 1].pop()
                        )
                    }

                case .new:
                    stacks[Int(words[5])! - 1].push(
                        stacks[Int(words[3])! - 1].pop(
                            Int(words[1])!
                        )
                    )
                }

            }

        return stacks.reduce(into: "") { $0 += $1.last }
    }

    private static func parseStacks(_ data: String) -> [Stack] {
        var lines = data.components(separatedBy: .newlines)
        let numberOfStacks = lines[8]
            .components(separatedBy: .whitespaces)
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .count

        var stacks = [Stack]()
        [Int](0..<numberOfStacks).forEach { _ in stacks.append(Stack()) }

        for i in stride(from: 7, through: 0, by: -1) {
            var words = lines[i].components(separatedBy: .whitespaces)
            var index = 0
            while index < words.count {
                if words[index].isEmpty {
                    [Int](index..<index + 4).forEach { _ in words.remove(at: index) }
                    words.insert(" ", at: index)
                } else {
                    index += 1
                }
            }

            for k in 0..<words.count {
                if !words[k].trimmingCharacters(in: .whitespaces).isEmpty {
                    stacks[k].push(words[k][at: 1])
                }
            }
        }

        return stacks
    }

}

print(Day5.rearrange(with: .old))
print(Day5.rearrange(with: .new))
