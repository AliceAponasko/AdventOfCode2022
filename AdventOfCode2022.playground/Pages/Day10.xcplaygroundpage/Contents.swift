import Foundation

extension Day10 {

    enum Instruction {
        case add(value: Int)
        case noop
    }

    static func calculateStrengths() -> Int {
        var x = 1
        var cycle = 0
        var strength = 0

        let instructions = Day10.data.components(separatedBy: .newlines).map {
            switch $0.components(separatedBy: .whitespaces).first! {
            case "noop":
                return Instruction.noop
            case "addx":
                return Instruction.add(value: Int($0.components(separatedBy: .whitespaces).last!)!)
            default:
                fatalError("Unknown instruction \($0)")
            }
        }

        for instruction in instructions {
            cycle += 1
            if shouldCheckCycle(cycle) { strength += cycle * x }

            switch instruction {
            case let .add(value):
                cycle += 1
                if shouldCheckCycle(cycle) { strength += cycle * x }
                x += value
            default:
                break
            }
        }

        return strength
    }

    private static func shouldCheckCycle(_ cycle: Int) -> Bool {
        (cycle > 0) && (cycle <= 220) && (cycle == 20 || cycle % 40 == 20)
    }

}

print(Day10.calculateStrengths())
