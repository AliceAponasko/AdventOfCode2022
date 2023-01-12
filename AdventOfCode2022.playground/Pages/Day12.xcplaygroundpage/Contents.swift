import Foundation

extension Day12 {

    static func fewestStepsToSignal() -> Int {
        let grid = Day12.data.components(separatedBy: .newlines).map { Array($0) }
        let graph = Graph()

        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                let source = graph.createVertex(
                    Graph.Coordinate(line: i, column: j),
                    grid[i][j]
                )
                graph.addEdges(
                    makeEdges(for: source, grid: grid),
                    for: source
                )
            }
        }

        let startLine = grid.firstIndex { $0.contains("S") }!
        let startColumn = grid[startLine].firstIndex { $0 == "S" }!

        let endLine = grid.firstIndex(where: { $0.contains("E") })!
        let endColumn = grid[endLine].firstIndex(where: { $0 == "E" })!

        return graph.breadthFirstSearch(
            from: Graph.Vertex(
                coordinate: Graph.Coordinate(line: startLine, column: startColumn),
                value: "S"
            ),
            to: Graph.Vertex(
                coordinate: Graph.Coordinate(line: endLine, column: endColumn),
                value: "E"
            )
        ).count
    }

    private static func makeEdges(for vertex: Graph.Vertex, grid: [[Character]]) -> [Graph.Edge] {
        var result = [Graph.Edge]()

        for (x, y) in [(-1, 0), (0, 1), (1, 0), (0, -1)] {
            guard
                vertex.coordinate.line + x < grid.count,
                vertex.coordinate.line + x >= 0,
                vertex.coordinate.column + y < grid.first!.count,
                vertex.coordinate.column + y >= 0
            else {
                continue
            }

            let source = vertex
            let destination = Graph.Vertex(
                coordinate: Graph.Coordinate(
                    line: vertex.coordinate.line + x,
                    column: vertex.coordinate.column + y
                ),
                value: grid[vertex.coordinate.line + x][vertex.coordinate.column + y]
            )

            let weight = weight(source, destination)
            if weight <= 1 {
                result.append(
                    Graph.Edge(source: source, destination: destination, weight: weight)
                )
            }
        }

        return result
    }

    private static func weight(_ source: Graph.Vertex, _ destination: Graph.Vertex) -> Int {
        let alphabet = Array("abcdefghijklmnopqrstuvwxyz")

        if let sourceIndex = alphabet.firstIndex(of: source.value),
           let destinationIndex = alphabet.firstIndex(of: destination.value) {
            return destinationIndex - sourceIndex
        }

        return 1
    }

}

print(Day12.fewestStepsToSignal())
