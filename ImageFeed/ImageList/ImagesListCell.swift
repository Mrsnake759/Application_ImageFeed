//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by artem on 24.11.2023.
//


import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    var onLikeButtonTapped: (() -> Void)?
    
    @IBAction func tapOnLikeButton(_ sender: Any) {
        onLikeButtonTapped?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        onLikeButtonTapped = nil
        cellImage.kf.cancelDownloadTask()
    }
}
