import Foundation

enum PhotoProcessingState: Equatable {
    case idle
    case processing
    case ready(hasFace: Bool)
    case failed(message: String)
}
