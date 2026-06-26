import SwiftUI

private struct ImageDecodeServiceKey: EnvironmentKey {
    static let defaultValue: ImageDecodeService = ImageIOImageDecodeService()
}

extension EnvironmentValues {
    var imageDecodeService: ImageDecodeService {
        get { self[ImageDecodeServiceKey.self] }
        set { self[ImageDecodeServiceKey.self] = newValue }
    }
}

