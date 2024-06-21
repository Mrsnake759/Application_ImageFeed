//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by artem on 24.11.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate?

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.ImagesListCellDidTapLike(self)
    }
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.image = nil
        cellImage.kf.cancelDownloadTask()
    }
    
    func setLike(like: Bool) {
        if like {
            likeButton.setImage(UIImage(named: "LikeActive"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "LikeNoActive"), for: .normal)
        }
    }
}

