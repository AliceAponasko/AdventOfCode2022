import Foundation

extension Day12 {

    struct Coordinate: Hashable {
        let line: Int
        let column: Int
    }

    struct Vertex: Equatable, Hashable {
        var coordinate: Coordinate
        var value: Character
    }

    struct Edge: Equatable, Hashable {
        var source: Vertex
        var destination: Vertex
        let weight: Int
    }

    enum Visit {
        case source
        case edge(Edge)
    }

    class Graph {
        private var map = [Vertex: [Edge]]()

        init() {}

        func createVertex(_ coordinate: Coordinate, _ value: Character) -> Vertex {
            let vertex = Vertex(coordinate: coordinate, value: value)

            if !map.keys.contains(vertex) {
                map[vertex] = []
            }

            return vertex
        }

        func addEdge(from source: Vertex, to destination: Vertex, weight: Int) {
            let edge = Edge(source: source, destination: destination, weight: weight)

            if !map.keys.contains(source) {
                map[source] = []
            }

            map[source]?.append(edge)
        }

        func addEdges(_ edges: [Edge], for source: Vertex) {
            map[source] = edges
        }

        func edges(for source: Vertex) -> [Edge]? {
            map[source]
        }

        func weight(from source: Vertex, to destination: Vertex) -> Int? {
            guard let edges = map[source] else { return nil }

            for edge in edges {
                if edge.destination == destination {
                    return edge.weight
                }
            }

            return nil
        }

        func breadthFirstSearch(from source: Vertex, to destination: Vertex) -> [Edge]? {
            var queueArray = [Vertex]()
            queueArray.append(source)

            var visits = [source: Visit.source]

            while queueArray.count != 0 {
                let visitedVertex = queueArray.removeFirst()

                if visitedVertex == destination {
                    var vertex = destination
                    var route = [Edge]()

                    while let visit = visits[vertex],
                        case let .edge(edge) = visit {
                            route = [edge] + route
                            vertex = edge.source

                    }

                    return route
                }

                for edge in edges(for: visitedVertex)! {
                    if visits[edge.destination] == nil {
                        queueArray.append(edge.destination)
                        visits[edge.destination] = .edge(edge)
                    }
                }
            }

            return nil
        }
    }

    static func fewestStepsToSignal() -> Int {
        let grid = Day12.data.components(separatedBy: .newlines).map { Array($0) }
        let graph = Graph()

        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                let source = graph.createVertex(Coordinate(line: i, column: j), grid[i][j])
                graph.addEdges(makeEdges(for: source, grid: grid), for: source)
            }
        }

        let startLine = grid.firstIndex { $0.contains("S") }!
        let startColumn = grid[startLine].firstIndex { $0 == "S" }!

        let endLine = grid.firstIndex(where: { $0.contains("E") })!
        let endColumn = grid[endLine].firstIndex(where: { $0 == "E" })!

        return graph.breadthFirstSearch(
            from: Vertex(coordinate: Coordinate(line: startLine, column: startColumn), value: "S"),
            to: Vertex(coordinate: Coordinate(line: endLine, column: endColumn), value: "E")
        )?.count ?? 0
    }

    private static func makeEdges(for vertex: Vertex, grid: [[Character]]) -> [Edge] {
        var result = [Edge]()

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
            let destination = Vertex(
                coordinate: Coordinate(
                    line: vertex.coordinate.line + x,
                    column: vertex.coordinate.column + y
                ),
                value: grid[vertex.coordinate.line + x][vertex.coordinate.column + y]
            )

            let weight = weight(source, destination)
            if weight <= 1 {
                result.append(
                    Edge(source: source, destination: destination, weight: weight)
                )
            }
        }

        return result
    }

    private static func weight(_ source: Vertex, _ destination: Vertex) -> Int {
        let alphabet = Array("abcdefghijklmnopqrstuvwxyz")

        if let sourceIndex = alphabet.firstIndex(of: source.value),
           let destinationIndex = alphabet.firstIndex(of: destination.value) {
            return destinationIndex - sourceIndex
        }

        return 1
    }

}

print(Day12.fewestStepsToSignal())
