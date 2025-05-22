import SwiftUI

struct CreateReportView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var store: ReportStore

    @State private var name = ""
    @State private var address = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Report Name", text: $name)
                TextField("Address", text: $address)
            }
            .navigationTitle("Create Report")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let r = Report(name: name, address: address)
                        store.add(r); dismiss()
                    }
                    .disabled(name.isEmpty || address.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
            }
        }
    }
}
