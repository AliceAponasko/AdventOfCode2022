import Foundation

extension Day4 {

    enum Condition {
        case fullyContain
        case overlap
    }

    static func findRanges(that condition: Condition) -> Int {
        Day4.data
            .components(separatedBy: .newlines)
            .reduce(into: 0) {
                let elves = $1.components(separatedBy: ",")
                switch condition {
                case .fullyContain:
                    $0 += ClosedRange.contains(elves[0].tasksToRange, elves[1].tasksToRange) ? 1 : 0
                case .overlap:
                    $0 += ClosedRange.overlaps(elves[0].tasksToRange, elves[1].tasksToRange) ? 1 : 0
                }
            }
    }

}

private extension Array where Element == Int {

    var range: ClosedRange<Int> { first!...last! }

}

private extension ClosedRange {

    func contains(_ range: Self) -> Bool {
        clamped(to: range) == self
    }

    static func contains(_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.contains(rhs) || rhs.contains(lhs)
    }

    static func overlaps(_ lhs: Self, _ rhs: Self) -> Bool {
        lhs.overlaps(rhs) || rhs.overlaps(lhs)
    }

}

private extension String {

    var tasksToRange: ClosedRange<Int> {
        components(separatedBy: "-").compactMap { Int($0) }.range
    }

}

print(Day4.findRanges(that: .fullyContain))
print(Day4.findRanges(that: .overlap))
