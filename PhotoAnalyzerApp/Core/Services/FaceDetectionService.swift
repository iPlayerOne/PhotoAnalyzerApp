import CoreML
import Foundation
import ImageIO
import Vision

protocol FaceDetectionService {
    func detectFace(in imageData: Data) async throws -> Bool
}

final class FaceDetectionServiceImpl: FaceDetectionService {
    func detectFace(in imageData: Data) async throws -> Bool {
        try await Task.detached(priority: .userInitiated) {
            let request = VNDetectFaceRectanglesRequest()
            
            #if targetEnvironment(simulator)
            if let cpuDevice = (try? request.supportedComputeStageDevices[.main])?.first(where: { device in
                if case .cpu = device {
                    return true
                }
                return false
            }) {
                request.setComputeDevice(cpuDevice, for: .main)
            }
            #endif
            
            let handler = VNImageRequestHandler(data: imageData)
            
            try handler.perform([request])
                    
            return !(request.results?.isEmpty ?? true)
        }.value
        
    }
}
