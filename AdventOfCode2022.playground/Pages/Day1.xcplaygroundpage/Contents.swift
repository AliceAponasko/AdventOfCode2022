import Foundation

extension Day1 {

    static func maxCalories(for numberOfElves: Int = 1) -> Int {
        Day1.data
            .components(separatedBy: "\n\n")
            .map { $0.components(separatedBy: .newlines).compactMap { Int($0) }.reduce(0, +) }
            .sorted()
            .suffix(numberOfElves)
            .reduce(0, +)
    }

}

print(Day1.maxCalories())
print(Day1.maxCalories(for: 3))
