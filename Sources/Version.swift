import Foundation

enum AppVersion {
    static let current = "1.0.0"
    static let build = "1"

    static var fullVersion: String {
        "\(current) (\(build))"
    }

    static var displayVersion: String {
        "v\(current)"
    }
}
