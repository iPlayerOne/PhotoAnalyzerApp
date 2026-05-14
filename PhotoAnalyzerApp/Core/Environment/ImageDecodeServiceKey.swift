import SwiftUI

private struct ImageDecodeServiceKey: EnvironmentKey {
    static let defaultValue: ImageDecodeService = ImageDecodeServiceImpl()
}

extension EnvironmentValues {
    var imageDecodeService: ImageDecodeService {
        get { self[ImageDecodeServiceKey.self] }
        set { self[ImageDecodeServiceKey.self] = newValue }
    }
}

