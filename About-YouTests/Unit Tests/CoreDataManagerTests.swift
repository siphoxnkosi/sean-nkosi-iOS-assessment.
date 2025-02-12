import XCTest
@testable import About_You

class CoreDataManagerTests: XCTestCase {
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
    }

    override func tearDown() {
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testSavingAndFetchingEngineerImage() {
        let imageData = UIImage(systemName: "person.fill")?.jpegData(compressionQuality: 1.0)

        mockCoreDataManager.saveEngineerImage(name: "Reenen", imageData: imageData!)
        let fetchedImageData = mockCoreDataManager.fetchEngineerImage(name: "Reenen")

        XCTAssertNotNil(fetchedImageData)
        XCTAssertEqual(fetchedImageData, imageData)
    }

    func testFetchingNonExistentImageReturnsNil() {
        let fetchedImageData = mockCoreDataManager.fetchEngineerImage(name: "Unknown Engineer")
        XCTAssertNil(fetchedImageData)
    }
}
