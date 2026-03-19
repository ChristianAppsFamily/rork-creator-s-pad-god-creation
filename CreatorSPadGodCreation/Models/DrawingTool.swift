import SwiftUI
import PencilKit

nonisolated enum DrawingTool: String, CaseIterable, Identifiable, Sendable {
    case calligraphy
    case pencil
    case watercolor
    case eraser
    case clear

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .calligraphy: return "paintbrush.pointed.fill"
        case .pencil: return "pencil"
        case .watercolor: return "paintbrush.fill"
        case .eraser: return "eraser.fill"
        case .clear: return "trash.fill"
        }
    }

    var label: String {
        switch self {
        case .calligraphy: return "Quill"
        case .pencil: return "Pencil"
        case .watercolor: return "Paint"
        case .eraser: return "Eraser"
        case .clear: return "Clear"
        }
    }

    var iconColor: Color {
        switch self {
        case .calligraphy: return Color(red: 0.85, green: 0.45, blue: 0.55)
        case .pencil: return Color(red: 0.95, green: 0.82, blue: 0.3)
        case .watercolor: return Color(red: 0.55, green: 0.75, blue: 0.9)
        case .eraser: return Color(red: 0.75, green: 0.75, blue: 0.8)
        case .clear: return Color(red: 0.9, green: 0.5, blue: 0.45)
        }
    }
}

nonisolated struct DrawingColor: Identifiable, Hashable, Sendable {
    let id: String
    let color: Color
    let uiColor: UIColor
    let name: String

    nonisolated static let palette: [DrawingColor] = [
        DrawingColor(id: "black", color: .black, uiColor: .black, name: "Black"),
        DrawingColor(id: "coral", color: Color(red: 1.0, green: 0.47, blue: 0.42), uiColor: UIColor(red: 1.0, green: 0.47, blue: 0.42, alpha: 1), name: "Coral"),
        DrawingColor(id: "lime", color: Color(red: 0.45, green: 0.82, blue: 0.35), uiColor: UIColor(red: 0.45, green: 0.82, blue: 0.35, alpha: 1), name: "Lime"),
        DrawingColor(id: "white", color: .white, uiColor: .white, name: "White"),
        DrawingColor(id: "blue", color: Color(red: 0.25, green: 0.42, blue: 0.88), uiColor: UIColor(red: 0.25, green: 0.42, blue: 0.88, alpha: 1), name: "Blue"),
        DrawingColor(id: "yellow", color: Color(red: 1.0, green: 0.85, blue: 0.25), uiColor: UIColor(red: 1.0, green: 0.85, blue: 0.25, alpha: 1), name: "Yellow"),
    ]
}
