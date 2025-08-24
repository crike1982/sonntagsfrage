// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "TetrisGame",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "TetrisCore", targets: ["TetrisCore"]),
        .executable(name: "ConsoleTetris", targets: ["ConsoleTetris"]),
        .executable(name: "TetrisApp", targets: ["iOSTetrisApp"])
    ],
    targets: [
        .target(name: "TetrisCore"),
        .executableTarget(
            name: "ConsoleTetris",
            dependencies: ["TetrisCore"]
        ),
        .executableTarget(
            name: "iOSTetrisApp",
            dependencies: ["TetrisCore"],
            path: "Sources/iOSTetrisApp"
        )
    ]
)
