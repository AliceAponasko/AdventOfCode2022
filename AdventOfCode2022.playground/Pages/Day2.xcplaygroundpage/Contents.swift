import Foundation

extension Day2 {

    // A for Rock, B for Paper, and C for Scissors
    // X for Rock, Y for Paper, and Z for Scissors
    // shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors)
    // plus the score for the outcome of the round
    // (0 if you lost, 3 if the round was a draw, and 6 if you won)

    enum Move: Int {
        case rock = 1
        case paper = 2
        case scissors = 3

        init(_ value: String) {
            switch value {
            case "A", "X": self = .rock
            case "B", "Y": self = .paper
            case "C", "Z": self = .scissors
            default: fatalError("What do you mean \(value)?")
            }
        }

        static func resultOf(_ move: Move, _ result: Result) -> Move {
            switch (move, result) {
            case (.rock, .draw), (.paper, .lose), (.scissors, .win): return .rock
            case (.rock, .win), (.paper, .draw), (.scissors, .lose): return .paper
            case (.rock, .lose), (.paper, .win), (.scissors, .draw): return .scissors
            }
        }
    }

    // A for Rock, B for Paper, and C for Scissors
    // shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors)
    // X means you need to lose,
    // Y means you need to end the round in a draw,
    // and Z means you need to win

    enum Result: Int {
        case lose = 0
        case draw = 3
        case win = 6

        init(_ value: String) {
            switch value {
            case "X": self = .lose
            case "Y": self = .draw
            case "Z": self = .win
            default: fatalError("Did you win or lose tho \(value)?")
            }
        }

        static func ofPlay(_ move1: Move, _ move2: Move) -> Result {
            switch (move1, move2) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper): return .lose
            case (.rock, .rock), (.paper, .paper), (.scissors, .scissors): return .draw
            case (.rock, .paper), (.paper, .scissors), (.scissors, .rock): return .win
            }
        }
    }

    static func followStrategy() -> Int {
        Day2.data
            .components(separatedBy: .newlines)
            .reduce(into: 0) {
                let moves = $1.components(separatedBy: " ").compactMap { Move($0) }
                $0 += moves.last!.rawValue + Result.ofPlay(moves.first!, moves.last!).rawValue
            }
    }

    static func followSecretStrategy() -> Int {
        Day2.data
            .components(separatedBy: .newlines)
            .reduce(into: 0) {
                let moves = $1.components(separatedBy: " ")
                let result = Result(moves.last!)
                let myMove = Move.resultOf(Move(moves.first!), result)
                $0 += myMove.rawValue + result.rawValue
            }
    }

}

print(Day2.followStrategy())
print(Day2.followSecretStrategy())
