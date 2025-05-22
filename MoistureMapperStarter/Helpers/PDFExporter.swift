import UIKit
import PDFKit

final class PDFExporter {
    /// Renders a SwiftUI / UIKit view hierarchy into a single‑page PDF.
    func render(view: UIView, titleBlock: UIImage? = nil) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = [
            kCGPDFContextCreator: "MoistureMapper",
            kCGPDFContextAuthor:  "TCR Construction Group"
        ] as [String: Any]

        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)  // US Letter
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        return renderer.pdfData { ctx in
            ctx.beginPage()
            if let tb = titleBlock {
                tb.draw(in: CGRect(x: 0, y: pageRect.maxY - tb.size.height,
                                   width: pageRect.width, height: tb.size.height))
            }
            ctx.cgContext.translateBy(x: 12, y: 12)
            let scale = min((pageRect.width - 24) / view.bounds.width,
                            (pageRect.height - 24) / view.bounds.height)
            ctx.cgContext.scaleBy(x: scale, y: scale)
            view.layer.render(in: ctx.cgContext)
        }
    }
}
