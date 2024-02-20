import AVKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation

struct SampleBufferTransformer {
    let ciContext = CIContext()

    func transform(videoSampleBuffer: CMSampleBuffer) -> CMSampleBuffer {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(videoSampleBuffer) else {
            print("failed to get pixel buffer")
            fatalError()
        }

        let filter = CIFilter.colorInvert()
        filter.inputImage = CIImage(cvPixelBuffer: pixelBuffer)

        guard let filteredImage = filter.outputImage else {
            print("failed to get filtered image")
            fatalError()
        }

        ciContext.render(filteredImage, to: pixelBuffer)

        guard let result = try? pixelBuffer.mapToSampleBuffer(timestamp: videoSampleBuffer.presentationTimeStamp) else {
            fatalError()
        }

        return result
    }
}
