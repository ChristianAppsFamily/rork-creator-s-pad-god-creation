import SwiftUI

@Observable
@MainActor
class SettingsViewModel {
    var appearanceMode: AppearanceMode {
        get {
            AppearanceMode(rawValue: UserDefaults.standard.string(forKey: "appearanceMode") ?? "System") ?? .system
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "appearanceMode")
        }
    }

    var soundEffectsEnabled: Bool {
        get { UserDefaults.standard.object(forKey: "soundEffectsEnabled") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "soundEffectsEnabled") }
    }

    var pencilPressureSensitivity: Bool {
        get { UserDefaults.standard.object(forKey: "pencilPressureSensitivity") as? Bool ?? true }
        set { UserDefaults.standard.set(newValue, forKey: "pencilPressureSensitivity") }
    }

    var pencilDoubleTapAction: PencilDoubleTapAction {
        get {
            PencilDoubleTapAction(rawValue: UserDefaults.standard.string(forKey: "pencilDoubleTapAction") ?? "Switch to Eraser") ?? .switchEraser
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "pencilDoubleTapAction")
        }
    }

    var textSizeMultiplier: Double {
        get { UserDefaults.standard.object(forKey: "textSizeMultiplier") as? Double ?? 1.0 }
        set { UserDefaults.standard.set(newValue, forKey: "textSizeMultiplier") }
    }

    var preferredColorScheme: ColorScheme? {
        appearanceMode.colorScheme
    }
}
