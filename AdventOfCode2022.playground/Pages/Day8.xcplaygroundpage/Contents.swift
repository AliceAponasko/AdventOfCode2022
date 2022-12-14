import Foundation

extension Day8 {

    static var visibleTrees: Int {
        var grid = Day8.data
            .components(separatedBy: .newlines)
            .map { $0.compactMap { Int(String($0)) } }

        var result = grid.first!.count * 2 + (grid.count - 2) * 2

        for i in 1..<grid.count - 1 {
            for j in 1..<grid[i].count - 1 {
                result += Tree(line: i, column: j).isVisible(grid) ? 1 : 0
            }
        }

        return result
    }

    static var scenicScore: Int {
        var grid = Day8.data
            .components(separatedBy: .newlines)
            .map { $0.compactMap { Int(String($0)) } }

        var result = 0

        for i in 1..<grid.count - 1 {
            for j in 1..<grid[i].count - 1 {
                result = max(Tree(line: i, column: j).scenicScore(grid), result)
            }
        }

        return result
    }

    struct Tree {

        var line: Int
        var column: Int

        enum Direction {
            case left
            case right
            case top
            case bottom
        }

        func isVisible(_ grid: [[Int]]) -> Bool {
            look(.left, stride(from: column - 1, through: 0, by: -1), grid).isVisible ||
            look(.right, stride(from: column + 1, through: grid[line].count - 1, by: 1), grid).isVisible ||
            look(.top, stride(from: line - 1, through: 0, by: -1), grid).isVisible ||
            look(.bottom, stride(from: line + 1, through: grid.count - 1, by: 1), grid).isVisible
        }

        func scenicScore(_ grid: [[Int]]) -> Int {
            look(.left, stride(from: column - 1, through: 0, by: -1), grid).scenicScore *
            look(.right, stride(from: column + 1, through: grid[line].count - 1, by: 1), grid).scenicScore *
            look(.top, stride(from: line - 1, through: 0, by: -1), grid).scenicScore *
            look(.bottom, stride(from: line + 1, through: grid.count - 1, by: 1), grid).scenicScore
        }

        private func look(
            _ direction: Direction,
            _ range: StrideThrough<Int>,
            _ grid: [[Int]]
        ) -> (isVisible: Bool, scenicScore: Int) {
            var isVisible = true
            var scenicScore = 0

            for i in range {
                scenicScore += 1

                let neighbor: Int
                switch direction {
                case .left, .right: neighbor = grid[line][i]
                case .top, .bottom: neighbor = grid[i][column]
                }

                if neighbor >= grid[line][column] {
                    isVisible = false
                    break
                }
            }

            return (isVisible, scenicScore)
        }

    }

}

print(Day8.visibleTrees)
print(Day8.scenicScore)
