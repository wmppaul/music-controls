import Foundation

@Observable
class ABMarkerState {
    var markerA: Double?
    var markerB: Double?
    var isLooping: Bool = false

    var hasMarkers: Bool {
        markerA != nil && markerB != nil
    }

    var loopStart: Double? {
        guard let a = markerA, let b = markerB else { return nil }
        return min(a, b)
    }

    var loopEnd: Double? {
        guard let a = markerA, let b = markerB else { return nil }
        return max(a, b)
    }

    func setMarkerA(_ position: Double) {
        markerA = position
    }

    func setMarkerB(_ position: Double) {
        markerB = position
    }

    func toggleLoop() {
        guard hasMarkers else { return }
        isLooping.toggle()
    }

    func clearMarkers() {
        markerA = nil
        markerB = nil
        isLooping = false
    }

    func shouldLoopBack(currentPosition: Double) -> Bool {
        guard isLooping, let end = loopEnd, let start = loopStart else {
            return false
        }
        return currentPosition >= end
    }
}

struct TimeComponents {
    var minutes: Int
    var seconds: Int
    var centiseconds: Int

    init(fromTotalSeconds seconds: Double) {
        let totalCentiseconds = Int(seconds * 100)
        self.centiseconds = totalCentiseconds % 100
        let totalSeconds = totalCentiseconds / 100
        self.seconds = totalSeconds % 60
        self.minutes = totalSeconds / 60
    }

    init(minutes: Int = 0, seconds: Int = 0, centiseconds: Int = 0) {
        self.minutes = minutes
        self.seconds = seconds
        self.centiseconds = centiseconds
    }

    var totalSeconds: Double {
        Double(minutes * 60 + seconds) + Double(centiseconds) / 100.0
    }

    var formattedString: String {
        String(format: "%02d:%02d.%02d", minutes, seconds, centiseconds)
    }
}
