#if canImport(SwiftUI)
import SwiftUI
import TetrisCore

@main
struct TetrisApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
#else
@main
struct TetrisApp {
    static func main() {
        print("TetrisApp is only available on iOS.")
    }
}
#endif
