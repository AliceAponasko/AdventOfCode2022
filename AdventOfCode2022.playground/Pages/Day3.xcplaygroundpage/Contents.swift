import Foundation

extension Day3 {

    static var singlePriority: Int {
        Day3.data
            .components(separatedBy: .newlines)
            .reduce(into: 0) {
                $0 += $1[to: $1.count / 2].toSet()
                    .intersection($1[from: $1.count / 2].toSet())
                    .first!
                    .priority
            }
    }

    static var groupPriority: Int {
        let elfs = Day3.data.components(separatedBy: .newlines)
        var result = 0
        for i in stride(from: 0, to: elfs.count, by: 3) {
            result += elfs[i].toSet()
                .intersection(elfs[i + 1].toSet())
                .intersection(elfs[i + 2].toSet())
                .first!
                .priority
        }
        return result
    }

}

private extension String {

    var priority: Int {
        let selfValue = UnicodeScalar(self)!.value
        for c in UnicodeScalar("a").value...UnicodeScalar("z").value {
            if c == selfValue { return Int(c - 96) }
        }
        for c in UnicodeScalar("A").value...UnicodeScalar("Z").value {
            if c == selfValue { return Int(c - 38) }
        }
        fatalError("Welp.")
    }

    func toSet() -> Set<String> {
        reduce(into: Set<String>()) { $0.insert(String($1)) }
    }

}

print(Day3.singlePriority)
print(Day3.groupPriority)
