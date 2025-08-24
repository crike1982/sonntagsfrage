import Foundation
import TetrisCore

var game = Game()
for _ in 0..<10 {
    print("\u{001B}[2J") // clear screen
    print(game.render())
    game.tick()
    usleep(200_000)
}
