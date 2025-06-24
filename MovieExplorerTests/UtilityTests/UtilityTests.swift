//
//  UtilityTests.swift
//  MovieExplorerTests
//
//  Created by Amogh Raut   on 23/06/25.
//

import XCTest
@testable import MovieExplorer

final class MEUtilityTests: XCTestCase {

    // MARK: - getImageURL

    func getImageURLWithValidPath() {
        let path = "/test123.jpg"
        let expectedURL = "https://image.tmdb.org/t/p/w500/test123.jpg"
        
        let result = MEUtility.getImageURL(path: path)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.absoluteString, expectedURL)
    }

    func getImageURLWithNilPath() {
        let result = MEUtility.getImageURL(path: nil)
        XCTAssertNil(result)
    }

    // MARK: - getHoursMins()

    func getHoursMinWithValidMinutes() {
        let result = MEUtility.getHoursMins(minutes: 125)
        XCTAssertEqual(result, "2h 5m")
    }


    func getHoursMinswithNil() {
        let result = MEUtility.getHoursMins(minutes: nil)
        XCTAssertEqual(result, "")
    }
}
