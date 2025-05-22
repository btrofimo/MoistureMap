import Foundation

enum ReadingScope: String, CaseIterable, Identifiable, Codable {
    case all, over30, over60
    var id: Self { self }
    var label: String {
        switch self {
        case .all:    return "All Readings"
        case .over30: return ">30 %"
        case .over60: return ">60 %"
        }
    }
}

enum ReadingSort: String, CaseIterable, Identifiable, Codable {
    case newest, oldest
    var id: Self { self }
    var label: String {
        self == .newest ? "Newest" : "Oldest"
    }
}

struct DeviceFilter: Identifiable, Hashable, Codable {
    let id = UUID()
    var label: String
    static var all: [DeviceFilter] {
        [.init(label: "Devices"), .init(label: "manual")]
    }
}
