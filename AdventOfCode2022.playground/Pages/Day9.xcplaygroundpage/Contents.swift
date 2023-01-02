import Foundation

extension Day9 {

    enum Direction: String {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"
    }

    struct Move {
        var direction: Direction
        var steps: Int
    }

    struct Coordinate: Equatable, Hashable {
        var x: Int
        var y: Int

        func isNeighbor(of otherCoordinate: Coordinate) -> Bool {
            [
                Coordinate(x: x - 1, y: y - 1),
                Coordinate(x: x - 1, y: y),
                Coordinate(x: x - 1, y: y + 1),
                Coordinate(x: x, y: y - 1),
                Coordinate(x: x, y: y),
                Coordinate(x: x, y: y + 1),
                Coordinate(x: x + 1, y: y - 1),
                Coordinate(x: x + 1, y: y),
                Coordinate(x: x + 1, y: y + 1),
            ].contains(otherCoordinate)
        }

        func move(_ direction: Direction) -> Coordinate {
            switch direction {
            case .up: return Coordinate(x: x, y: y + 1)
            case .down: return Coordinate(x: x, y: y - 1)
            case .left: return Coordinate(x: x - 1, y: y)
            case .right: return Coordinate(x: x + 1, y: y)
            }
        }

        func follow(_ otherCoordinate: Coordinate, in direction: Direction) -> Coordinate {
            if self.isNeighbor(of: otherCoordinate) { return self }

            var result = self

            switch direction {
            case .up:
                result = Coordinate(x: x == otherCoordinate.x ? x : otherCoordinate.x, y: y + 1)
            case .down:
                result = Coordinate(x: x == otherCoordinate.x ? x : otherCoordinate.x, y: y - 1)
            case .left:
                result = Coordinate(x: x - 1, y: y == otherCoordinate.y ? y : otherCoordinate.y)
            case .right:
                result = Coordinate(x: x + 1, y: y == otherCoordinate.y ? y : otherCoordinate.y)
            }

            return result
        }
    }

    static func countTailVisits() -> Int {
        let moves = Day9.data.components(separatedBy: .newlines)
            .map {
                Move(
                    direction: Direction(
                        rawValue: $0.components(separatedBy: .whitespaces).first!
                    )!,
                    steps: Int($0.components(separatedBy: .whitespaces).last!)!
                )
            }

        var head = Coordinate(x: 0, y: 0)
        var tail = Coordinate(x: 0, y: 0)
        var result = Set<Coordinate>(arrayLiteral: tail)

        for move in moves {
            for _ in 0..<move.steps {
                head = head.move(move.direction)
                tail = tail.follow(head, in: move.direction)

                result.insert(tail)
            }
        }

        return result.count
    }
    
}

print(Day9.countTailVisits())
