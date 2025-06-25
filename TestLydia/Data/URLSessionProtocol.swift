//
//  URLSessionProtocol.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
