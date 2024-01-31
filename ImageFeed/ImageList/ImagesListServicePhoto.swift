//
//  ImagesListServicePhoto.swift
//  ImageFeed
//
//  Created by artem on 31.01.2024.
//

import Foundation

extension ImagesListService {
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: Date
        let welcomeDescription: String?
        let thumbImageURL: URL
        let largeImageURL: URL
        let isLiked: Bool
    }
}

extension ImagesListService.Photo {
    init(imagesListResultElement: ImagesListResultElement) {
        id = imagesListResultElement.id
        size = CGSize(width: imagesListResultElement.width, height: imagesListResultElement.height)
        createdAt = imagesListResultElement.createdAt
        welcomeDescription = imagesListResultElement.description
        thumbImageURL = imagesListResultElement.urls.thumb
        largeImageURL = imagesListResultElement.urls.full
        isLiked = imagesListResultElement.likedByUser
    }
}
