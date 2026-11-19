import SwiftUI
import CoreImage.CIFilterBuiltins

/// Renders a QR code with CoreImage. The payload is a placeholder; the real app would encode
/// the secure, revocable ticket URL (spec principle 6), never a database ID.
struct QRCodeView: View {
    let text: String

    var body: some View {
        if let image = makeImage() {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .accessibilityLabel("QR code for ticket \(text)")
        }
    }

    private func makeImage() -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data("valetos://ticket/\(text)".utf8)
        guard let output = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 10, y: 10)) else {
            return nil
        }
        let context = CIContext()
        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
