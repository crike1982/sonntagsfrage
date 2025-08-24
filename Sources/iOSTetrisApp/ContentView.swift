#if canImport(SwiftUI)
import SwiftUI
import TetrisCore

struct ContentView: View {
    @State private var game = Game()
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 1) {
            ForEach(0..<game.height, id: \.self) { y in
                HStack(spacing: 1) {
                    ForEach(0..<game.width, id: \.self) { x in
                        Rectangle()
                            .fill(colorAt(x: x, y: y))
                            .frame(width: 15, height: 15)
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .onReceive(timer) { _ in game.tick() }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if abs(value.translation.width) > abs(value.translation.height) {
                        if value.translation.width > 0 { game.move(dx: 1, dy: 0) }
                        else { game.move(dx: -1, dy: 0) }
                    } else if value.translation.height > 0 {
                        game.move(dx: 0, dy: 1)
                    } else {
                        game.rotate()
                    }
                }
        )
    }

    func colorAt(x: Int, y: Int) -> Color {
        var grid = game.board
        for b in game.current.blocks {
            if b.x >= 0 && b.x < game.width && b.y >= 0 && b.y < game.height {
                grid[b.y][b.x] = game.current.type
            }
        }
        return grid[y][x] == nil ? Color.gray.opacity(0.2) : Color.blue
    }
}
#endif
