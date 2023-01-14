import Foundation

extension Day14 {

    struct Coordinate: Comparable, Equatable, Hashable {
        let column: Int
        let row: Int

        var oneStepDown: Coordinate { Coordinate(column: column, row: row + 1) }
        var oneStepDownAndLeft: Coordinate { Coordinate(column: column - 1, row: row + 1) }
        var oneStepDownAndRight: Coordinate { Coordinate(column: column + 1, row: row + 1) }

        init(column: Int, row: Int) {
            self.column = column
            self.row = row
        }

        init(_ data: [String]) {
            self.init(column: Int(data.first!)!, row: Int(data.last!)!)
        }

        // MARK: - Comparable

        static func <(lhs: Coordinate, rhs: Coordinate) -> Bool {
            (lhs.column != rhs.column) ? (lhs.column < rhs.column) : (lhs.row <= rhs.row)
        }
    }

    class Grid {
        enum AvailableDirection {
            case down
            case left
            case right
            case none
            case flowingIntoTheAbyss
        }

        let value: Set<Coordinate>
        private let maxRow: Int

        init(value: Set<Coordinate>) {
            self.value = value
            self.maxRow = value.map { $0.row }.max()!
        }

        func availableDirection(for coordinate: Coordinate) -> AvailableDirection {
            if coordinate.row > maxRow { return .flowingIntoTheAbyss }
            if !value.contains(coordinate.oneStepDown) { return .down }
            if !value.contains(coordinate.oneStepDownAndLeft) { return .left }
            if !value.contains(coordinate.oneStepDownAndRight) { return .right }
            return .none
        }

        func copy(with coordinate: Coordinate) -> Grid {
            Grid(value: value.union([coordinate]))
        }
    }

    enum LandingResult {
        case landed
        case flowingIntoTheAbyss
    }

    static func countRestingSand() -> Int {
        var grid = Grid(
            value: Day14.data
                .components(separatedBy: .newlines).map { line in
                    let coordinates = line.components(separatedBy: " -> ").map {
                        Coordinate($0.components(separatedBy: ","))
                    }
                    var result = Set<Coordinate>()
                    for i in 1..<coordinates.count {
                        let prev = coordinates[i - 1]
                        let curr = coordinates[i]

                        for j in min(prev.column, curr.column)...max(prev.column, curr.column) {
                            result.insert(Coordinate(column: j, row: curr.row))
                        }

                        for j in min(prev.row, curr.row)...max(prev.row, curr.row) {
                            result.insert(Coordinate(column: curr.column, row: j))
                        }
                    }

                    return Array(result)
                }
                .reduce(Set<Coordinate>()) { $0.union($1) }
        )

        var restingSand = -1
        var landingResult = LandingResult.landed

        repeat {
            restingSand += 1
            (landingResult, grid) = landSand(in: grid)
        } while landingResult != .flowingIntoTheAbyss

        return restingSand
    }

    private static func landSand(
        from startPoint: Coordinate = Coordinate(column: 500, row: 0),
        in grid: Grid
    ) -> (LandingResult, Grid) {
        switch grid.availableDirection(for: startPoint) {
        case .down: return landSand(from: startPoint.oneStepDown, in: grid)
        case .left: return landSand(from: startPoint.oneStepDownAndLeft, in: grid)
        case .right: return landSand(from: startPoint.oneStepDownAndRight, in: grid)
        case .none: return (.landed, grid.copy(with: startPoint))
        case .flowingIntoTheAbyss: return (.flowingIntoTheAbyss, grid)
        }
    }

}

print(Day14.countRestingSand())
