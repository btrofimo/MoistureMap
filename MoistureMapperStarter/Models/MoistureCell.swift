import SwiftUI

struct MoistureCell: Identifiable, Codable, Hashable {
    var id = UUID()
    var row: Int
    var col: Int
    var value: Double?     // 0 – 100
    var deviceID: String?
    var timestamp = Date()

    var tint: Color {
        guard let v = value else { return .clear }
        let fraction = v / 100.0
        return Color(red: fraction, green: 0.2, blue: 1.0 - fraction, opacity: 0.35)
    }

    /// Returns a copy without a reading (used for filtered views)
    var clearedForDisplay: MoistureCell {
        var copy = self
        copy.value = nil
        return copy
    }
}
