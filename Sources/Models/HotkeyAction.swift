import Foundation
import KeyboardShortcuts

enum ActionType: String, CaseIterable {
    case rewind = "Rewind"
    case forward = "Forward"
    case setMarkerA = "Set Marker A"
    case setMarkerB = "Set Marker B"
    case toggleABLoop = "Toggle A-B Loop"
    case clearMarkers = "Clear Markers"

    var isSeekAction: Bool {
        switch self {
        case .rewind, .forward:
            return true
        default:
            return false
        }
    }

    var supportsValue: Bool {
        return isSeekAction
    }
}

struct HotkeyAction: Identifiable {
    let id: UUID
    let shortcutName: KeyboardShortcuts.Name
    let action: ActionType
    var value: Double // For seek actions, this is the number of seconds

    init(id: UUID = UUID(), shortcutName: KeyboardShortcuts.Name, action: ActionType, value: Double = 5.0) {
        self.id = id
        self.shortcutName = shortcutName
        self.action = action
        self.value = value
    }

    var timeOffset: Double {
        switch action {
        case .rewind:
            return -value
        case .forward:
            return value
        default:
            return 0.0
        }
    }
}
