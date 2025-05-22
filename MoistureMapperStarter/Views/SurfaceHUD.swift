import SwiftUI

struct SurfaceHUD: View {
    @Binding var selected: (x: Int, y: Int)?
    let csvAction: () -> Void
    let pdfAction: () -> Void
    let photoAction: () -> Void
    let filterAction: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Button(action: filterAction) {
                Image(systemName: "slider.horizontal.3")
                    .frame(width: 48, height: 44)
            }
            .border(.gray.opacity(0.3))

            Text(selected.map { "X:\($0.x), Y:\($0.y)" } ?? "ALL")
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity, maxHeight: 44)
                .border(.gray.opacity(0.3))

            Group {
                Button(action: photoAction) { Image(systemName:"photo") }
                Button(action: csvAction)   { Label("CSV", systemImage:"doc.text") }
                Button(action: pdfAction)   { Image(systemName:"square.and.arrow.down") }
            }
            .frame(width: 48, height: 44)
            .border(.gray.opacity(0.3))
        }
        .background(Color.white)
    }
}
