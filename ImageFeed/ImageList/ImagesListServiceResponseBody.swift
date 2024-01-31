//
//  ImagesListServiceResponseBody.swift
//  ImageFeed
//
//  Created by artem on 31.01.2024.
//

import Foundation

// MARK: - ImagesListResultElement
struct ImagesListResultElement: Codable {
    
    // MARK: - Urls
    struct Urls: Codable {
        let raw, full, regular, small: URL
        let thumb: URL
    }
    
    let id: String
    // MARK: - parse date from string swift
    let createdAt: Date
    let width, height: Int
    let description: String?
    let urls: Urls
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case description
        case urls
        case likedByUser = "liked_by_user"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        description = try? container.decode(String.self, forKey: .description)
        urls = try container.decode(Urls.self, forKey: .urls)
        likedByUser = try container.decode(Bool.self, forKey: .likedByUser)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        
        let dateFormatter = ISO8601DateFormatter()
        createdAt = dateFormatter.date(from:createdAtString)!
    }
}
