import SwiftUI

struct ToolbarView: View {
    @Bindable var viewModel: CanvasViewModel
    let isKidMode: Bool

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ForEach(DrawingTool.allCases) { tool in
                    ToolButton(
                        tool: tool,
                        isSelected: viewModel.currentTool == tool && tool != .clear,
                        action: { viewModel.selectTool(tool) }
                    )
                }

                if !isKidMode {
                    Divider()
                        .frame(height: 36)

                    Button {
                        viewModel.showTextTool = true
                    } label: {
                        VStack(spacing: 4) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.6, green: 0.5, blue: 0.8).opacity(0.15))
                                    .frame(width: 48, height: 48)
                                Image(systemName: "textformat")
                                    .font(.title3)
                                    .foregroundStyle(Color(red: 0.6, green: 0.5, blue: 0.8))
                            }
                            Text("Text")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if isKidMode {
                    Divider()
                        .frame(height: 36)

                    Button {
                        viewModel.showStickers = true
                    } label: {
                        VStack(spacing: 4) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.purple.opacity(0.15))
                                    .frame(width: 48, height: 48)
                                Image(systemName: "star.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(.purple)
                            }
                            Text("Stamps")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            HStack(spacing: 24) {
                HStack(spacing: 8) {
                    Image(systemName: "drop.fill")
                        .font(.caption)
                        .foregroundStyle(Color(red: 0.4, green: 0.75, blue: 0.72))
                    Text("Opacity")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(value: $viewModel.brushOpacity, in: 0.1...1.0)
                        .tint(Color(red: 0.4, green: 0.75, blue: 0.72))
                        .frame(maxWidth: 140)
                        .onChange(of: viewModel.brushOpacity) { _, _ in
                            viewModel.updateCanvasTool()
                        }
                }

                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundStyle(Color(red: 0.4, green: 0.75, blue: 0.72))
                    Text("Size")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Slider(value: $viewModel.brushSize, in: 1...40)
                        .tint(Color(red: 0.4, green: 0.75, blue: 0.72))
                        .frame(maxWidth: 140)
                        .onChange(of: viewModel.brushSize) { _, _ in
                            viewModel.updateCanvasTool()
                        }
                }
            }
            .padding(.horizontal, 8)

            ColorPaletteView(viewModel: viewModel)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.08), radius: 12, y: -4)
        )
    }
}

struct ToolButton: View {
    let tool: DrawingTool
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? tool.iconColor.opacity(0.25) : tool.iconColor.opacity(0.1))
                        .frame(width: 48, height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(isSelected ? tool.iconColor : .clear, lineWidth: 2)
                        )
                    Image(systemName: tool.icon)
                        .font(.title3)
                        .foregroundStyle(tool.iconColor)
                        .symbolEffect(.bounce, value: isSelected)
                }
                Text(tool.label)
                    .font(.caption2)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
