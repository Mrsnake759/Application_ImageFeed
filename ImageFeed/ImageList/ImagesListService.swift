//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by artem on 28.01.2024.
//

import UIKit

//private let useMockData = true

final class ImagesListService {
    let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    private var photosTask: URLSessionDataTaskProtocol?
    private var isReachedTheEnd: Bool = false
    private var isLikedTask: URLSessionDataTaskProtocol?
    
    private var lastLoadedPage: Int?
    
    private enum GetImagesListError: Error {
        case ImagesCodeError
        case unableToDecodeStringFromImagesData
        case noURL
    }
    
    func fetchPhotosNextPage(token: String, _ completion: ((Result<[Photo], Error>) -> Void)? = nil) {
        assert(Thread.isMainThread)
        guard !isReachedTheEnd else {
            completion?(.success([]))
            return
        }
        
        let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage! + 1

        let request = makeImagesListRequest(token: token, page: nextPage)
//        let mockSession = URLSessionMock()
//        mockSession.page = nextPage
        
        let session: URLSessionProtocol = URLSession.shared
        photosTask = session.objectTask(for: request) { [weak self] (result: Result<[ImagesListResultElement], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosResult):
                let photosPage = photosResult.map(Photo.init(imagesListResultElement:))
                self.photos += photosPage
                self.lastLoadedPage = nextPage
                NotificationCenter.default.post(name: self.DidChangeNotification, object: nil)
                completion?(.success(photosPage))
                if photosResult.isEmpty {
                    self.isReachedTheEnd = true
                }
            case .failure:
                completion?(.failure(GetImagesListError.unableToDecodeStringFromImagesData))
                return
            }
        }
        photosTask?.resume()
    }
    
    private func makeImagesListRequest(token: String, page: Int) -> URLRequest {
        let params = [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "per_page", value: "10")]
        var urlComps = URLComponents(string: "https://api.unsplash.com/photos")!
        urlComps.queryItems = params
        let result = urlComps.url!
        var request = URLRequest(url: result)
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    private func postLike(token: String, photoId: String) -> URLRequest {
        let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        return request
    }
    
    private func deleteLike(token: String, photoId: String) -> URLRequest {
        let url = URL(string: "https://api.unsplash.com/photos/\(photoId)/like")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        return request
    }
    
    func changeLike(token: String, photo: Photo, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        let request: URLRequest = photo.isLiked ? deleteLike(token: token, photoId: photo.id) : postLike(token: token, photoId: photo.id)
        let session: URLSessionProtocol = URLSession.shared
        isLikedTask = session.objectTask(for: request, keyPath: "photo") { [weak self] (result: Result<ImagesListResultElement, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photoResult):
                let updatedPhoto = Photo(imagesListResultElement: photoResult)
                if let index = self.photos.firstIndex(where: { photo in
                    photo.id == updatedPhoto.id
                }) {
                    self.photos[index] = updatedPhoto
                }
                completion(.success(updatedPhoto))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        isLikedTask!.resume()
    }
}
