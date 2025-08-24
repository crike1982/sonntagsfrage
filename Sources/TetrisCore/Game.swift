import Foundation

public struct Point: Hashable, Sendable {
    public var x: Int
    public var y: Int
}

public enum TetrominoType: CaseIterable, Sendable {
    case I, O, T, S, Z, J, L
}

private let shapes: [TetrominoType: [[Point]]] = [
    .I: [
        [Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 2, y: 0)],
        [Point(x: 1, y: -1), Point(x: 1, y: 0), Point(x: 1, y: 1), Point(x: 1, y: 2)],
        [Point(x: -1, y: 1), Point(x: 0, y: 1), Point(x: 1, y: 1), Point(x: 2, y: 1)],
        [Point(x: 0, y: -1), Point(x: 0, y: 0), Point(x: 0, y: 1), Point(x: 0, y: 2)]
    ],
    .O: [
        [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1)]
    ],
    .T: [
        [Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1)],
        [Point(x: 0, y: -1), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1)],
        [Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: -1)],
        [Point(x: 0, y: -1), Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 0, y: 1)]
    ],
    .S: [
        [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: -1, y: 1), Point(x: 0, y: 1)],
        [Point(x: 0, y: -1), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 1, y: 1)],
        [Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: -1, y: 1), Point(x: 0, y: 1)],
        [Point(x: 0, y: -1), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 1, y: 1)]
    ],
    .Z: [
        [Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1)],
        [Point(x: 1, y: -1), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1)],
        [Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1)],
        [Point(x: 1, y: -1), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 0, y: 1)]
    ],
    .J: [
        [Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: -1, y: 1)],
        [Point(x: 0, y: -1), Point(x: 0, y: 0), Point(x: 0, y: 1), Point(x: 1, y: -1)],
        [Point(x: 1, y: -1), Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 1, y: 0)],
        [Point(x: -1, y: 1), Point(x: 0, y: -1), Point(x: 0, y: 0), Point(x: 0, y: 1)]
    ],
    .L: [
        [Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 1, y: 0), Point(x: 1, y: 1)],
        [Point(x: 0, y: -1), Point(x: 0, y: 0), Point(x: 0, y: 1), Point(x: 1, y: 1)],
        [Point(x: -1, y: -1), Point(x: -1, y: 0), Point(x: 0, y: 0), Point(x: 1, y: 0)],
        [Point(x: -1, y: -1), Point(x: 0, y: -1), Point(x: 0, y: 0), Point(x: 0, y: 1)]
    ]
]

public struct Tetromino {
    public var type: TetrominoType
    public var rotation: Int
    public var position: Point

    public var blocks: [Point] {
        let shape = shapes[type]!
        let rot = shape[rotation % shape.count]
        return rot.map { Point(x: $0.x + position.x, y: $0.y + position.y) }
    }
}

public struct Game {
    public let width = 10
    public let height = 20
    public var board: [[TetrominoType?]]
    public var current: Tetromino

    public init() {
        board = Array(repeating: Array(repeating: nil, count: width), count: height)
        current = Tetromino(type: TetrominoType.allCases.randomElement()!, rotation: 0, position: Point(x: width/2, y: 0))
    }

    public mutating func spawn() {
        current = Tetromino(type: TetrominoType.allCases.randomElement()!, rotation: 0, position: Point(x: width/2, y: 0))
    }

    func isValid(_ piece: Tetromino) -> Bool {
        for b in piece.blocks {
            if b.x < 0 || b.x >= width || b.y < 0 || b.y >= height { return false }
            if board[b.y][b.x] != nil { return false }
        }
        return true
    }

    public mutating func move(dx: Int, dy: Int) {
        var p = current
        p.position = Point(x: p.position.x + dx, y: p.position.y + dy)
        if isValid(p) {
            current = p
        } else if dy > 0 {
            lockPiece()
        }
    }

    public mutating func rotate() {
        var p = current
        p.rotation = (p.rotation + 1) % 4
        if isValid(p) {
            current = p
        }
    }

    mutating func lockPiece() {
        for b in current.blocks {
            board[b.y][b.x] = current.type
        }
        clearLines()
        spawn()
    }

    mutating func clearLines() {
        board = board.filter { row in row.contains(where: { $0 == nil }) }
        let cleared = height - board.count
        if cleared > 0 {
            let empty = Array(repeating: Array(repeating: TetrominoType?.none, count: width), count: cleared)
            board = empty + board
        }
    }

    public mutating func tick() {
        move(dx: 0, dy: 1)
    }

    public func render() -> String {
        var grid = board
        for b in current.blocks {
            if b.y >= 0 && b.y < height && b.x >= 0 && b.x < width {
                grid[b.y][b.x] = current.type
            }
        }
        return grid.map { row in
            row.map { $0 == nil ? "." : "#" }.joined()
        }.joined(separator: "\n")
    }
}
