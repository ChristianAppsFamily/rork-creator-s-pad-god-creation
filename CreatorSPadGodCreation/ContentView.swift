import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = CanvasViewModel()

    var body: some View {
        CanvasView(viewModel: viewModel)
            .onAppear {
                viewModel.setup(modelContext: modelContext)
            }
            .ignoresSafeArea(.keyboard)
    }
}
