// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppleMusicController",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "AppleMusicController",
            targets: ["AppleMusicController"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AppleMusicController",
            dependencies: ["KeyboardShortcuts"],
            path: "Sources"
        )
    ]
)
