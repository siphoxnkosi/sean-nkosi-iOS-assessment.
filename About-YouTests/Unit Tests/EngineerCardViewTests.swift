import XCTest
@testable import About_You

class EngineerCardViewTests: XCTestCase {
    var engineerCardView: EngineerCardView!
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        engineerCardView = EngineerCardView.loadView()
        mockCoreDataManager = MockCoreDataManager()
    }

    override func tearDown() {
        engineerCardView = nil
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testSavedProfileImageIsUsedIfAvailable() {
        let engineer = Engineer(name: "Test Engineer", role: "Developer", defaultImageName: "some_default", quickStats: QuickStats(years: 5, coffees: 200, bugs: 50), questions: [])
        
        let savedImage = UIImage(systemName: "star.fill")?.jpegData(compressionQuality: 1.0)
        mockCoreDataManager.saveEngineerImage(name: engineer.name, imageData: savedImage!)
        
        engineerCardView.setUp(with: engineer, parentVC: UIViewController())
        
        let fetchedImage = mockCoreDataManager.fetchEngineerImage(name: engineer.name)
        XCTAssertEqual(fetchedImage, savedImage)
    }
}
