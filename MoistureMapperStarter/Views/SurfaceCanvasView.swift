import SwiftUI
import UIKit

struct SurfaceCanvasView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store: MoistureStore
    @State private var selectedXY: (x: Int, y: Int)?
    @State private var scope: ReadingScope = .all
    @State private var sort: ReadingSort = .newest
    @State private var device: DeviceFilter = DeviceFilter.all.first!

    let surface: Surface
    let onSave: (Surface) -> Void

    init(surface: Surface, onSave: @escaping (Surface) -> Void) {
        self.surface = surface
        self.onSave = onSave
        _store = StateObject(wrappedValue: MoistureStore(from: surface.grid))
    }

    var body: some View {
        VStack(spacing: 0) {
            SurfaceHUD(selected: $selectedXY,
                       csvAction: exportCSV,
                       pdfAction: exportPDF,
                       photoAction: { },
                       filterAction: { })
            MoistureGridView(store: store,
                             background: UIImage(data: surface.imageData) ?? UIImage(),
                             selectedXY: $selectedXY,
                             scope: $scope,
                             device: $device)
            ReadingFilterBar(scope: $scope, sort: $sort, device: $device)
        }
        .navigationTitle(surface.name)
        .toolbar {
            Button("Done") {
                var updated = surface
                updated.grid = store.grid
                onSave(updated)
                dismiss()
            }
        }
    }

    private func exportCSV() {
        var tempSurface = surface
        tempSurface.grid = store.grid
        let csv = tempSurface.toCSV()
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("readings.csv")
        try? csv.data(using: .utf8)?.write(to: url)
        share(url: url)
    }

    private func exportPDF() {
        // PDF exporter stub
    }

    private func share(url: URL) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else { return }
        let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        root.present(avc, animated: true)
    }
}
