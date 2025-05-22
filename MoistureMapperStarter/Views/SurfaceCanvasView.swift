import SwiftUI
import UIKit
import CoreBluetooth

struct SurfaceCanvasView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store: MoistureStore
    @StateObject private var bluetooth = BluetoothManager.shared
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
        .onReceive(bluetooth.$lastReading.compactMap { $0 }) { value in
            guard let xy = selectedXY else { return }
            store.update(row: xy.y, col: xy.x, with: value, deviceID: "ME5")
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
        let pdfView = UIHostingController(rootView:
            MoistureGridView(store: store,
                             background: UIImage(data: surface.imageData) ?? UIImage(),
                             selectedXY: .constant(nil),
                             scope: $scope,
                             device: $device)
                .padding()
        ).view!
        pdfView.bounds = CGRect(x: 0, y: 0, width: 612, height: 792)
        let data = PDFExporter().render(view: pdfView)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("map.pdf")
        try? data.write(to: url)
        share(url: url)
    }

    private func share(url: URL) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else { return }
        let avc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        root.present(avc, animated: true)
    }
}
