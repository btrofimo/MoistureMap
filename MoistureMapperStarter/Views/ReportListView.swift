import SwiftUI

struct ReportListView: View {
    @EnvironmentObject var store: ReportStore
    @State private var showingCreate = false

    var body: some View {
        List {
            ForEach(store.reports) { r in
                NavigationLink(value: r) {
                    ReportCard(report: r)
                }
            }
            .onDelete(perform: store.delete)

            Section {
                Button {
                    showingCreate = true
                } label: {
                    Label("New Moisture Report", systemImage: "plus")
                }
            }
        }
        .navigationTitle("Moisture Reports")
        .navigationDestination(for: Report.self) { r in
            ReportDetailView(report: r)
        }
        .sheet(isPresented: $showingCreate) {
            CreateReportView()
        }
    }
}

private struct ReportCard: View {
    let report: Report
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(report.name).font(.headline)
            Text(report.address)
                .font(.subheadline).foregroundStyle(.secondary)
            Text("Last edited: \(report.lastEdited.formatted(date: .long, time: .omitted))")
                .font(.caption).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
