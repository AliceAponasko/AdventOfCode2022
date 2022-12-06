import Foundation

public extension String {

    subscript(at offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }

    subscript(to end: Int) -> String {
        String(self[..<index(startIndex, offsetBy: end)])
    }

    subscript(from start: Int) -> String {
        String(self[index(startIndex, offsetBy: start)...])
    }

}
