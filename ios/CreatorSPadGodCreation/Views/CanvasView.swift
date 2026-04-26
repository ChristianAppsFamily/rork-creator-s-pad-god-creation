import SwiftUI
import PencilKit

struct CanvasView: View {
    @Bindable var viewModel: CanvasViewModel
    @Environment(SettingsViewModel.self) private var settingsVM
    @Environment(StoreService.self) private var storeService
    @Environment(\.colorScheme) private var colorScheme
    @State private var pkCanvasView = PKCanvasView()
    @State private var textOverlays: [TextOverlay] = []
    @State private var stickerOverlays: [StickerOverlay] = []
    @State private var showSettings: Bool = false
    @State private var showColoringPages: Bool = false
    @State private var showUpgrade: Bool = false

    private var canvasBackground: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : .white
    }

    private var scriptureTextColor: Color {
        colorScheme == .dark ? Color(red: 1.0, green: 0.97, blue: 0.88) : Color(red: 0.35, green: 0.25, blue: 0.5)
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar

            ZStack {
                canvasBackground
                if let page = viewModel.currentColoringPage {
                    ColoringPageTemplateView(page: page)
                        .padding(24)
                } else {
                    DotGridBackground()
                }
                DrawingCanvasRepresentable(
                    canvasView: pkCanvasView,
                    tool: viewModel.pkTool,
                    onDrawingChanged: {}
                )

                ForEach($textOverlays) { $overlay in
                    DraggableTextView(overlay: $overlay) {
                        textOverlays.removeAll { $0.id == overlay.id }
                    }
                }

                ForEach($stickerOverlays) { $overlay in
                    DraggableStickerView(overlay: $overlay) {
                        stickerOverlays.removeAll { $0.id == overlay.id }
                    }
                }
            }
            .clipShape(.rect)

            ToolbarView(viewModel: viewModel, isKidMode: viewModel.isKidMode)

            if !storeService.hasRemovedAds {
                AdBannerView()
            }
        }
        .background(Color(.systemBackground))
        .onAppear {
            viewModel.canvasView = pkCanvasView
            viewModel.updateCanvasTool()
        }
        .sheet(isPresented: $viewModel.showVersePicker) {
            VersePickerView(selectedVerse: $viewModel.currentVerse, hasPremium: storeService.hasPremium)
        }
        .sheet(isPresented: $viewModel.showGallery) {
            GalleryView(
                onSelect: { artwork in viewModel.loadArtwork(artwork) },
                onNew: { viewModel.newArtwork() }
            )
        }
        .sheet(isPresented: $showColoringPages) {
            ColoringPageLibraryView(hasPremium: storeService.hasPremium) { page in
                viewModel.startColoringPage(page)
            } onUpgradeRequested: {
                showColoringPages = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showUpgrade = true
                }
            }
        }
        .sheet(isPresented: $viewModel.showTextTool) {
            TextToolView(hasPremium: storeService.hasPremium) { text, fontName in
                let overlay = TextOverlay(text: text, fontName: fontName)
                textOverlays.append(overlay)
            }
        }
        .sheet(isPresented: $viewModel.showStickers) {
            KidModeStickerView { symbol in
                let overlay = StickerOverlay(symbolName: symbol)
                stickerOverlays.append(overlay)
            }
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            if let image = viewModel.exportImage {
                ShareSheetView(items: [image])
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(settingsVM: settingsVM, storeService: storeService)
        }
        .sheet(isPresented: $showUpgrade) {
            UpgradeView(storeService: storeService)
        }
        .alert("Clear Canvas?", isPresented: $viewModel.showClearConfirmation) {
            Button("Clear", role: .destructive) { viewModel.clearCanvas() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will erase your entire drawing. This cannot be undone.")
        }
    }

    private var headerBar: some View {
        HStack {
            Button {
                viewModel.showGallery = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.subheadline)
                    Text("Gallery")
                        .font(.subheadline.weight(.medium))
                }
                .foregroundStyle(Color(red: 1.0, green: 0.47, blue: 0.42))
            }

            Button {
                showColoringPages = true
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .font(.subheadline)
                    Text("Pages")
                        .font(.subheadline.weight(.medium))
                }
                .foregroundStyle(Color(red: 0.4, green: 0.75, blue: 0.72))
            }

            Spacer()

            Button {
                if !viewModel.isKidMode {
                    viewModel.showVersePicker = true
                }
            } label: {
                VStack(spacing: 1) {
                    Text(viewModel.currentVerse.reference)
                        .font(.system(.headline, design: .serif, weight: .bold))
                        .foregroundStyle(scriptureTextColor)
                    Text(viewModel.currentVerse.text)
                        .font(.system(.caption2, design: .serif))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .disabled(viewModel.isKidMode)

            Spacer()

            HStack(spacing: 12) {
                Button {
                    viewModel.isKidMode.toggle()
                } label: {
                    Image(systemName: "figure.child")
                        .font(.subheadline)
                        .foregroundStyle(viewModel.isKidMode ? .orange : .secondary)
                        .symbolEffect(.bounce, value: viewModel.isKidMode)
                }

                Button {
                    viewModel.saveArtwork()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0.4, green: 0.72, blue: 0.9))
                }

                Button {
                    viewModel.prepareShareImage()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0.4, green: 0.75, blue: 0.72))
                }

                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.47, blue: 0.42).opacity(0.08),
                    Color(red: 1.0, green: 0.85, blue: 0.25).opacity(0.06),
                    Color(red: 0.45, green: 0.82, blue: 0.35).opacity(0.06),
                    Color(red: 0.4, green: 0.72, blue: 0.9).opacity(0.08),
                    Color(red: 0.6, green: 0.5, blue: 0.8).opacity(0.08)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }
}

struct TextOverlay: Identifiable {
    let id = UUID()
    var text: String
    var fontName: String
    var position: CGSize = .zero
    var scale: CGFloat = 1.0
}

struct StickerOverlay: Identifiable {
    let id = UUID()
    var symbolName: String
    var position: CGSize = .zero
    var scale: CGFloat = 1.0
}

struct DraggableTextView: View {
    @Binding var overlay: TextOverlay
    let onDelete: () -> Void
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        Text(overlay.text)
            .font(.custom(overlay.fontName, size: 24 * overlay.scale))
            .foregroundStyle(.primary)
            .padding(8)
            .background(Color.white.opacity(0.6))
            .clipShape(.rect(cornerRadius: 6))
            .offset(x: overlay.position.width + dragOffset.width,
                    y: overlay.position.height + dragOffset.height)
            .scaleEffect(overlay.scale)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        overlay.position.width += value.translation.width
                        overlay.position.height += value.translation.height
                        dragOffset = .zero
                    }
            )
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        overlay.scale = max(0.5, min(3.0, value.magnification))
                    }
            )
            .contextMenu {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    onDelete()
                }
            }
    }
}

struct DraggableStickerView: View {
    @Binding var overlay: StickerOverlay
    let onDelete: () -> Void
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        Image(systemName: overlay.symbolName)
            .font(.system(size: 44 * overlay.scale))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.85, green: 0.45, blue: 0.55),
                        Color(red: 0.55, green: 0.45, blue: 0.85)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .offset(x: overlay.position.width + dragOffset.width,
                    y: overlay.position.height + dragOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        overlay.position.width += value.translation.width
                        overlay.position.height += value.translation.height
                        dragOffset = .zero
                    }
            )
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        overlay.scale = max(0.5, min(3.0, value.magnification))
                    }
            )
            .contextMenu {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    onDelete()
                }
            }
    }
}
