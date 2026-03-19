import SwiftUI

struct ColorPaletteView: View {
    @Bindable var viewModel: CanvasViewModel
    @Environment(StoreService.self) private var storeService

    private var availableColors: [DrawingColor] {
        storeService.hasPremium ? DrawingColor.palette + PremiumContent.extraColors : DrawingColor.palette
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(availableColors) { drawingColor in
                    Button {
                        viewModel.selectColor(drawingColor)
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(drawingColor.color)
                            .frame(width: 34, height: 34)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(
                                        viewModel.selectedColor.id == drawingColor.id
                                            ? Color(red: 0.4, green: 0.75, blue: 0.72)
                                            : Color(.separator),
                                        lineWidth: viewModel.selectedColor.id == drawingColor.id ? 3 : 1
                                    )
                            )
                            .shadow(
                                color: viewModel.selectedColor.id == drawingColor.id
                                    ? Color(red: 0.4, green: 0.75, blue: 0.72).opacity(0.4)
                                    : .clear,
                                radius: 4
                            )
                            .scaleEffect(viewModel.selectedColor.id == drawingColor.id ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3), value: viewModel.selectedColor.id == drawingColor.id)
                    }
                    .accessibilityLabel(drawingColor.name)
                }
            }
            .contentMargins(.horizontal, 4)
        }
    }
}
