import SwiftUI

struct ABMarkerView: View {
    @Bindable var markerState: ABMarkerState

    @State private var markerAComponents: TimeComponents = TimeComponents()
    @State private var markerBComponents: TimeComponents = TimeComponents()

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Text("A-B Loop Markers")
                    .font(.headline)

                HStack(spacing: 16) {
                    // Marker A
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Marker A")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TimeInputView(
                            components: $markerAComponents,
                            isEnabled: markerState.markerA != nil,
                            onUpdate: { newTime in
                                markerState.setMarkerA(newTime)
                            }
                        )
                    }

                    // Marker B
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Marker B")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TimeInputView(
                            components: $markerBComponents,
                            isEnabled: markerState.markerB != nil,
                            onUpdate: { newTime in
                                markerState.setMarkerB(newTime)
                            }
                        )
                    }
                }

                Divider()

                HStack {
                    Toggle("Loop Active", isOn: Binding(
                        get: { markerState.isLooping },
                        set: { _ in markerState.toggleLoop() }
                    ))
                    .disabled(!markerState.hasMarkers)

                    Spacer()

                    Button("Clear Markers") {
                        markerState.clearMarkers()
                        markerAComponents = TimeComponents()
                        markerBComponents = TimeComponents()
                    }
                    .disabled(!markerState.hasMarkers)
                }

                if !markerState.hasMarkers {
                    Text("Press your assigned hotkeys to set markers A and B")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(8)
        }
        .onChange(of: markerState.markerA) { _, newValue in
            if let value = newValue {
                markerAComponents = TimeComponents(fromTotalSeconds: value)
            }
        }
        .onChange(of: markerState.markerB) { _, newValue in
            if let value = newValue {
                markerBComponents = TimeComponents(fromTotalSeconds: value)
            }
        }
    }
}

struct TimeInputView: View {
    @Binding var components: TimeComponents
    let isEnabled: Bool
    let onUpdate: (Double) -> Void

    var body: some View {
        HStack(spacing: 4) {
            // Minutes
            VStack(spacing: 0) {
                Button(action: { incrementMinutes() }) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 8))
                }
                .buttonStyle(.borderless)
                .disabled(!isEnabled)

                TextField("00", value: $components.minutes, format: .number)
                    .frame(width: 30)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!isEnabled)
                    .onChange(of: components.minutes) { _, _ in
                        updateTime()
                    }

                Button(action: { decrementMinutes() }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8))
                }
                .buttonStyle(.borderless)
                .disabled(!isEnabled)
            }

            Text(":")

            // Seconds
            VStack(spacing: 0) {
                Button(action: { incrementSeconds() }) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 8))
                }
                .buttonStyle(.borderless)
                .disabled(!isEnabled)

                TextField("00", value: $components.seconds, format: .number)
                    .frame(width: 30)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!isEnabled)
                    .onChange(of: components.seconds) { _, _ in
                        updateTime()
                    }

                Button(action: { decrementSeconds() }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8))
                }
                .buttonStyle(.borderless)
                .disabled(!isEnabled)
            }

            Text(".")

            // Centiseconds
            VStack(spacing: 0) {
                Button(action: { incrementCentiseconds() }) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 8))
                }
                .buttonStyle(.borderless)
                .disabled(!isEnabled)

                TextField("00", value: $components.centiseconds, format: .number)
                    .frame(width: 30)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .disabled(!isEnabled)
                    .onChange(of: components.centiseconds) { _, _ in
                        updateTime()
                    }

                Button(action: { decrementCentiseconds() }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 8))
                }
                .buttonStyle(.borderless)
                .disabled(!isEnabled)
            }

            if !isEnabled {
                Text("--:--:--")
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .font(.system(.body, design: .monospaced))
    }

    private func updateTime() {
        // Clamp values
        components.centiseconds = max(0, min(99, components.centiseconds))
        components.seconds = max(0, min(59, components.seconds))
        components.minutes = max(0, components.minutes)

        onUpdate(components.totalSeconds)
    }

    // Increment/Decrement functions
    private func incrementMinutes() {
        components.minutes += 1
        updateTime()
    }

    private func decrementMinutes() {
        components.minutes = max(0, components.minutes - 1)
        updateTime()
    }

    private func incrementSeconds() {
        components.seconds += 1
        if components.seconds > 59 {
            components.seconds = 0
            components.minutes += 1
        }
        updateTime()
    }

    private func decrementSeconds() {
        components.seconds -= 1
        if components.seconds < 0 {
            components.seconds = 59
            components.minutes = max(0, components.minutes - 1)
        }
        updateTime()
    }

    private func incrementCentiseconds() {
        components.centiseconds += 1
        if components.centiseconds > 99 {
            components.centiseconds = 0
            incrementSeconds()
        } else {
            updateTime()
        }
    }

    private func decrementCentiseconds() {
        components.centiseconds -= 1
        if components.centiseconds < 0 {
            components.centiseconds = 99
            decrementSeconds()
        } else {
            updateTime()
        }
    }
}
