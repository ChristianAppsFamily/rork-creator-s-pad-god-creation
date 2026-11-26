import SwiftUI

struct ColorPaletteView: View {
    @Bindable var viewModel: CanvasViewModel
    @Environment(StoreService.self) private var storeService
    @State private var showUpgrade: Bool = false

    private var allColors: [DrawingColor] {
        DrawingColor.palette + PremiumContent.extraColors
    }

    private var premiumColorIDs: Set<String> {
        Set(PremiumContent.extraColors.map(\.id))
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(allColors) { drawingColor in
                    let isLocked = premiumColorIDs.contains(drawingColor.id) && !storeService.hasPremium
                    Button {
                        if isLocked {
                            showUpgrade = true
                        } else {
                            viewModel.selectColor(drawingColor)
                        }
                    } label: {
                        ZStack(alignment: .bottomTrailing) {
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
                                .opacity(isLocked ? 0.55 : 1)
                                .shadow(
                                    color: viewModel.selectedColor.id == drawingColor.id
                                        ? Color(red: 0.4, green: 0.75, blue: 0.72).opacity(0.4)
                                        : .clear,
                                    radius: 4
                                )
                                .scaleEffect(viewModel.selectedColor.id == drawingColor.id ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3), value: viewModel.selectedColor.id == drawingColor.id)

                            if isLocked {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(4)
                                    .background(Circle().fill(Color(red: 0.4, green: 0.3, blue: 0.55)))
                                    .offset(x: 4, y: 4)
                            }
                        }
                    }
                    .accessibilityLabel(isLocked ? "\(drawingColor.name), Premium" : drawingColor.name)
                }
            }
            .contentMargins(.horizontal, 4)
        }
        .sheet(isPresented: $showUpgrade) {
            UpgradeView(context: .premiumColors, storeService: storeService)
        }
    }
}
