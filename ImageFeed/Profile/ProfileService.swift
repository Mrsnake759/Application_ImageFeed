//
//  ProfileService.swift
//  ImageFeed
//
//  Created by artem on 22.01.2024.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private var task: URLSessionTask?
    private var lastCode: String?
    private (set) var profile: Profile?
    
    private enum NetworkError: Error {
        case codeError
    }
    
    private func convertToProfile(_ profileResult: ProfileResult) -> Profile {
        let lastName = profileResult.lastName.map { " \($0)" } ?? ""
        let name = profileResult.firstName + lastName
        
        return Profile(
            username: profileResult.userName,
            loginName: "@\(profileResult.userName)",
            name: name,
            bio: profileResult.bio ?? "")
         }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == token { return }
        task?.cancel()
        lastCode = token
        
        let request = makeRequest(token: token)
        let session = URLSession.shared
        let task = session.objectTask(for: request, completion: { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let currentUser):
                let newProfile = self.convertToProfile(currentUser)
                self.profile = newProfile
                completion(.success(newProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        self.task = task
        task.resume()
    }
    
    struct ProfileResult: Codable {
        let userName, firstName: String
        let lastName: String?
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case userName = "username"
            case firstName = "first_name"
            case lastName = "last_name"
            case bio = "bio"
        }
    }
    
    struct Profile: Codable {
        let username, loginName, name: String
        let bio: String
    }
}

extension ProfileService {
    private func makeRequest(token: String) -> URLRequest {
        guard let url = URL(string: "\(defaultBaseURLGlobal)" + "/me") else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
