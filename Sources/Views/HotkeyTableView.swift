import SwiftUI
import KeyboardShortcuts

struct HotkeyTableView: View {
    @Bindable var hotkeyManager: HotkeyManager

    @State private var selectedHotkeyID: UUID?
    @State private var showingActionPicker = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Keyboard Shortcuts")
                .font(.headline)

            Table(of: HotkeyAction.self, selection: $selectedHotkeyID) {
                TableColumn("Keystroke") { hotkey in
                    HStack {
                        KeyboardShortcuts.Recorder(for: hotkey.shortcutName) {
                            EmptyView()
                        }
                        .labelsHidden()
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(hotkeyManager.lastTriggeredHotkeyID == hotkey.id ? Color.blue.opacity(0.4) : Color.clear)
                            .animation(.easeInOut(duration: 0.3), value: hotkeyManager.lastTriggeredHotkeyID)
                    )
                }
                .width(min: 120, max: 150)

                TableColumn("Action") { hotkey in
                    HStack {
                        Text(hotkey.action.rawValue)
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(hotkeyManager.lastTriggeredHotkeyID == hotkey.id ? Color.blue.opacity(0.4) : Color.clear)
                            .animation(.easeInOut(duration: 0.3), value: hotkeyManager.lastTriggeredHotkeyID)
                    )
                }
                .width(min: 100, max: 150)

                TableColumn("Value") { hotkey in
                    HStack {
                        if hotkey.action.supportsValue {
                            HStack(spacing: 4) {
                                TextField("", value: Binding(
                                    get: { hotkey.value },
                                    set: { newValue in
                                        if let index = hotkeyManager.hotkeys.firstIndex(where: { $0.id == hotkey.id }) {
                                            hotkeyManager.hotkeys[index].value = max(0.1, newValue)
                                        }
                                    }
                                ), format: .number)
                                .frame(width: 50)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.trailing)

                                Text("s")
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Text("—")
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(hotkeyManager.lastTriggeredHotkeyID == hotkey.id ? Color.blue.opacity(0.4) : Color.clear)
                            .animation(.easeInOut(duration: 0.3), value: hotkeyManager.lastTriggeredHotkeyID)
                    )
                }
                .width(min: 80, max: 100)
            } rows: {
                ForEach(hotkeyManager.hotkeys) { hotkey in
                    TableRow(hotkey)
                }
            }
            .frame(minHeight: 200)

            HStack {
                Button(action: { showingActionPicker = true }) {
                    Label("Add", systemImage: "plus")
                }

                Button(action: removeSelectedHotkey) {
                    Label("Remove", systemImage: "minus")
                }
                .disabled(selectedHotkeyID == nil)

                Spacer()
            }
        }
        .sheet(isPresented: $showingActionPicker) {
            ActionPickerView(hotkeyManager: hotkeyManager, isPresented: $showingActionPicker)
        }
    }

    private func removeSelectedHotkey() {
        guard let selectedID = selectedHotkeyID,
              let selected = hotkeyManager.hotkeys.first(where: { $0.id == selectedID }) else { return }
        hotkeyManager.removeHotkey(selected)
        selectedHotkeyID = nil
    }
}

struct ActionPickerView: View {
    let hotkeyManager: HotkeyManager
    @Binding var isPresented: Bool

    @State private var selectedAction: ActionType = .rewind

    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Hotkey")
                .font(.headline)

            Picker("Action", selection: $selectedAction) {
                ForEach(ActionType.allCases, id: \.self) { action in
                    Text(action.rawValue).tag(action)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 200)

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Button("Add") {
                    hotkeyManager.addHotkey(action: selectedAction)
                    isPresented = false
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(width: 300, height: 150)
    }
}
