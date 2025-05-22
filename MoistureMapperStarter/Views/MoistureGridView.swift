import SwiftUI

struct MoistureGridView: View {
    @ObservedObject var store: MoistureStore
    let background: UIImage
    @Binding var selectedXY: (x: Int, y: Int)?
    @Binding var scope: ReadingScope
    @Binding var device: DeviceFilter

    var body: some View {
        GeometryReader { geo in
            let rows = store.rows
            let cols = store.columns
            ZStack {
                Image(uiImage: background)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width,
                           height: geo.size.height)

                VStack(spacing: 0) {
                    ForEach(0..<rows, id: \ .self) { r in
                        HStack(spacing: 0) {
                            ForEach(0..<cols, id: \ .self) { c in
                                CellView(cell: $store.grid[r][c])
                                    .onTapGesture {
                                        selectedXY = (x: c, y: r)
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}
