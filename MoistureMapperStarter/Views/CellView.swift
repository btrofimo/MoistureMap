import SwiftUI

struct CellView: View {
    @Binding var cell: MoistureCell
    @State private var editing = false
    @FocusState private var focus: Bool
    @State private var draft = ""

    var body: some View {
        ZStack {
            cell.tint
            Rectangle().stroke(Color.gray.opacity(0.4), lineWidth: 0.5)
            Text(cell.value.map { String(format:"%.0f", $0) } ?? "")
                .font(.caption2.bold())
        }
        .contentShape(Rectangle())
        .onLongPressGesture { startEditing() }
        .sheet(isPresented: $editing) {
            VStack(spacing: 16) {
                Text("Enter moisture %").font(.headline)
                TextField("Value", text: $draft)
                    .keyboardType(.decimalPad)
                    .focused($focus)
                    .onAppear { draft = cell.value.map { String(Int($0)) } ?? "" }
                    .textFieldStyle(.roundedBorder)
                    .frame(width:120)
                Button("Save") { commit(); editing = false }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .presentationDetents([.height(220)])
        }
    }

    private func startEditing() {
        editing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { focus = true }
    }

    private func commit() {
        guard let v = Double(draft), (0...100).contains(v) else { return }
        cell.value = v
        cell.timestamp = .now
        cell.deviceID = "manual"
    }
}
