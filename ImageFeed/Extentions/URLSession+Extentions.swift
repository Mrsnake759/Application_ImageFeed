//
//  URLSession+Extentions.swift
//  ImageFeed
//
//  Created by artem on 30.01.2024.
//

import Foundation
import UIKit

private enum ServerError: Error {
    case serverError
}

extension URLSessionProtocol {
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        keyPath: String? = nil,
        mockData: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionDataTaskProtocol {
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
                if case let Result.failure(error) = result {
                    showAlert(error: error)
                }
            }
        }
        
        if let mockData {
            do {
                let decoder = JSONDecoder()
                let result = keyPath == nil ? try decoder.decode(T.self, from: mockData) : try decoder.decode(T.self, from: mockData, keyPath: keyPath!)
                fulfillCompletionOnMainThread(.success(result))
            } catch {
                fulfillCompletionOnMainThread(.failure(error))
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = (response as? HTTPURLResponse) {
                if 200 ..< 300 ~= response.statusCode {
                    if let remaining = response.value(forHTTPHeaderField: "X-Ratelimit-Remaining").flatMap({ Int($0) }) {
                        print("❗️осталось запросов: ", remaining)
                    }
                    do {
                        let decoder = JSONDecoder()
                        let result = keyPath == nil ? try decoder.decode(T.self, from: data) : try decoder.decode(T.self, from: data, keyPath: keyPath!)
                        fulfillCompletionOnMainThread(.success(result))
                    } catch {
                        fulfillCompletionOnMainThread(.failure(error))
                    }
                } else {
                    fulfillCompletionOnMainThread(.failure(ServerError.serverError))
                }
            } else if let error = error {
                fulfillCompletionOnMainThread(.failure(error))
            } else {
                //                completion(.failure(makeGenericError()))
                fulfillCompletionOnMainThread(.failure(error ?? ServerError.serverError))
            }
        })
        return task
    }
}

private func showAlert(error: Error) {
    UIViewController.topViewController?.showAlert(title: "Error", message: error.localizedDescription)
}
