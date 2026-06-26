import Foundation

protocol LocalImageStorageService {
    func saveImage(data: Data, fileName: String) throws
    func loadImage(fileName: String) throws -> Data
    func imageURL(for fileName: String) throws -> URL
}

final class FileSystemImageStorageService: LocalImageStorageService {
    private let fileManager: FileManager
    private let folderName = "Images"
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func saveImage(data: Data, fileName: String) throws {
        let url = try imageURL(for: fileName)
        try data.write(to: url, options: [.atomic])
    }

    func loadImage(fileName: String) throws -> Data {
        let url = try imageURL(for: fileName)
        return try Data(contentsOf: url)
    }
    
    func imageURL(for fileName: String) throws -> URL {
        let directory = try imageDirectoryURL(fileName: fileName)
        return directory.appendingPathComponent(fileName)
    }
    
    private func imageDirectoryURL(fileName: String) throws -> URL {
        let directory = try fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        
        let imagesURL = directory.appendingPathComponent(folderName)
        if !fileManager.fileExists(atPath: imagesURL.path) {
            try fileManager.createDirectory(at: imagesURL, withIntermediateDirectories: true)
        }
        
        return imagesURL
    }
}
