import Foundation

extension Day13 {

    enum Packet: Comparable, Decodable {
        case int(Int)
        case list([Packet])

        /// decoding inspired by
        /// https://www.reddit.com/r/adventofcode/comments/zkmyh4/comment/j03uulc/
        public init(from decoder: Decoder) {
            do {
                self = .int(try decoder.singleValueContainer().decode(Int.self))
            } catch {
                self = .list(try! [Packet](from: decoder))
            }
        }

        static func <(_ lhs: Packet, _ rhs: Packet) -> Bool {
            switch (lhs, rhs) {
            case (let .list(lhsValue), let .list(rhsValue)):
                for (l, r) in zip(lhsValue, rhsValue) {
                    if l < r { return true }
                    else if l > r { return false }
                }
                return lhsValue.count < rhsValue.count

            case (let .int(lhsValue), let .int(rhsValue)):
                return lhsValue < rhsValue

            case (.int, .list):
                return .list([lhs]) < rhs

            case (.list, .int):
                return lhs < .list([rhs])
            }
        }
    }

    static func sumIndexes() -> Int {
        Day13.data
            .replacingOccurrences(of: "\n\n", with: "\n")
            .components(separatedBy: .newlines)
            .map { try! JSONDecoder().decode(Packet.self, from: $0.data(using: .utf8)!) }
            .splitIntoPairs()
            .enumerated()
            .map { $1.first! < $1.last! ? $0 + 1 : 0 }
            .reduce(0, +)
    }

    static func multiplySortedIndexes() -> Int {
        let two = Packet.list([.list([.int(2)])])
        let six = Packet.list([.list([.int(6)])])

        var packets = Day13.data
            .replacingOccurrences(of: "\n\n", with: "\n")
            .components(separatedBy: .newlines)
            .map { try! JSONDecoder().decode(Packet.self, from: $0.data(using: .utf8)!) }

        packets.append(contentsOf: [two, six])
        packets.sort()

        return (packets.firstIndex(of: two)! + 1) * (packets.firstIndex(of: six)! + 1)
    }

}

private extension Array {

    func splitIntoPairs() -> [[Element]] {
        stride(from: 0, to: count, by: 2).map {
            Array(self[$0..<Swift.min($0 + 2, count)])
        }
    }

}

print(Day13.sumIndexes())
print(Day13.multiplySortedIndexes())
