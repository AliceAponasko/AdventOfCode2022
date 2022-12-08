import Foundation

extension Day6 {

    static func decodeMessage(size: Int = 4) -> Int {
        var queue = Queue(maxSize: size)

        for iterator in Day6.data.enumerated() {
            queue.enqueue(String(iterator.element))
            if queue.size == size, queue.isUnique {
                return iterator.offset + 1
            }
        }

        fatalError("No unique markers found!")
    }

}

print(Day6.decodeMessage())
print(Day6.decodeMessage(size: 14))
