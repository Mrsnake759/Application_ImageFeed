//
//  URLSessionProtocols.swift
//  ImageFeed
//
//  Created by artem on 01.02.2024.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let dataTask: URLSessionDataTask = dataTask(with: request, completionHandler: completionHandler)
        return dataTask
    }
}
extension URLSessionTask: URLSessionDataTaskProtocol {}

