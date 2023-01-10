import Foundation

extension Day11 {

    enum Operation: Equatable, Hashable {
        case plus(Int)
        case multiply(Int)
        case multiplySelf
    }

    class Monkey: Equatable, Hashable {
        var id: Int!
        var items: [Int]!
        var operation: Operation!
        var test: Int!
        var trueMonkeyID: Int!
        var falseMonkeyID: Int!

        init() {}

        func newWorryLevel(_ item: Int) -> Int {
            switch operation {
            case let .plus(value): return item + value
            case let .multiply(value): return item * value
            case .multiplySelf: return item * item
            default: fatalError("Unknown operation.")
            }
        }

        // MARK: - Equatable

        static func ==(lhs: Monkey, rhs: Monkey) -> Bool {
            lhs.id == rhs.id
        }

        // MARK: - Hashable

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    static func whichMonkeyToChase(rounds: Int, relief: Int) -> Int {
        let monkeys = parseData(Day11.data)
        var result = monkeys.reduce(into: [Int: Int]()) { $0[$1.key] = 0 }

        for _ in 0..<rounds {
            for key in 0..<monkeys.count {
                let monkey = monkeys[key]!
                for item in monkey.items {
                    let worryLevel = monkey.newWorryLevel(item) / relief
                    if worryLevel % monkey.test == 0 {
                        monkeys[monkey.trueMonkeyID]!.items.append(worryLevel)
                    } else {
                        monkeys[monkey.falseMonkeyID]!.items.append(worryLevel)
                    }
                }

                result[monkey.id]! += monkeys[monkey.id]!.items.count
                monkeys[monkey.id]!.items = []
            }
        }

        return result.values.sorted().suffix(2).reduce(1, *)
    }

    private static func parseData(_ data: String) -> [Int: Monkey] {
        data.components(separatedBy: "\n\n").map { paragraph in
            let lines = paragraph.components(separatedBy: .newlines)
            let monkey = Monkey()

            for i in 0..<lines.count {
                switch i {
                case 0:
                    let stringID = lines[i].components(separatedBy: .whitespaces).last!.dropLast()
                    monkey.id = Int(stringID)!

                case 1:
                    var stringItems = lines[i].replacingOccurrences(
                        of: "  Starting items: ",
                        with: ""
                    )
                    stringItems = stringItems.replacingOccurrences(of: " ", with: "")
                    monkey.items = stringItems.components(separatedBy: ",").map { Int($0)! }

                case 2:
                    let stringOperation = lines[i].replacingOccurrences(
                        of: "  Operation: new = old ",
                        with: ""
                    )
                    let operationComponents = stringOperation.components(separatedBy: .whitespaces)
                    if operationComponents.first! == "+" {
                        monkey.operation = .plus(Int(operationComponents.last!)!)
                    } else {
                        if let multiplyValue = Int(operationComponents.last!) {
                            monkey.operation = .multiply(multiplyValue)
                        } else {
                            monkey.operation = .multiplySelf
                        }
                    }

                case 3:
                    let stringTest = lines[i].replacingOccurrences(
                        of: "  Test: divisible by ",
                        with: ""
                    )
                    monkey.test = Int(String(stringTest))!

                case 4:
                    let stringTestTrue = lines[i].replacingOccurrences(
                        of: "    If true: throw to monkey ",
                        with: ""
                    )
                    monkey.trueMonkeyID = Int(String(stringTestTrue.first!))!

                case 5:
                    let stringTestFalse = lines[i].replacingOccurrences(
                        of: "    If false: throw to monkey ",
                        with: ""
                    )
                    monkey.falseMonkeyID = Int(String(stringTestFalse.first!))!

                default:
                    fatalError("Who is \(lines[i])")
                }
            }

            return monkey
        }.reduce(into: [Int: Monkey]()) { $0[$1.id] = $1 }
    }
    
}

print(Day11.whichMonkeyToChase(rounds: 20, relief: 3))
