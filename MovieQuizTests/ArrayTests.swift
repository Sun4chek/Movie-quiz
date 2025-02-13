//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Волошин Александр on 13.02.2025.
//
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //given
        let array = [1,2,3,4,5]
        //When
        let value = array[safe:2]
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    func testGetValueOutOfRange() throws{
        //given
        let array = [1,2,3,4,5]
        //When
        let value = array[safe:2]
        //Then
        XCTAssertNil(value)
    }
}
