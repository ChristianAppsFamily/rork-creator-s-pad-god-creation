import SwiftUI

nonisolated enum AppearanceMode: String, CaseIterable, Sendable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

nonisolated enum PencilDoubleTapAction: String, CaseIterable, Sendable {
    case switchEraser = "Switch to Eraser"
    case undo = "Undo"
    case colorPicker = "Color Picker"
    case none = "None"
}
