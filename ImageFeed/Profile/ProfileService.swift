//
//  ProfileService.swift
//  ImageFeed
//
//  Created by artem on 22.01.2024.
//

import UIKit


final class ProfileService {
    
    static let shared = ProfileService()
    private(set) var currentProfile: Profile?
    
    private var lastProfileCode: String?
    private var getProfileTask: URLSessionTask?
    
    private enum GetProfileError: Error {
        case profileCodeError
        case unableToDecodeStringFromProfileData
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastProfileCode == token { return }
        getProfileTask?.cancel()
        lastProfileCode = token
        
        let request = makeProfileRequest(token)
        
        let session = URLSession.shared
        getProfileTask = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            self.getProfileTask = nil
            switch result {
            case .success(let profileResult):
               let profile = Profile(
                    username: profileResult.username,
                    name: profileResult.first_name + " " + (profileResult.last_name ?? ""),
                    loginName: "@" + profileResult.username,
                    bio: profileResult.bio ?? ""
                )
                self.currentProfile = profile
                completion(.success(profile))
            case .failure(_):
                completion(.failure(GetProfileError.unableToDecodeStringFromProfileData))
                self.lastProfileCode = nil
                return
            }
        }
        getProfileTask?.resume()
    }
    
    private func makeProfileRequest(_ token: String) -> URLRequest {
        var request = URLRequest(url: Constants.DefaultBaseURL.appendingPathComponent("me"))
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}






