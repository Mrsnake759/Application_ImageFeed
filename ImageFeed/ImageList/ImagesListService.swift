//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by artem on 28.01.2024.
//

import Foundation
import UIKit

final class ImagesListService {
    private (set) var photos: [Photo] = []
    private var urlSessionPhotos: URLSessionTask?
    let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    
    private enum GetImagesListError: Error {
        case ImagesCodeError
        case unableToDecodeStringFromImagesData
        case noURL
    }
    
    struct Photo {
        let id: String
        let size: CGSize
//        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: URL
        let largeImageURL: URL
        let isLiked: Bool
    }
    
    func fetchPhotosNextPage(token: String, _ completion: @escaping (Result<[Photo], Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage! + 1
        
        let request = makeImagesListRequest(token: token)
        
        let session = URLSession.shared
        urlSessionPhotos = session.objectTaskArray(for: request) { [weak self] (result: Result<[ImagesListResultElement], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosResult):
                self.photos = photosResult.map {
                    Photo(
                        id: $0.id,
                        size: CGSize(width: $0.width, height: $0.height),
//                        createdAt: $0.createdAt,
                        welcomeDescription: $0.description,
                        thumbImageURL: $0.urls.thumb,
                        largeImageURL: $0.urls.full,
                        isLiked: $0.likedByUser
                    )
                }
                NotificationCenter.default.post(name: self.DidChangeNotification, object: nil)
                completion(.success(self.photos))
            case .failure(let error):
                completion(.failure(GetImagesListError.unableToDecodeStringFromImagesData))
                return
            }
        }
        urlSessionPhotos?.resume()
    }
    
    private func makeImagesListRequest(token: String) -> URLRequest {
        let params = [URLQueryItem(name: "page", value: "1"), URLQueryItem(name: "per_page", value: "10")]
        var urlComps = URLComponents(string: "https://api.unsplash.com/photos")!
        urlComps.queryItems = params
        let result = urlComps.url!
        var request = URLRequest(url: result)
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
}
