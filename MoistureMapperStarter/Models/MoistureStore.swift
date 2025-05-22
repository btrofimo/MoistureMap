import SwiftUI
import Combine

@MainActor
final class MoistureStore: ObservableObject {
    @Published var grid: [[MoistureCell]]
    let rows: Int
    let columns: Int

    init(rows: Int = 10, columns: Int = 10) {
        self.rows = rows
        self.columns = columns
        self.grid = (0..<rows).map { r in
            (0..<columns).map { c in
                MoistureCell(row: r, col: c, value: nil)
            }
        }
    }

    /// Rehydrate from saved grid
    init(from existing: [[MoistureCell]]?) {
        if let existing {
            self.grid = existing
            self.rows = existing.count
            self.columns = existing.first?.count ?? 0
        } else {
            self.rows = 10
            self.columns = 10
            self.grid = (0..<10).map { r in
                (0..<10).map { c in MoistureCell(row: r, col: c, value: nil) }
            }
        }
    }

    func update(row: Int, col: Int, with newVal: Double, deviceID: String = "manual") {
        grid[row][col].value = newVal
        grid[row][col].timestamp = .now
        grid[row][col].deviceID = deviceID
    }
}

// MARK: Filtering logic
extension MoistureStore {
    func visibleGrid(scope: ReadingScope, device: DeviceFilter) -> [[MoistureCell]] {
        grid.map { row in
            row.map { cell in
                guard let v = cell.value else { return cell }
                let passScope: Bool
                switch scope {
                case .all:    passScope = true
                case .over30: passScope = v > 30
                case .over60: passScope = v > 60
                }
                let passDevice = device.label == "Devices" || device.label == cell.deviceID
                return (passScope && passDevice) ? cell : cell.clearedForDisplay
            }
        }
    }
}
