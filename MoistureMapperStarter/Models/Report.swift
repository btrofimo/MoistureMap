import Foundation

struct Surface: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var imageData: Data
    var grid: [[MoistureCell]]? = nil
}

struct Report: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var address: String
    var created = Date()
    var lastEdited = Date()
    var surfaces: [Surface] = []
}

extension Surface {
    /// Exports readings to a CSV string
    func toCSV() -> String {
        guard let grid else { return "" }
        return grid.enumerated().flatMap { r, row in
            row.enumerated().compactMap { c, cell -> String? in
                guard let v = cell.value else { return nil }
                return "\(c),\(r),\(v),\(cell.timestamp.ISO8601Format()),\(cell.deviceID ?? "")"
            }
        }
        .joined(separator: "\n")
    }
}
