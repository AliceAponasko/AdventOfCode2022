import Foundation

public class Graph {

    public struct Coordinate: Hashable {
        public let line: Int
        public let column: Int

        public init(line: Int, column: Int) {
            self.line = line
            self.column = column
        }
    }

    public struct Vertex: Equatable, Hashable {
        public let coordinate: Coordinate
        public let value: Character

        public init(coordinate: Coordinate, value: Character) {
            self.coordinate = coordinate
            self.value = value
        }
    }

    public struct Edge: Equatable, Hashable {
        public let source: Vertex
        public let destination: Vertex
        public let weight: Int

        public init(
            source: Vertex,
            destination: Vertex,
            weight: Int
        ) {
            self.source = source
            self.destination = destination
            self.weight = weight
        }
    }

    public enum Visit {
        case source
        case edge(Edge)
    }

    private var map = [Vertex: [Edge]]()

    public init() {}

    public func createVertex(_ coordinate: Coordinate, _ value: Character) -> Vertex {
        let vertex = Vertex(coordinate: coordinate, value: value)

        if !map.keys.contains(vertex) {
            map[vertex] = []
        }

        return vertex
    }

    public func addEdge(from source: Vertex, to destination: Vertex, weight: Int) {
        map[source, default: []].append(
            Edge(source: source, destination: destination, weight: weight)
        )
    }

    public func addEdges(_ edges: [Edge], for source: Vertex) {
        map[source, default: []].append(contentsOf: edges)
    }

    public func edges(for source: Vertex) -> [Edge]? {
        map[source]
    }

    public func breadthFirstSearch(from source: Vertex, to destination: Vertex) -> [Edge] {
        var queueArray = [source]
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

        return []
    }
    
}
