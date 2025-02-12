import Foundation

class MockCoreDataManager {
    private var imageStorage: [String: Data] = [:]

    func saveEngineerImage(name: String, imageData: Data) {
        imageStorage[name] = imageData
    }

    func fetchEngineerImage(name: String) -> Data? {
        return imageStorage[name]
    }
}
