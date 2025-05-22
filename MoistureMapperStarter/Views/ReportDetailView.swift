import SwiftUI

struct ReportDetailView: View {
    @EnvironmentObject var store: ReportStore
    @State var report: Report
    @State private var showingCreateSurface = false

    var body: some View {
        List {
            Section {
                ReportMetaCard(report: report)
            }
            Section("Moisture Maps") {
                ForEach(report.surfaces) { s in
                    NavigationLink {
                        SurfaceCanvasView(surface: s) { updated in
                            replace(surface: updated)
                        }
                    } label: {
                        Text(s.name)
                    }
                }
                .onDelete { idx in
                    report.surfaces.remove(atOffsets: idx); save()
                }

                Button {
                    showingCreateSurface = true
                } label: {
                    Label("New Moisture Map", systemImage: "plus")
                }
            }
        }
        .navigationTitle(report.name)
        .sheet(isPresented: $showingCreateSurface) {
            CreateSurfaceView { newSurface in
                report.surfaces.append(newSurface); save()
            }
        }
    }

    private func replace(surface: Surface) {
        if let i = report.surfaces.firstIndex(where: { $0.id == surface.id }) {
            report.surfaces[i] = surface; save()
        }
    }

    private func save() {
        report.lastEdited = .now
        store.update(report)
    }
}

private struct ReportMetaCard: View {
    let report: Report
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Name").font(.caption.bold())
            Text(report.name).font(.body)
            Text("Location").font(.caption.bold()).padding(.top, 4)
            Text(report.address).font(.body)
            Text("Created").font(.caption.bold()).padding(.top, 4)
            Text(report.created.formatted(date: .long, time: .omitted))
        }
        .padding(.vertical, 8)
    }
}
