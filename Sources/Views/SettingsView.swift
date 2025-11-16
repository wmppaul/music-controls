import SwiftUI

struct SettingsView: View {
    @Bindable var hotkeyManager: HotkeyManager

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack {
                Image(systemName: "music.note")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Apple Music Controller")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Control Apple Music playback with keyboard shortcuts")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .opacity(0.7)
                }
            }
            .padding(.bottom, 4)

            Divider()

            // Hotkey Configuration Table
            HotkeyTableView(hotkeyManager: hotkeyManager)

            Divider()

            // A-B Marker Controls
            ABMarkerView(markerState: hotkeyManager.abMarkerState)

            Spacer()

            // Footer info
            HStack {
                Image(systemName: "info.circle")
                    .foregroundStyle(.secondary)
                Text("Shortcuts work globally when Music is playing")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .frame(width: 600, height: 550)
    }
}
