//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by artem on 28.01.2024.
//

import Foundation

final class ImagesListService {
    
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    private var currentPage = 1
    private var task: URLSessionTask?
    private let oAuthTokenStorage = OAuth2TokenStorage()
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        task?.cancel()
        
        var request = URLRequest.makeHTTPRequest(path: "/photos/?page=" + "\(currentPage)" + "&per_page=10", httpMethod: "GET")
        print(currentPage)
        if let token = oAuthTokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let session = URLSession.shared
        
        let task = session.objectTask(for: request, completion: { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResult):
                self.photos.append(contentsOf: photoResult.map { $0.asPhoto() })
                self.currentPage += 1
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: ["photos": self.photos])
            case .failure(_):
                break
            }
        })
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<PhotoLikeResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        var request: URLRequest?
        guard let token = OAuth2TokenStorage().token else { return }
        
        if isLike {
            request = deleteLikeRequest(token, photoId: photoId)
        } else {
            request = postLikeRequest(token, photoId: photoId)
        }
        guard let request else { return }
        let session = URLSession.shared
        let task = session.objectTask(for: request, completion: { (result: Result<PhotoLikeResult, Error>) in
            completion(result)
        })
        self.task = task
        task.resume()
    }
    
    func postLikeRequest(_ token: String, photoId: String) -> URLRequest {
        var postRequest = URLRequest.makeHTTPRequest(
            path: "/photos/" + "\(photoId)" + "/like",
            httpMethod: "POST")
        postRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return postRequest
    }
    
    func deleteLikeRequest(_ token: String, photoId: String) -> URLRequest {
        var deleteRequest = URLRequest.makeHTTPRequest(
            path: "/photos/" + "\(photoId)" + "/like",
            httpMethod: "DELETE")
        deleteRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return deleteRequest
    }
    
    struct PhotoLikeResult: Codable {
        let photo: PhotoResult
    }
    
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: String?
        let welcomeDescription: String?
        let thumbImageURL: String?
        let largeImageURL: String?
        let isLiked: Bool
    }
    
    struct PhotoResult: Codable {
        let id: String
        let width: Int
        let height: Int
        let createdAt: String?
        let welcomeDescription: String?
        let isLiked: Bool
        let urls: UrlsResult
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case width = "width"
            case height = "height"
            case createdAt = "created_at"
            case welcomeDescription = "description"
            case isLiked = "liked_by_user"
            case urls = "urls"
        }
        
        func asPhoto() -> Photo {
            Photo(
                id: id,
                size: CGSize(width: width, height: height),
                createdAt: createdAt,
                welcomeDescription: welcomeDescription,
                thumbImageURL: urls.thumb,
                largeImageURL: urls.full,
                isLiked: isLiked)
        }
    }
    
    struct UrlsResult: Codable {
        let thumb: String
        let full: String
    }
}
