//
//  NetworkRequestTest.swift
//  KreactiveTests
//
//  Created by perotin nicolas on 15/03/2019.
//  Copyright © 2019 perotin nicolas. All rights reserved.
//

import XCTest
@testable import Kreactive

extension XCTestCase {
    func getExpectation() -> XCTestExpectation {
        let expectation = XCTestExpectation(description: "test")
        return expectation
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}

class MockSession: URLSessionProtocol {
    var data:Data?
    var dataTask = MockURLSessionDataTask()
    
    init (data:Data?){
        self.data = data
    }
    
    func dataTask(withUrl: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(data, nil, nil)
        return dataTask
    }
}

class NetworkRequestTest: XCTestCase {

    let validUrl = (Constant.ApiUrl.baseUrlComponents?.url?.absoluteString)!
    
    func testApiRequestFailedInvalidUrl() {
        let session = MockSession(data: nil)
        let dataTask = MockURLSessionDataTask()
        session.dataTask = dataTask
        
        let apiRequest = ApiRequest<ApiSearchCollection<Movie.Model>>()
        apiRequest.session = session
        let expectation = getExpectation()
        apiRequest.load(url: "") { (result) in
            switch result{
            case .success(_):
                XCTAssert(false)
                break
            case .error(let error):
                XCTAssert((error as! ApiError) == ApiError.InvalidUrl)
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testApiRequestFailedNoDatas() {
        let session = MockSession(data: nil)
        let dataTask = MockURLSessionDataTask()
        session.dataTask = dataTask
        
        let apiRequest = ApiRequest<ApiSearchCollection<Movie.Model>>()
        apiRequest.session = session
        let expectation = getExpectation()
        apiRequest.load(url: validUrl) { (result) in
            switch result{
            case .success(_):
                XCTAssert(false)
                break
            case .error(let error):
                XCTAssert((error as! ApiError) == ApiError.NoDatasError)
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testApiSearchMoviesSuccess() {
        guard let url = Bundle(for: NetworkRequestTest.self).url(forResource: "searchMovie", withExtension: "json") else{
            XCTFail()
            return
        }
        let jsonData = try? Data(contentsOf: url)
        
        let session = MockSession(data: jsonData)
        let dataTask = MockURLSessionDataTask()
        session.dataTask = dataTask
        
        let apiRequest = ApiRequest<ApiSearchCollection<Movie.Model>>()
        apiRequest.session = session
        let expectation = getExpectation()
        apiRequest.load(url: validUrl) { (result) in
            switch result{
            case .success(let collection):
                XCTAssert(collection.items.count == 2)
                break
            case .error(_):
                XCTAssert(false)
                break
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssert(dataTask.resumeWasCalled)
    }
}
