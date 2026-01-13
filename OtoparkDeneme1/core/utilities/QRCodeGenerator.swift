//
//  QRCodeGenerator.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 6.01.2026.
//

import Foundation
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum QRCodeGenerator {
    static let context = CIContext()
    static let filter = CIFilter.qrCodeGenerator()

    static func makeImage(from string: String, scale: CGFloat = 12) -> UIImage? {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")

        guard let output = filter.outputImage else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
