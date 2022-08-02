//
//  PhotoSiTests.swift
//  PhotoSiTests
//
//  Created by Erik Peruzzi on 30/07/22.
//

import XCTest
import Combine
@testable import PhotoSi

class PhotoSiTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testInitializationCountryViewModel() throws{
        let viewModel = CountriesViewModel()
        var countries = [CountryModel]()
        var error: Error?
        let expectation = self.expectation(description: "Countries list fetched")
        
        let serviceProtocol = Service.shared
        serviceProtocol.fetchCountries()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation.fulfill()
            }, receiveValue: { value in
                countries = value.value!
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 10)
        
        
        XCTAssertNotNil(viewModel, "The profile view model should not be nil.")
        XCTAssertTrue(countries.count > 0)
        XCTAssertNil(error)
    }
}
