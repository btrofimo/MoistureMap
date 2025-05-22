import Foundation
import SwiftUI

@MainActor
final class ReportStore: ObservableObject {
    @Published private(set) var reports: [Report] = []
    private let url: URL

    init() {
        url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("reports.json")
        load()
    }

    func add(_ r: Report)   { reports.append(r); save() }
    func update(_ r: Report){ reports.replace(r); save() }
    func delete(_ idx: IndexSet) { reports.remove(atOffsets: idx); save() }

    // MARK: persistence
    private func load() {
        guard let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Report].self, from: data) else { return }
        reports = decoded
    }
    private func save() {
        let data = try? JSONEncoder().encode(reports)
        try? data?.write(to: url)
    }
}

// helper
private extension Array where Element: Identifiable & Hashable {
    mutating func replace(_ element: Element) {
        if let i = firstIndex(where: { $0.id == element.id }) { self[i] = element }
    }
}
