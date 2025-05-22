import SwiftUI

struct ReadingFilterBar: View {
    @Binding var scope: ReadingScope
    @Binding var sort: ReadingSort
    @Binding var device: DeviceFilter

    var body: some View {
        HStack(spacing: 0) {
            Picker("", selection: $scope) {
                ForEach(ReadingScope.allCases) {
                    Text($0.label).tag($0)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth:.infinity)
            .border(.gray.opacity(0.3))

            Picker("", selection: $sort) {
                ForEach(ReadingSort.allCases) { Text($0.label).tag($0) }
            }
            .pickerStyle(.menu)
            .frame(width: 120)
            .border(.gray.opacity(0.3))

            Picker("", selection: $device) {
                ForEach(DeviceFilter.all) { Text($0.label).tag($0) }
            }
            .pickerStyle(.menu)
            .frame(width: 120)
            .border(Color.blue, width: 2)
        }
        .frame(height: 44)
    }
}
