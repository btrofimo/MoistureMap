import SwiftUI
import PhotosUI

struct CreateSurfaceView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var pickerItem: PhotosPickerItem?
    @State private var imageData: Data?

    let onCreate: (Surface) -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField("Surface Name", text: $name)
                PhotosPicker(selection: $pickerItem,
                             matching: .images,
                             photoLibrary: .shared()) {
                    if let data = imageData,
                       let ui = UIImage(data: data) {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    } else {
                        VStack {
                            Image(systemName: "arrow.up.to.cloud")
                                .font(.system(size: 64))
                            Text("Select an image")
                        }
                        .frame(maxWidth: .infinity, minHeight: 180)
                    }
                }
            }
            .navigationTitle("Create Surface")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let s = Surface(name: name, imageData: imageData!)
                        onCreate(s); dismiss()
                    }
                    .disabled(name.isEmpty || imageData == nil)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
            }
            .onChange(of: pickerItem) { _ in Task { await loadImage() } }
        }
    }

    private func loadImage() async {
        guard let item = pickerItem,
              let data = try? await item.loadTransferable(type: Data.self) else { return }
        imageData = data
    }
}
