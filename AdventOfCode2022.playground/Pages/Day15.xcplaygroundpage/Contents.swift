import Foundation

extension Day15 {

    struct Coordinate: Hashable {
        let column: Int
        let row: Int

        init(_ data: String) {
            let components = data.components(separatedBy: ", ")

            self.init(
                column: Int(components.first!.replacingOccurrences(of: "x=", with: ""))!,
                row: Int(components.last!.replacingOccurrences(of: "y=", with: ""))!
            )
        }

        init(column: Int, row: Int) {
            self.column = column
            self.row = row
        }
    }

    struct Beacon {
        let position: Coordinate
    }

    struct Sensor {
        let beacon: Beacon
        let position: Coordinate

        init(beacon: Beacon, position: Coordinate) {
            self.beacon = beacon
            self.position = position
        }

        func noBeaconPositions(for row: Int) -> ClosedRange<Int>? {
            let distance = abs(position.column - beacon.position.column)
                + abs(position.row - beacon.position.row)
            let rowRange = distance - abs(row - position.row)
            return rowRange <= 0 ? nil : (position.column - rowRange...position.column + rowRange)
        }
    }

    static func positionsThatCannotContainBeacon(_ row: Int = 10) -> Int {
        let sensors = Day15.data
            .components(separatedBy: .newlines)
            .map { line in
                let components = line.components(separatedBy: ": ")
                let beacon = Beacon(
                    position: Coordinate(
                        components.last!.replacingOccurrences(of: "closest beacon is at ", with: "")
                    )
                )
                return Sensor(
                    beacon: beacon,
                    position: Coordinate(
                        components.first!.replacingOccurrences(of: "Sensor at ", with: "")
                    )
                )
            }

        let noBeaconRanges = sensors
            .compactMap{ $0.noBeaconPositions(for: row) }
            .flatMap { $0 }

        let beacons = sensors
            .map { $0.beacon.position }
            .filter { $0.row == row }
            .compactMap { $0.row }

        var coverage = Set<Int>()
        coverage.formUnion(noBeaconRanges)

        return coverage.count - coverage.intersection(beacons).count
    }

}

print(Day15.positionsThatCannotContainBeacon(2000000))
