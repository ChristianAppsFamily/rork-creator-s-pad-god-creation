import SwiftUI
import PencilKit
import SwiftData

@Observable
@MainActor
class CanvasViewModel {
    var currentTool: DrawingTool = .pencil
    var selectedColor: DrawingColor = DrawingColor.palette[0]
    var brushSize: CGFloat = 5.0
    var brushOpacity: CGFloat = 1.0
    var currentVerse: ScriptureVerse = ScriptureVerse.allVerses[0]
    var showVersePicker: Bool = false
    var showShareSheet: Bool = false
    var showClearConfirmation: Bool = false
    var showTextTool: Bool = false
    var isKidMode: Bool = false
    var showGallery: Bool = false
    var showStickers: Bool = false
    var canvasScale: CGFloat = 1.0
    var currentArtwork: Artwork?
    var currentColoringPage: ColoringPage?
    var exportImage: UIImage?

    private var autoSaveTimer: Timer?
    private var modelContext: ModelContext?
    var canvasView: PKCanvasView?

    let audioService = AudioService()

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        startAutoSave()
    }

    var pkTool: PKTool {
        switch currentTool {
        case .calligraphy:
            return PKInkingTool(.pen, color: selectedColor.uiColor.withAlphaComponent(brushOpacity), width: brushSize)
        case .pencil:
            return PKInkingTool(.pencil, color: selectedColor.uiColor.withAlphaComponent(brushOpacity), width: brushSize)
        case .watercolor:
            return PKInkingTool(.watercolor, color: selectedColor.uiColor.withAlphaComponent(brushOpacity), width: brushSize * 2)
        case .eraser:
            return PKEraserTool(.bitmap, width: brushSize * 3)
        case .clear:
            return PKInkingTool(.pen, color: selectedColor.uiColor, width: brushSize)
        }
    }

    func selectTool(_ tool: DrawingTool) {
        if tool == .clear {
            showClearConfirmation = true
            return
        }
        currentTool = tool
        audioService.playTapSound()
        updateCanvasTool()
    }

    func clearCanvas() {
        canvasView?.drawing = PKDrawing()
        audioService.playClearSound()
    }

    func updateCanvasTool() {
        canvasView?.tool = pkTool
    }

    func selectColor(_ color: DrawingColor) {
        selectedColor = color
        if currentTool == .eraser {
            currentTool = .pencil
        }
        updateCanvasTool()
    }

    func saveArtwork() {
        guard let canvasView, let modelContext else { return }

        let drawing = canvasView.drawing
        let drawingData = drawing.dataRepresentation()

        let scale: CGFloat = 2.0
        let bounds = CGRect(x: 0, y: 0, width: canvasView.bounds.width, height: canvasView.bounds.height)
        let thumbnailImage = exportCurrentDrawing(withBackground: true) ?? drawing.image(from: bounds, scale: scale)
        let thumbnailData = thumbnailImage.pngData()

        if let artwork = currentArtwork {
            artwork.drawingData = drawingData
            artwork.thumbnailData = thumbnailData
            artwork.verseReference = currentVerse.reference
            artwork.verseText = currentVerse.text
            artwork.artworkKindRawValue = currentColoringPage == nil ? ArtworkKind.freeform.rawValue : ArtworkKind.coloringPage.rawValue
            artwork.coloringPageID = currentColoringPage?.id
            artwork.coloringPageTitle = currentColoringPage?.title
            artwork.updatedAt = Date()
        } else {
            let artwork = Artwork(
                verseReference: currentVerse.reference,
                verseText: currentVerse.text,
                artworkKind: currentColoringPage == nil ? .freeform : .coloringPage,
                coloringPageID: currentColoringPage?.id,
                coloringPageTitle: currentColoringPage?.title
            )
            artwork.drawingData = drawingData
            artwork.thumbnailData = thumbnailData
            modelContext.insert(artwork)
            currentArtwork = artwork
        }

        audioService.playSaveChime()
    }

    func loadArtwork(_ artwork: Artwork) {
        currentArtwork = artwork
        currentColoringPage = ColoringPage.page(withID: artwork.coloringPageID)
        if let currentColoringPage {
            currentVerse = ScriptureVerse(reference: currentColoringPage.scriptureReference, text: currentColoringPage.subtitle)
        } else {
            currentVerse = ScriptureVerse.allVerses.first(where: { $0.reference == artwork.verseReference }) ?? ScriptureVerse.allVerses[0]
        }

        if let data = artwork.drawingData, let drawing = try? PKDrawing(data: data) {
            canvasView?.drawing = drawing
        }
    }

    func newArtwork() {
        currentArtwork = nil
        currentColoringPage = nil
        currentVerse = ScriptureVerse.allVerses[0]
        canvasView?.drawing = PKDrawing()
    }

    func startColoringPage(_ page: ColoringPage) {
        currentArtwork = nil
        currentColoringPage = page
        currentVerse = ScriptureVerse(reference: page.scriptureReference, text: page.subtitle)
        canvasView?.drawing = PKDrawing()
        audioService.playTapSound()
    }

    func exportCurrentDrawing(withBackground: Bool) -> UIImage? {
        guard let canvasView else { return nil }
        let bounds = CGRect(x: 0, y: 0, width: canvasView.bounds.width, height: canvasView.bounds.height)
        let scale: CGFloat = 3.0

        if withBackground {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: bounds.width * scale, height: bounds.height * scale))
            return renderer.image { ctx in
                UIColor.white.setFill()
                ctx.fill(CGRect(origin: .zero, size: CGSize(width: bounds.width * scale, height: bounds.height * scale)))
                if let currentColoringPage {
                    drawColoringTemplate(
                        currentColoringPage,
                        in: ctx,
                        size: CGSize(width: bounds.width * scale, height: bounds.height * scale)
                    )
                } else {
                    drawDotGrid(in: ctx, size: CGSize(width: bounds.width * scale, height: bounds.height * scale))
                }
                let drawingImage = canvasView.drawing.image(from: bounds, scale: scale)
                drawingImage.draw(in: CGRect(origin: .zero, size: CGSize(width: bounds.width * scale, height: bounds.height * scale)))
            }
        } else {
            return canvasView.drawing.image(from: bounds, scale: scale)
        }
    }

    private func drawDotGrid(in ctx: UIGraphicsImageRendererContext, size: CGSize) {
        let dotSpacing: CGFloat = 30
        let dotRadius: CGFloat = 1.5
        UIColor(white: 0.85, alpha: 1).setFill()
        var x: CGFloat = dotSpacing
        while x < size.width {
            var y: CGFloat = dotSpacing
            while y < size.height {
                let rect = CGRect(x: x - dotRadius, y: y - dotRadius, width: dotRadius * 2, height: dotRadius * 2)
                ctx.cgContext.fillEllipse(in: rect)
                y += dotSpacing
            }
            x += dotSpacing
        }
    }

    private func drawColoringTemplate(_ page: ColoringPage, in ctx: UIGraphicsImageRendererContext, size: CGSize) {
        let renderer = ImageRenderer(
            content: ColoringPageTemplateView(page: page)
                .frame(width: size.width, height: size.height)
        )
        renderer.scale = 1
        guard let image = renderer.uiImage else { return }
        image.draw(in: CGRect(origin: .zero, size: size))
    }

    func prepareShareImage() {
        exportImage = exportCurrentDrawing(withBackground: true)
        if exportImage != nil {
            showShareSheet = true
            audioService.playShareCelebration()
        }
    }

    private func startAutoSave() {
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.autoSave()
            }
        }
    }

    private func autoSave() {
        guard let canvasView, !canvasView.drawing.strokes.isEmpty else { return }
        guard let modelContext else { return }

        let drawing = canvasView.drawing
        let drawingData = drawing.dataRepresentation()
        let bounds = CGRect(x: 0, y: 0, width: canvasView.bounds.width, height: canvasView.bounds.height)
        let thumbnailImage = exportCurrentDrawing(withBackground: true) ?? drawing.image(from: bounds, scale: 1.0)
        let thumbnailData = thumbnailImage.pngData()

        if let artwork = currentArtwork {
            artwork.drawingData = drawingData
            artwork.thumbnailData = thumbnailData
            artwork.verseReference = currentVerse.reference
            artwork.verseText = currentVerse.text
            artwork.artworkKindRawValue = currentColoringPage == nil ? ArtworkKind.freeform.rawValue : ArtworkKind.coloringPage.rawValue
            artwork.coloringPageID = currentColoringPage?.id
            artwork.coloringPageTitle = currentColoringPage?.title
            artwork.updatedAt = Date()
        } else {
            let artwork = Artwork(
                verseReference: currentVerse.reference,
                verseText: currentVerse.text,
                artworkKind: currentColoringPage == nil ? .freeform : .coloringPage,
                coloringPageID: currentColoringPage?.id,
                coloringPageTitle: currentColoringPage?.title
            )
            artwork.drawingData = drawingData
            artwork.thumbnailData = thumbnailData
            modelContext.insert(artwork)
            currentArtwork = artwork
        }
    }
}
