import Foundation

extension Day12 {

    struct Coordinate: Hashable {
        let x: Int
        let y: Int
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

        func depthFirstSearch(from start: Vertex, to end: Vertex) -> [Vertex] {
            var visited = Set<Vertex>()
            var potentialPath = [Vertex]()

            potentialPath.append(start)
            visited.insert(start)

        outer:
            while let vertex = potentialPath.last, vertex != end {
                guard let neighbors = edges(for: vertex), neighbors.count > 0 else {
                    potentialPath.removeLast()
                    continue
                }

                for edge in neighbors {
                    if !visited.contains(edge.destination) {
                        visited.insert(edge.destination)
                        if edge.weight <= 1 {
                            potentialPath.append(edge.destination)
                            continue outer
                        }
                    }
                }

                potentialPath.removeLast()
            }

            return potentialPath
        }
    }

    static func fewestStepsToSignal() -> Int {
        let grid = """
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
"""
            .components(separatedBy: .newlines)
            .map { Array($0) }

        let graph = Graph()

        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                let source = graph.createVertex(Coordinate(x: i, y: j), grid[i][j])
                graph.addEdges(makeEdges(for: source, grid: grid), for: source)
            }
        }

        let startY = grid.firstIndex { $0.contains("S") }!
        let startX = grid[startY].firstIndex { $0 == "S" }!

        let endY = grid.firstIndex(where: { $0.contains("E") })!
        let endX = grid[endY].firstIndex(where: { $0 == "E" })!

        return graph.depthFirstSearch(
            from: Vertex(coordinate: Coordinate(x: startX, y: startY), value: "S"),
            to: Vertex(coordinate: Coordinate(x: endX, y: endY), value: "E")
        ).count
    }

    private static func makeEdges(for vertex: Vertex, grid: [[Character]]) -> [Edge] {
        var result = [Edge]()

        for (x, y) in [(-1, 0), (0, 1), (1, 0), (0, -1)] {
            guard
                vertex.coordinate.x + x < grid.first!.count,
                vertex.coordinate.x + x >= 0,
                vertex.coordinate.y + y < grid.count,
                vertex.coordinate.y + y >= 0
            else { continue }

            let source = vertex
            let destination = Vertex(
                coordinate: Coordinate(
                    x: vertex.coordinate.x + x,
                    y: vertex.coordinate.y + y
                ),
                value: grid[vertex.coordinate.x + x][vertex.coordinate.y + y]
            )

            result.append(
                Edge(source: source, destination: destination, weight: weight(source, destination))
            )
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
