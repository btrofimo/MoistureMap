import SwiftUI

@main
struct MoistureMapperApp: App {
    @StateObject private var store = ReportStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ReportListView()
            }
            .environmentObject(store)
        }
    }
}
