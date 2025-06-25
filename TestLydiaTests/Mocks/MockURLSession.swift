//
//  MockURLSession.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//
import Foundation
@testable import TestLydia

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        return (data ?? Data(), response ?? HTTPURLResponse())
    }
}
