import Foundation
import AppKit

enum MusicControllerError: Error {
    case scriptExecutionFailed
    case noTrackPlaying
    case invalidPosition
}

class MusicController {
    static let shared = MusicController()

    private init() {}

    /// Get the current player position in seconds
    func getPlayerPosition() -> Double? {
        let script = """
        tell application "Music"
            return player position
        end tell
        """

        guard let result = executeAppleScript(script),
              let position = Double(result) else {
            return nil
        }
        return position
    }

    /// Set the player position in seconds
    func setPlayerPosition(_ position: Double) -> Bool {
        let script = """
        tell application "Music"
            set player position to \(position)
        end tell
        """

        return executeAppleScript(script) != nil
    }

    /// Seek forward or backward by a given number of seconds
    func seek(bySeconds seconds: Double) -> Bool {
        guard let currentPosition = getPlayerPosition() else {
            return false
        }

        let newPosition = max(0, currentPosition + seconds)
        return setPlayerPosition(newPosition)
    }

    /// Check if Music app is running and playing
    func isPlaying() -> Bool {
        let script = """
        tell application "Music"
            return player state is playing
        end tell
        """

        guard let result = executeAppleScript(script) else {
            return false
        }
        return result == "true"
    }

    /// Get the duration of the current track
    func getCurrentTrackDuration() -> Double? {
        let script = """
        tell application "Music"
            return duration of current track
        end tell
        """

        guard let result = executeAppleScript(script),
              let duration = Double(result) else {
            return nil
        }
        return duration
    }

    // MARK: - Private Helpers

    private func executeAppleScript(_ script: String) -> String? {
        var error: NSDictionary?
        let appleScript = NSAppleScript(source: script)

        let output = appleScript?.executeAndReturnError(&error)

        if let error = error {
            print("AppleScript Error: \(error)")
            return nil
        }

        return output?.stringValue
    }
}
