import XCTest
@testable import About_You

class EngineersSortingTests: XCTestCase {
    var engineers: [Engineer]!

    override func setUp() {
        super.setUp()
        engineers = Engineer.testingData()
    }

    override func tearDown() {
        engineers = nil
        super.tearDown()
    }

    func testSortingByYears() {
        engineers.sort { $0.quickStats.years < $1.quickStats.years }
        XCTAssertEqual(engineers.first?.name, "Reenen")
        XCTAssertEqual(engineers.last?.name, "Wilmar")
    }

    func testSortingByCoffees() {
        engineers.sort { $0.quickStats.coffees < $1.quickStats.coffees }
        XCTAssertEqual(engineers.first?.name, "Eben")
    }

    func testSortingByBugs() {
        engineers.sort { $0.quickStats.bugs < $1.quickStats.bugs }
        XCTAssertEqual(engineers.first?.name, "Eben")
    }
}
